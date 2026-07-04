--- Fix nvim-treesitter query predicates/directives for Neovim 0.12+
---
--- Neovim 0.12 changed `match[capture_id]` to return `TSNode[]` (array) instead of
--- a bare `TSNode`. nvim-treesitter's query_predicates.lua (archived, no upstream fix)
--- treats it as a single node, causing `attempt to call method 'range' (a nil value)`.
---
--- This module re-registers the broken handlers with defensive node unwrapping.
--- Remove this file when nvim-treesitter is updated or replaced.
local query = require("vim.treesitter.query")

--- Safely get a single TSNode from a match table, handling the TSNode[] format.
--- Works on both pre-0.12 (bare TSNode) and 0.12+ (TSNode[] array).
---@param match table
---@param id integer capture ID
---@return TSNode|nil
local function get_node(match, id)
  local node = match[id]
  if type(node) == "table" then
    return node[1]
  end
  return node
end

-- Helpers replicated from nvim-treesitter's query_predicates.lua
-- (plugin is archived, so requiring the module isn't future-proof)

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  uxn = "uxntal",
  ts = "typescript",
}

local function get_parser_from_markdown_info_string(injection_alias)
  local match = vim.filetype.match { filename = "a." .. injection_alias }
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

local function err(str)
  vim.api.nvim_err_writeln(str)
end

local function valid_args(name, pred, count, strict_count)
  local arg_count = #pred - 1
  if strict_count then
    if arg_count ~= count then
      err(string.format("%s must have exactly %d arguments", name, count))
      return false
    end
  elseif arg_count < count then
    err(string.format("%s must have at least %d arguments", name, count))
    return false
  end
  return true
end

-- force = true allows overriding the existing handlers registered by nvim-treesitter
local opts = { force = true }

-- Predicates

query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
  if not valid_args("nth?", pred, 2, true) then
    return
  end

  local node = get_node(match, pred[2])
  local n = tonumber(pred[3])
  if node and node:parent() and node:parent():named_child_count() > n then
    return node:parent():named_child(n) == node
  end

  return false
end, opts)

query.add_predicate("is?", function(match, _pattern, bufnr, pred)
  if not valid_args("is?", pred, 2) then
    return
  end

  -- Avoid circular dependencies
  local locals = require("nvim-treesitter.locals")
  local node = get_node(match, pred[2])
  local types = { unpack(pred, 3) }

  if not node then
    return true
  end

  local _, _, kind = locals.find_definition(node, bufnr)
  return vim.tbl_contains(types, kind)
end, opts)

query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
  if not valid_args(pred[1], pred, 2) then
    return
  end

  local node = get_node(match, pred[2])
  local types = { unpack(pred, 3) }

  if not node then
    return true
  end

  return vim.tbl_contains(types, node:type())
end, opts)

-- Directives

query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
  local capture_id = pred[2]
  local node = get_node(match, capture_id)
  if not node then
    return
  end
  local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
  local configured = html_script_type_languages[type_attr_value]
  if configured then
    metadata["injection.language"] = configured
  else
    local parts = vim.split(type_attr_value, "/", {})
    metadata["injection.language"] = parts[#parts]
  end
end, opts)

query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
  local capture_id = pred[2]
  local node = get_node(match, capture_id)
  if not node then
    return
  end
  local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
  metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
end, opts)

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
  local id = pred[2]
  local node = get_node(match, id)
  if not node then
    return
  end

  local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
  if not metadata[id] then
    metadata[id] = {}
  end
  metadata[id].text = string.lower(text)
end, opts)
