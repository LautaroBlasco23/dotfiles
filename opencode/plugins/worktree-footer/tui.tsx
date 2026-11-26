import { Plugin } from "@opencode/plugin/tui"
import { createMemo, createSignal } from "solid-js"
import path from "node:path"

const FOLDER = "\u{1F4C1}" // folder
const TREE = "\u{1F332}" // evergreen tree
const BUSY = "[\u22EF]"

const CACHE_MS = 10_000

type Kind = "root" | "worktree"
type Entry = { directory: string; type: Kind }
type Badge = { directory: string; branch?: string }

const PATH_KEYS = ["filePath", "file_path", "filepath", "filename", "file", "path"] as const
const FILE_TOOL = /edit|write|read|patch|create|delete|replace/i

function isRecord(value: unknown): value is Record<string, any> {
  return !!value && typeof value === "object"
}

function pickPath(input: unknown): string | undefined {
  if (!isRecord(input)) return undefined
  for (const key of PATH_KEYS) {
    const value = input[key]
    if (typeof value === "string" && value.trim().length > 0 && !value.includes("\n")) return value
  }
  return undefined
}

function toolInput(part: any): Record<string, any> | undefined {
  if (!isRecord(part)) return undefined
  if (isRecord(part.input)) return part.input
  if (isRecord(part.state) && isRecord(part.state.input)) return part.state.input
  return undefined
}

function contains(directory: string, file: string) {
  const base = directory.replace(/[\\/]+$/, "")
  return file === base || file.startsWith(base + "/") || file.startsWith(base + "\\")
}

function longest(entries: Entry[], file: string): Entry | undefined {
  let best: Entry | undefined
  for (const entry of entries) {
    if (!contains(entry.directory, file)) continue
    if (!best || entry.directory.length > best.directory.length) best = entry
  }
  return best
}

// The HTTP worktree list never carries the `type` field the server derives
// internally, so classify against the project's main directories instead.
// Roots are the canonical checkout and its sandboxes; a linked worktree sits
// outside all of them. `strategy` is only stored on managed worktrees, so its
// presence is the fallback signal when project data is unavailable.
function kindOf(directory: string, roots: readonly string[], strategy: unknown): Kind {
  if (roots.length > 0) return roots.some((root) => contains(root, directory)) ? "root" : "worktree"
  if (typeof strategy === "string" && strategy.length > 0) return "worktree"
  return "root"
}

