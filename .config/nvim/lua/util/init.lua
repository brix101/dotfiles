local LazyUtil = require("lazy.core.util")

---@class lazyvim.util: LazyUtilCore
---@field config LazyVimConfig
---@field ui lazyvim.util.ui
---@field lsp lazyvim.util.lsp
---@field root lazyvim.util.root
---@field terminal lazyvim.util.terminal
---@field format lazyvim.util.format
---@field plugin lazyvim.util.plugin
---@field extras lazyvim.util.extras
---@field inject lazyvim.util.inject
---@field news lazyvim.util.news
---@field json lazyvim.util.json
---@field lualine lazyvim.util.lualine
---@field mini lazyvim.util.mini
---@field pick lazyvim.util.pick
---@field cmp lazyvim.util.cmp
local M = {}

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param extra string
function M.has_extra(extra)
  local Config = require("lazyvim.config")
  local modname = "lazyvim.plugins.extras." .. extra
  return vim.tbl_contains(require("lazy.core.config").spec.modules, modname)
    or vim.tbl_contains(Config.json.data.extras, modname)
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end


return M
