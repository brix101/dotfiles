local M = {}

M.lsp = {
  ---@param opts LspCommand
  execute = function(opts)
    local filter = opts.filter or {}
    filter = type(filter) == "string" and { name = filter } or filter
    local buf = vim.api.nvim_get_current_buf()

    ---@cast filter vim.lsp.get_clients.Filter
    local client = vim.lsp.get_clients(vim.tbl_deep_extend("force", {}, filter, { bufnr = buf }))[1]

    local params = {
      command = opts.command,
      arguments = opts.arguments,
    }
    if opts.open then
      require("trouble").open({
        mode = "lsp_command",
        params = params,
      })
    else
      vim.list_extend(params, { title = opts.title })
      return client:exec_cmd(params, { bufnr = buf }, opts.handler)
    end
  end,
  action = setmetatable({}, {
    __index = function(_, action)
      return function()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { action },
            diagnostics = {},
          },
        })
      end
    end,
  }),
  --- Returns the code action kinds supported by the matching clients
  ---@param filter? vim.lsp.get_clients.Filter
  ---@return string[]
  code_actions = function(filter)
    filter = filter or {}
    local ret = {} ---@type string[]
    local clients = vim.lsp.get_clients(filter)
    for _, client in ipairs(clients) do
      -- check server capabilities first
      vim.list_extend(ret, vim.tbl_get(client, "server_capabilities", "codeActionProvider", "codeActionKinds") or {})
      -- check dynamic capabilities
      local regs = client.dynamic_capabilities:get("codeActionProvider", filter)
      for _, reg in ipairs(regs or {}) do
        vim.list_extend(ret, vim.tbl_get(reg, "registerOptions", "codeActionKinds") or {})
      end
    end
    return M.dedup(ret)
  end,
}

M.cmp = {
  actions = {
    -- Native Snippets
    snippet_forward = function()
      if vim.snippet.active({ direction = 1 }) then
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
        return true
      end
    end,
    snippet_stop = function()
      if vim.snippet then
        vim.snippet.stop()
      end
    end,
  },
  ---@param actions string[]
  ---@param fallback? string|fun()
  map = function(actions, fallback)
    return function()
      for _, name in ipairs(actions) do
        if M.cmp.actions[name] then
          local ret = M.cmp.actions[name]()
          if ret then
            return true
          end
        end
      end
      return type(fallback) == "function" and fallback() or fallback
    end
  end,
}

--- Removes duplicate entries from a list, keeping first occurrence order
---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      seen[v] = true
      ret[#ret + 1] = v
    end
  end
  return ret
end

function M.extend(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

return M
