local conform = require("conform")

local function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

---@param initialize_lsp fun(): integer?
---@return { start: (fun(): nil), stop: (fun(): nil) }
local function make_lsp_management_fns(initialize_lsp)
    ---@type integer?
    local lsp_client_id

    ---@param buffer_number integer?
    local start = function(buffer_number)
      if lsp_client_id == nil then
        lsp_client_id = initialize_lsp()

        if lsp_client_id == nil then error("LSP did not start properly!") end
      end

      vim.lsp.buf_attach_client(buffer_number or 0, lsp_client_id)
    end

    local stop = function()
      if lsp_client_id == nil then return end

      vim.lsp.stop_client(lsp_client_id)
      lsp_client_id = nil
    end

    return {
      start = start,
      stop = stop,
    }
end

-- Lua {{{
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    local root_dir = vim.fs.dirname(
      vim.fs.find({ '.git' }, { upwards = true })[1]
    )

    local lsp = make_lsp_management_fns(function()
      return vim.lsp.start({
        name = "lua-language-server",
        cmd = { "lua-language-server" },
        root_dir = root_dir,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              },
            },
          }
        }
      })
    end)

    lsp.start()
  end
})
-- }}}
-- TypeScript {{{
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "javascript" },
  callback = function()
    --
    -- Attach language server
    --
    local root_dir = vim.fs.dirname(
      vim.fs.find({ 'tsconfig.json', '.git' }, { upward = true })[1]
    )

    local lsp = make_lsp_management_fns(function()
      local client = vim.lsp.start({
        name = "typescript-language-server",
        cmd = { "typescript-language-server", "--stdio" },
        root_dir = root_dir,
        init_options = {
          preferences = {
            importModuleSpecifierPreference = 'relative',
            importModuleSpecifierEnding = 'minimal',
          },
        },
      })

      vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(function(_, result, ctx, config)
          local messages_to_filter = {
            "This may be converted to an async function",
          }
          local filtered_diagnostics = {}
          for _, diagnostic in ipairs(result.diagnostics) do
            local found = false
            for _, message in ipairs(messages_to_filter) do
              if string.find(diagnostic.message, message) then
                found = true
                break
              end
            end
            if not found then
              table.insert(filtered_diagnostics, diagnostic)
            end
           end

          result.diagnostics = filtered_diagnostics

          vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end, {})

      return client
    end)

    lsp.start()

    --
    -- :Format function
    --
    os.execute('prettierd start')

    vim.api.nvim_create_user_command('Format', function(args)
      conform.format({ bufnr = args.buf })
    end, { desc = "Format buffer", nargs = 0 })

    --
    -- :OrganizeImports function
    --
    vim.api.nvim_create_user_command('OrganizeImports', function()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
      })
    end, { desc = "Format buffer", nargs = 0 })


    --
    -- :LspStart, :LspStop, :LspRestart functions
    --
    vim.api.nvim_create_user_command('LspStart', function()
      lsp.start()
    end, { desc = "Start LSP server", nargs = 0 })
    vim.api.nvim_create_user_command('LspStop', function()
      lsp.stop()
    end, { desc = "Stop LSP server", nargs = 0 })
    vim.api.nvim_create_user_command('LspRestart', function()
      lsp.stop()
    end, { desc = "Restart LSP server", nargs = 0 })
  end
})
-- }}}
