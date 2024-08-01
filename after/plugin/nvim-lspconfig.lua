local conform = require("conform")

-- Lua {{{
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    local root_dir = vim.fs.dirname(
      vim.fs.find({ '.git' }, { upwards = true })[1]
    )

    local client = vim.lsp.start({
      name = "lua-language-server",
      cmd = { "lua-language-server" },
      root_dir = root_dir,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {
              'vim',
              'require'
            },
          },
        }
      }
    })
    vim.lsp.buf_attach_client(0, client)
  end
})
-- }}}
-- TypeScript
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typescript",
  callback = function()
    --
    -- Attach language server
    --
    local root_dir = vim.fs.dirname(
      vim.fs.find({ 'tsconfig.json', '.git' }, { upward = true })[1]
    )

    local client = vim.lsp.start({
      name = "tsserver",
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = root_dir,
      settings = {
        init_options = {
          preferences = {
            importModuleSpecifierPreference = 'relative',
            importModuleSpecifierEnding = 'minimal',
            diagnostics = {
              ignoredCodes = { 80006 },
            },
          },
        },
      }
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

    vim.lsp.buf_attach_client(0, client)

    --
    -- :Format function
    --
    os.execute('prettierd start')

    vim.api.nvim_create_user_command('Format', function(args)
      -- Organize imports...
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = ""
      })

      -- Then format the file
      conform.format({ bufnr = args.buf })
    end, { desc = "Format buffer", nargs = "*" })
  end
})

print('LSPs registered')
