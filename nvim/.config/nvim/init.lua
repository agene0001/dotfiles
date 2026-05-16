-- Ensure lazy.nvim is installed
---@diagnostic disable: undefined-global
-- luacheck: globals vim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
-- Global variable to track whether diagnostics are enabled
local diagnostics_enabled = false
-- Function to toggle diagnostics configuration
local function ToggleDiagnostics()
  if diagnostics_enabled then
    -- Disable diagnostics
    vim.diagnostic.config({
      virtual_text = false,
      underline = false,
      update_in_insert = false,
      severity_sort = false,
    })
    diagnostics_enabled = false
  else
    -- Enable diagnostics
    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })
    diagnostics_enabled = true
  end
end
_G.ToggleDiagnostics = ToggleDiagnostics
-- Keymap to toggle diagnostics (e.g., using <leader>d)
vim.api.nvim_set_keymap("n", "<leader>td", ":lua _G.ToggleDiagnostics()<CR>", { noremap = true, silent = true })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Local plugins
local opts = {}
local plugins = {
  -- with lazy.nvim
  {
    "MunifTanjim/nui.nvim",
    lazy = false, -- Ensure it loads immediately
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",         -- Snippet engine (choose one)
      "saadparwaiz1/cmp_luasnip", -- Snippet source for cmp
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For luasnip users
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- Snippets
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  { "github/copilot.vim" },
  {
    "agene0001/template.nvim",
    branch = "main",
    cmd = { "Template", "TemProject" }, -- Load on command execution
    keys = {
      {
        "<Leader>t",
        function()
          vim.fn.feedkeys(":Template ")
        end,
        desc = "Template",
      },
      {
        "<Leader>tp",
        function()
          vim.fn.feedkeys(":TemProject ")
        end,
        desc = "Template Project",
      },
    },
    config = function()
      require("template").setup({
        temp_dir = "~/.config/nvim/templates",
        author = "Felix Agene",
        email = "agene001@umn.edu",
      })
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({
        vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true }),
        vim.keymap.set("n", "<leader>fg", "<cmd>lua require('fzf-lua').grep()<CR>", { noremap = true, silent = true }),
      })
    end,
  },
  -- Mason & mason-lspconfig setup
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup() -- Initialize Mason
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_ls",
          "gopls",
          "dockerls",
          "efm",
          "clangd",
          "bashls",
          "cssls",
          "html",
          "eslint",
          "jsonls",
          "ltex",
          "marksman",
          "sqls",
          "yamlls",
          "jdtls",
          "gradle_ls",
          "tailwindcss",
        },
        handlers = {
          -- default handler for all servers
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
          end,
          -- gradle_ls needs initializationOptions
          ["gradle_ls"] = function()
            require("lspconfig").gradle_ls.setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
              init_options = {
                settings = {
                  gradleWrapperEnabled = true,
                },
              },
            })
          end,
        },
      })
    end,
  },

  {
    "rshkarin/mason-nvim-lint",
    after = "mason.nvim",
    config = function()
      require("mason-nvim-lint").setup({
        ensure_installed = {
          "eslint_d",
          "pylint",
          "luacheck",
          "shellcheck",
          "jsonlint",
          "yamllint",
          "markdownlint",
          "stylelint",
        },
      })
    end,
  },

  -- Linter Integration
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Associate linters with filetypes
      lint.linters_by_ft = {
        python = { "pylint" },
        lua = { "luacheck" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        bash = { "shellcheck" },
        json = { "jsonlint" },
        yaml = { "yamllint" },
        markdown = { "markdownlint" },
        html = { "htmlhint" },
        css = { "stylelint" },
      }

      -- Auto-run linting on certain events
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- Keymap to trigger linting manually
      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
        vim.lsp.buf.format()
      end, { desc = "Trigger linting for current file" })
    end,
  },
  {
    "agene0001/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
      local format = "prettier"
      conform.setup({
        formatters_by_ft = {
          javascript = { format },
          typescript = { format },
          javascriptreact = { format },
          typescriptreact = { format },
          svelte = { format },
          css = { format },
          html = { format },
          json = { format },
          yaml = { format },
          markdown = { format },
          lua = { "stylua" },
          python = { "isort", "black" },
        },
        format_on_save = { lsp_fallback = true, async = false, timeout_ms = 500 },
      })
      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "julianolf/nvim-dap-lldb",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      require("dap-go").setup()
      require("dap-lldb").setup()
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
      vim.keymap.set("n", "<leader>dc", dap.continue, {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    after = "mason-lspconfig.nvim",
    config = function()
      local on_attach = function(client, bufnr)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      end

      local servers = {
        "clangd", "pyright", "ts_ls", "gopls", "lua_ls",
        "dockerls", "html", "marksman", "jdtls", "bashls",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config[server] = {
          on_attach = on_attach,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        }
        vim.lsp.enable(server)
      end

      -- gradle_ls needs special init_options
      vim.lsp.config["gradle_ls"] = {
        on_attach = on_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        init_options = {
          settings = {
            gradleWrapperEnabled = true,
          },
        },
      }
      vim.lsp.enable("gradle_ls")
    end,
  },

  {
    "catppuccin/nvim",
    lazy = false,
    opts = {},
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "python",
          "javascript",
          "c",
          "markdown",
          "markdown_inline",
          "rust",
          "c_sharp",
          "bash",
          "cmake",
          "cpp",
          "dart",
          "dockerfile",
          "go",
          "gitignore",
          "html",
          "java",
          "http",
          "make",
          "typescript",
        },
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = false },
      })
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  { "nvim-treesitter/nvim-treesitter-locals" },
}
-- Plugin configuration
require("lazy").setup(plugins, opts)
require("catppuccin").setup()
-- Additions setups
vim.cmd("set number")
vim.cmd("set autoindent")
-- Enable folding by default
vim.opt.foldenable = false
vim.opt.tabstop = 2      -- Use 2 spaces for a tab character
vim.opt.shiftwidth = 2   -- Indentation level of 2 spaces
vim.opt.expandtab = true -- Convert tabs to spaces
-- Override nvim-tree with treemux for directory openings
-- Create global functions to handle tree operations via treemux
_G.open_menu = function()
  local Menu = require("nui.menu")
  local Input = require("nui.input")

  local function run_command(command)
    local input_box = Input({
      position = "50%",
      size = { width = 40 },
      border = {
        style = "rounded",
        text = { top = " Enter Arguments (or leave empty) ", top_align = "center" },
      },
      win_options = {
        winblend = 10,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    }, {
      prompt = "> ",
      on_submit = function(args)
        local final_command = command
        if args and args ~= "" then
          final_command = final_command .. " " .. args
        end
        vim.cmd("!" .. final_command)
      end,
    })

    input_box:mount()
  end

  local menu = Menu({
    position = "50%",
    size = {
      width = 30,
      height = 5,
    },
    border = {
      style = "rounded",
      text = { top = " Run Configuration ", top_align = "center" },
    },
    win_options = {
      winblend = 10,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  }, {
    lines = {
      Menu.item("Make"),
      Menu.item("GCC Compile"),
      Menu.item("Wingcc Compile"),
      Menu.item("Run Node Server"),
      Menu.item("Run Python Script"),
    },
    on_submit = function(item)
      local exe_name = vim.fn.expand("%:r");
      if item.text == "Make" then
        run_command("make")
      elseif item.text == "GCC Compile" then
        run_command("gcc % -o " .. exe_name .. ".out && echo '' && ./" .. exe_name .. ".out")
      elseif item.text == "Wingcc Compile" then
        run_command("wingcc % -o " .. exe_name .. ".exe && echo '' && ./" .. exe_name .. ".exe")
      elseif item.text == "Run Node Server" then
        run_command("node server.js")
      elseif item.text == "Run Python Script" then
        run_command("python3 %")
      end
    end,
  })

  menu:mount()
end

vim.api.nvim_set_keymap("n", "<leader>m", ":lua open_menu()<CR>", { noremap = true, silent = true })

function _G.open_treemux()
  vim.fn.system("tmux display-popup -E 'treemux'")
end

-- Add commands for tree operations that redirect to treemux
vim.api.nvim_create_user_command("NvimTreeToggle", function()
  _G.open_treemux()
end, {})

vim.api.nvim_create_user_command("NvimTreeOpen", function()
  _G.open_treemux()
end, {})

vim.api.nvim_create_user_command("NvimTreeFocus", function()
  _G.open_treemux()
end, {})

vim.api.nvim_create_user_command("TreemuxToggle", function()
  _G.open_treemux()
end, {})

-- Handle directory opening
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local args = vim.fn.argv()
    -- Check if the argument is a directory
    if #args > 0 and vim.fn.isdirectory(args[1]) == 1 then
      -- Change to the directory
      vim.cmd("cd " .. vim.fn.fnameescape(args[1]))
      -- Close any initial buffer
      vim.cmd("bd")
      -- Open treemux in a popup
      _G.open_treemux()
    end
  end,
})
vim.g.python3_host_prog = '/Users/seymour-butts/.pyenv/shims/python3'
vim.keymap.set("n", "<leader>y", 'ggVG"+y')
vim.keymap.set("n", "<leader>a", "ggVG", { noremap = true, desc = "Select entire file" })