export default Plugin.define({
  id: "worktree-footer",
  setup(context) {
    const [badges, setBadges] = createSignal<Record<string, Badge | undefined>>({})
    const worktrees = new Map<string, { at: number; entries: Entry[] }>()
    const refreshes = new Map<string, number>()
    const generations = new Map<string, number>()

    const root = (sessionID: string) => {
      try {
        return context.data.session.root(sessionID) || sessionID
      } catch {
        return sessionID
      }
    }

    // Latest activity for a root session family wins. Writing `undefined`
    // clears the worktree label so the session location shows instead.
    const put = (sessionID: string, badge: Badge | undefined) => {
      const id = root(sessionID)
      setBadges((current) => ({ ...current, [id]: badge }))
    }

    const display = (directory: string, branch: string | undefined) => {
      let text = directory
      try {
        text = context.ui.format.path(directory)
      } catch {}
      return branch ? `${text}:${branch}` : text
    }

    const branchOf = async (directory: string) => {
      const ref = { directory }
      try {
        for (let attempt = 0; attempt < 4; attempt++) {
          await context.data.location.vcs.sync(ref)
          const branch = context.data.location.vcs.info(ref)?.branch?.current
          if (branch) return branch
          // A location discovered by the worktree refresh loads its VCS
          // provider asynchronously, so early reads settle with an empty branch.
          context.data.location.vcs.invalidate(ref)
          await new Promise((resolve) => setTimeout(resolve, 300))
        }
        return undefined
      } catch {
        return undefined
      }
    }

    const listWorktrees = async (projectID: string, file?: string): Promise<Entry[]> => {
      const cached = worktrees.get(projectID)
      const fresh = !!cached && Date.now() - cached.at < CACHE_MS
      if (fresh && (!file || cached!.entries.some((entry) => contains(entry.directory, file)))) return cached!.entries
      try {
        const client: any = context.client
        const source = client?.worktree?.list ? client.worktree : client?.api?.worktree
        if (typeof source?.list !== "function") return cached?.entries ?? []
        // Worktrees created outside OpenCode stay invisible until discovery
        // runs. Refresh at most once per project per cache window so the
        // worktree.resolved event this emits cannot loop back into a refresh.
        const last = refreshes.get(projectID) ?? 0
        if (typeof source.refresh === "function" && Date.now() - last >= CACHE_MS) {
          refreshes.set(projectID, Date.now())
          try {
            await source.refresh({ projectID })
          } catch {}
        }
        const result: any = await source.list({ projectID })
        const values = Array.isArray(result) ? result : Array.isArray(result?.data) ? result.data : []
        const roots: string[] = []
        try {
          const project = context.data.project.get(projectID)
          if (typeof project?.canonical === "string" && project.canonical.length > 0) roots.push(project.canonical)
          for (const sandbox of project?.sandboxes ?? []) if (typeof sandbox === "string") roots.push(sandbox)
        } catch {}
        const entries: Entry[] = []
        for (const value of values) {
          if (!isRecord(value) || typeof value.directory !== "string") continue
          entries.push({ directory: value.directory, type: kindOf(value.directory, roots, value.strategy) })
        }
        worktrees.set(projectID, { at: Date.now(), entries })
        return entries
      } catch {
        return cached?.entries ?? []
      }
    }

    const projectOf = (file: string) => {
      try {
        let best: { id: string; length: number } | undefined
        for (const project of context.data.project.list()) {
          for (const directory of [project.canonical, ...(project.sandboxes ?? [])]) {
            if (typeof directory !== "string" || !contains(directory, file)) continue
            if (!best || directory.length > best.length) best = { id: project.id, length: directory.length }
          }
        }
        return best?.id
      } catch {
        return undefined
      }
    }

    // Resolve the worktree containing a touched file. Failures fall back to the
    // session location, which the renderer always shows, so the row never empties.
    const resolve = async (sessionID: string, value: string) => {
      const id = root(sessionID)
      const generation = (generations.get(id) ?? 0) + 1
      generations.set(id, generation)
      try {
        const session = context.data.session.get(sessionID)
        // Child sessions inherit the parent location; fall back to the root
        // and the current location when the child's info has not loaded yet.
        const base = (session?.location ?? context.data.session.get(id)?.location ?? context.location)?.directory
        const file = path.isAbsolute(value) ? value : base ? path.resolve(base, value) : undefined
        if (!file) return
        let projectID = session?.projectID
        if (!projectID) {
          await context.data.project.sync()
          // The session lives in the main checkout, so its own directory names
          // the project even when the touched file sits outside every root.
          projectID = projectOf(base ?? file)
        } else if (!context.data.project.get(projectID)) {
          // Load project data so the canonical directory can classify entries.
          await context.data.project.sync()
        }
        if (!projectID) return
        const entry = longest(await listWorktrees(projectID, file), file)
        if (generations.get(id) !== generation) return
        if (!entry || entry.type !== "worktree") {
          put(sessionID, undefined)
          return
        }
        put(sessionID, { directory: entry.directory })
        const branch = await branchOf(entry.directory)
        if (!branch || generations.get(id) !== generation) return
        put(sessionID, { directory: entry.directory, branch })
      } catch {}
    }

    const stops = [
      context.data.on("session.tool.called", (event) => {
        try {
          const value = pickPath((event.data as any)?.input)
          if (value) void resolve(event.data.sessionID, value)
        } catch {}
      }),
      // Replay-only in current releases, but older streams and imported
      // sessions still deliver assistant tool parts this way.
      context.data.on("session.message.content.updated", (event) => {
        try {
          const content: any[] = Array.isArray((event.data as any)?.content) ? (event.data as any).content : []
          for (const part of content) {
            if (!isRecord(part) || part.type !== "tool") continue
            if (typeof part.name === "string" && part.name.length > 0 && !FILE_TOOL.test(part.name)) continue
            const value = pickPath(toolInput(part))
            if (value) void resolve(event.data.sessionID, value)
          }
        } catch {}
      }),
      context.data.on("session.moved", (event) => {
        try {
          put(event.data.sessionID, undefined)
        } catch {}
      }),
    ]
    const stopWorktrees = context.data.listen(({ details }) => {
      try {
        const type = (details as any)?.type
        if (type === "worktree.updated" || type === "worktree.resolved") worktrees.clear()
      } catch {}
    })

    const label = (sessionID: string | undefined) => {
      try {
        if (sessionID && context.data.session.status(sessionID) === "running") return BUSY
        const session = sessionID ? context.data.session.get(sessionID) : undefined
        const location = session?.location ?? context.location ?? context.data.location.default()
        const badge = sessionID ? badges()[root(sessionID)] : undefined
        if (badge) return `${TREE} ${display(badge.directory, badge.branch)}`
        const branch = context.data.location.vcs.info(location)?.branch?.current
        return `${FOLDER} ${display(location.directory, branch)}`
      } catch {
        return `${FOLDER} .`
      }
    }

    // Replacing prompt.footer.status removes the built-in running spinner, so
    // re-render a minimal one-line indicator while the session is busy.
    context.ui.slot({
      replace: "prompt.footer.status",
      render: (input) => {
        const text = createMemo(() => label(input.sessionID))
        return (
          <text fg={context.theme.text.muted} wrapMode="none" truncate flexGrow={1} flexShrink={1} minWidth={0}>
            {text()}
          </text>
        )
      },
    })

    return () => {
      for (const stop of stops) stop()
      stopWorktrees()
    }
  },
})
