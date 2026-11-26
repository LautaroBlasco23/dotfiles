import { Plugin } from "@opencode/plugin/tui"
import { createSignal, Show } from "solid-js"

/** The inference API that shares the Go subscription's origin serves its allowance meters. */
const USAGE_URL = "https://opencode.ai/zen/go/v1/usage"
/** Safety poll: the event below covers real work, this catches long idle stretches. */
const POLL_INTERVAL = 60_000
const INTEGRATION_ID = "opencode-go"

type Meter = { readonly percent: number; readonly resetsAt?: string }
type Usage = { readonly rolling?: Meter; readonly weekly?: Meter; readonly monthly?: Meter }
type MeterKey = keyof Usage

/**
 * The Go allowance has three meters. Each is looked up under the names the API has used, so a rename
 * degrades to a missing segment rather than a broken line. The short labels keep the line compact.
 */
const METERS: ReadonlyArray<{ readonly key: MeterKey; readonly label: string; readonly names: readonly string[] }> = [
  { key: "rolling", label: "5h", names: ["rolling", "fivehour", "five_hour", "5h", "session", "hourly"] },
  { key: "weekly", label: "wk", names: ["weekly", "week", "7d"] },
  { key: "monthly", label: "mo", names: ["monthly", "month", "30d"] },
]

const PERCENT_FIELDS = [
  "percent",
  "percentused",
  "usedpercent",
  "usagepercent",
  "used_percent",
  "percent_used",
  "usage_percent",
] as const

const RESET_FIELDS = ["resetsat", "resets_at", "resetat", "reset_at", "reset", "resets"] as const

export default Plugin.define({
  id: "go-usage",
  setup(context) {
    const [usage, setUsage] = createSignal<Usage>()

    let running = false
    async function refresh() {
      if (running) return
      running = true
      try {
        const credentials = await context.client.credential.list()
        const entry = credentials.find(
          (item) => item.integrationID === INTEGRATION_ID && item.active && item.value?.type === "key",
        )
        const value = entry?.value
        if (!value || value.type !== "key") return
        // The key only ever reaches this fetch: never a log, a render, a signal or storage.
        const headers: Record<string, string> = {
          accept: "application/json",
          authorization: `Bearer ${value.key}`,
        }
        const org = value.metadata?.orgID
        if (typeof org === "string" && org) headers["x-opencode-org-id"] = org
        const response = await fetch(USAGE_URL, { headers })
        if (!response.ok) return
        const parsed = read(await response.json())
        if (parsed) setUsage(parsed)
      } catch {
        // Silent by design: no toast, no log, no placeholder. The line keeps its last good values.
      } finally {
        running = false
      }
    }

    const stop = context.data.on("session.execution.succeeded", () => void refresh())
    const timer = setInterval(() => void refresh(), POLL_INTERVAL)
    void refresh()

    const Line = () => (
      <Show when={usage()}>
        {(value) => (
          <text fg={context.theme.text.muted} wrapMode="none" truncate>
            {format(value()) ?? ""}
          </text>
        )}
      </Show>
    )

    const remove = context.ui.slot({ append: "sidebar.footer", render: () => <Line /> })

    return () => {
      stop()
      clearInterval(timer)
      remove()
    }
  },
})

function format(usage: Usage) {
  const parts = METERS.flatMap((meter) => {
    const value = usage[meter.key]
    return value ? [`${meter.label} ${percent(value.percent)}%`] : []
  })
  return parts.length > 0 ? `Go ${parts.join(" · ")}` : undefined
}

/** Whole percents above ten, one decimal below, so a small meter still moves visibly. */
function percent(value: number) {
  return value >= 10 ? Math.round(value) : Math.round(value * 10) / 10
}

/** Reads the meters from the response, tolerating a renamed container or meter field. */
function read(body: unknown): Usage | undefined {
  const root = record(body)
  if (!root) return undefined
  const data = record(root.data)
  const containers = [record(root.usage), record(root.limits), record(root.meters), record(data?.usage), data, root]
  for (const container of containers) {
    if (!container) continue
    const usage: Record<string, Meter> = {}
    for (const meter of METERS) {
      const found = find(container, meter.names)
      const parsed = found === undefined ? undefined : parseMeter(found)
      if (parsed) usage[meter.key] = parsed
    }
    if (Object.keys(usage).length > 0) return usage
  }
  return undefined
}

function parseMeter(value: unknown): Meter | undefined {
  const numeric = number(value)
  if (numeric !== undefined) return { percent: numeric }
  const item = record(value)
  if (!item) return undefined
  const used = number(find(item, PERCENT_FIELDS))
  if (used === undefined) return undefined
  const reset = find(item, RESET_FIELDS)
  const resetsAt = typeof reset === "string" ? reset : typeof reset === "number" ? String(reset) : undefined
  return resetsAt === undefined ? { percent: used } : { percent: used, resetsAt }
}

/** Case- and separator-insensitive lookup: `percentUsed`, `percent_used` and `usedPercent` all match. */
function find(source: Record<string, unknown>, names: readonly string[]) {
  for (const [name, value] of Object.entries(source)) {
    const normalized = name.toLowerCase().replace(/[^a-z0-9]/g, "")
    if (names.includes(normalized)) return value
  }
  return undefined
}

function number(value: unknown) {
  if (typeof value === "number" && Number.isFinite(value)) return value
  if (typeof value === "string") {
    const parsed = Number.parseFloat(value)
    if (Number.isFinite(parsed)) return parsed
  }
  return undefined
}

function record(value: unknown): Record<string, unknown> | undefined {
  return typeof value === "object" && value !== null && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : undefined
}
