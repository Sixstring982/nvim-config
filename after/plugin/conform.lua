local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    typescript = { "prettierd" },
    go = { "gofmt" },
    haskell = { "ormolu" }
  }
})
