-- Ensure lazy.nvim is installed
-- stylua: ignore
---@diagnostic disable: undefined-global
-- or for luacheck:
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
      -- LSP capabilities for nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local servers = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "gopls",
        "clangd",
        "marksman",
        "rust_analyzer",
        "omnisharp",
        "bashls",
        "cmake",
        "dartls",
        "dockerls",
        "html",
        "jdtls",
        "efm", -- corrected server names
      }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          capabilities = capabilities,
        })
      end
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
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
    "ramilito/kubectl.nvim",
    config = function()
      require("kubectl").setup()
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
    after = "mason.nvim", -- Ensure mason.nvim loads first
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
        vim.lsp.buf.format() -- Replace 'formatting_sync' with 'format'
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
      "nvim-neotest/nvim-nio", -- Add this line
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

    after = "mason-lspconfig.nvim", -- Ensure mason-lspconfig loads first
    config = function()
      -- You can set up LSP servers here
      local lspconfig = require("lspconfig")

      -- Set up common on_attach function
      local on_attach = function(client, bufnr)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      end

      lspconfig.clangd.setup({
        on_attach = on_attach,
      })
      -- pyright for Python
      lspconfig.pyright.setup({
        on_attach = on_attach,
      })

      -- tsserver for TypeScript/JavaScript
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
      })

      -- gopls for Go
      lspconfig.gopls.setup({
        on_attach = on_attach,
      })

      -- lua_ls for Lua
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
      })

      -- Setup other servers
      lspconfig.dockerls.setup({ on_attach = on_attach })
      lspconfig.html.setup({ on_attach = on_attach })

      lspconfig.marksman.setup({ on_attach = on_attach })

      lspconfig.jdtls.setup({ on_attach = on_attach })

      lspconfig.bashls.setup({ on_attach = on_attach })
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
    build = ":TSUpdate", -- this updates parsers
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
        }, -- specify languages
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = false }, -- Make sure folding is enabled
      })
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    after = "nvim-treesitter", -- This ensures it's loaded after nvim-treesitter
    config = function()
      require("nvim-treesitter.configs").setup({
        refactor = {
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = true },
          -- Other refactor settings can go here
        },
      })
    end,
  },
}
-- Plugin configuration
require("lazy").setup(plugins, opts)
require("catppuccin").setup()
-- Additions setups
vim.cmd("set relativenumber")
vim.cmd("set autoindent")
-- Enable folding by default
vim.opt.foldenable = false
vim.opt.tabstop = 2      -- Use 2 spaces for a tab character
vim.opt.shiftwidth = 2   -- Indentation level of 2 spaces
vim.opt.expandtab = true -- Convert tabs to spaces
-- Additional setup for other plugins can go here
-- Override nvim-tree with treemux for directory openings
-- Create global functions to handle tree operations via treemux
-- Define the global functions properly
_G.open_menu = function()
  local Menu = require("nui.menu")
  local Input = require("nui.input")

  local function run_command(cmd)
    vim.cmd("!" .. cmd) -- Executes shell command
  end

  local function run_node_script()
    -- Find all JavaScript files in the current directory
    local js_files_raw = vim.fn.systemlist("find . -maxdepth 1 -type f -name '*.js' | sort")

    -- If no JS files are found
    if #js_files_raw == 0 then
      print("No JavaScript files found in the current directory.")
      return
    end

    -- Format file paths for menu (remove './' prefix if present)
    local js_files = {}
    for _, file in ipairs(js_files_raw) do
      local display_name = file:gsub("^%./", "")
      table.insert(js_files, Menu.item(display_name))
    end

    -- Create menu for JS file selection
    local js_menu = Menu({
      position = "50%",
      size = {
        width = 40,
        height = math.min(#js_files + 2, 10),
      },
      border = {
        style = "rounded",
        text = { top = " Select JavaScript File ", top_align = "center" },
      },
      win_options = {
        winblend = 10,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    }, {
      lines = js_files,
      on_submit = function(item)
        run_command("node " .. item.text)
      end,
    })
    js_menu:mount()
  end
  local function run_c_compilation()
    local exe_name = vim.fn.expand("%:r")

    -- Function to prompt for command-line arguments
    local function prompt_arguments(compiler_cmd)
      local input = Input({
        position = "50%",
        size = { width = 40 },
        border = {
          style = "rounded",
          text = { top = " Enter Arguments ", top_align = "center" },
        },
        win_options = {
          winblend = 10,
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      }, {
        prompt = "Args: ",
        on_submit = function(args)
          run_command(
            compiler_cmd
            .. " && echo '' && ./"
            .. exe_name
            .. (compiler_cmd:match("wingcc") and ".exe" or ".out")
            .. " "
            .. args
          )
        end,
      })
      input:mount()
    end

    -- Compiler selection menu
    local compiler_menu = Menu({
      position = "50%",
      size = {
        width = 30,
        height = 5,
      },
      border = {
        style = "rounded",
        text = { top = " Select Compiler ", top_align = "center" },
      },
      win_options = {
        winblend = 10,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    }, {
      lines = {
        Menu.item("GCC"),
        Menu.item("Wingcc"),
      },
      on_submit = function(compiler)
        local compiler_cmd
        if compiler.text == "GCC" then
          compiler_cmd = "gcc % -o " .. exe_name .. ".out"
        elseif compiler.text == "Wingcc" then
          compiler_cmd = "wingcc % -o " .. exe_name .. ".exe"
        end
        prompt_arguments(compiler_cmd) -- Ask for command arguments after compilation
      end,
    })
    compiler_menu:mount()
  end

  local function run_npm()
    -- Check if package.json exists
    local has_package_json = vim.fn.filereadable("package.json") == 1

    -- Create NPM options menu
    local npm_menu = Menu({
      position = "50%",
      size = {
        width = 40,
        height = 3,
      },
      border = {
        style = "rounded",
        text = { top = " NPM Options ", top_align = "center" },
      },
      win_options = {
        winblend = 10,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    }, {
      lines = {
        Menu.item("Install Package"),
        Menu.item("Run Script"),
      },
      on_submit = function(item)
        if item.text == "Install Package" then
          -- Create input dialog for package name
          local input = Input({
            position = "50%",
            size = {
              width = 40,
            },
            border = {
              style = "rounded",
              text = { top = " Package Name (leave empty for npm install) ", top_align = "center" },
            },
            win_options = {
              winblend = 10,
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
          }, {
            prompt = "> ",
            default_value = "",
            on_submit = function(value)
              if value == "" then
                run_command("npm install")
              else
                run_command("npm install " .. value)
              end
            end,
          })
          input:mount()
        elseif item.text == "Run Script" and has_package_json then
          -- Parse package.json to extract scripts
          local package_content = vim.fn.system("cat package.json")

          -- Try to parse JSON and extract scripts
          local success, package_data = pcall(vim.fn.json_decode, package_content)
          if not success or not package_data.scripts or vim.tbl_isempty(package_data.scripts) then
            print("No scripts found in package.json or unable to parse it.")
            return
          end

          -- Create menu items from scripts
          local script_items = {}
          for script_name, _ in pairs(package_data.scripts) do
            table.insert(script_items, Menu.item(script_name))
          end

          -- Sort script items alphabetically
          table.sort(script_items, function(a, b)
            return a.text < b.text
          end)

          -- Create script selection menu
          local script_menu = Menu({
            position = "50%",
            size = {
              width = 40,
              height = math.min(#script_items + 2, 10),
            },
            border = {
              style = "rounded",
              text = { top = " Select NPM Script ", top_align = "center" },
            },
            win_options = {
              winblend = 10,
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
          }, {
            lines = script_items,
            on_submit = function(script_item)
              run_command("npm run " .. script_item.text)
            end,
          })
          script_menu:mount()
        elseif item.text == "Run Script" and not has_package_json then
          print("No package.json found in the current directory.")
        end
      end,
    })
    npm_menu:mount()
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
      Menu.item("C Compilation"),
      Menu.item("Run Node Script"),
      Menu.item("Run Python Script"),
      Menu.item("NPM Options"),
    },
    on_submit = function(item)
      if item.text == "Make" then
        run_command("make")
      elseif item.text == "C Compilation" then
        run_c_compilation() -- Calls the submenu for compiler selection
      elseif item.text == "Run Node Script" then
        run_node_script()
      elseif item.text == "Run Python Script" then
        run_command("python3 %")
      elseif item.text == "NPM Options" then
        run_npm() -- Call the new NPM functionality
      end
    end,
  })
  menu:mount()
end

-- Set up keymap for the menu
vim.api.nvim_set_keymap("n", "<leader>m", ":lua _G.open_menu()<CR>", { noremap = true, silent = true })

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
