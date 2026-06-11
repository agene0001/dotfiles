-- Ensure lazy.nvim is installed
---@diagnostic disable: undefined-global
-- luacheck: globals vim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- OS detection helpers (used for path/command/tmux guards throughout)
local is_mac = vim.fn.has("mac") == 1
local is_win = vim.fn.has("win32") == 1
local is_linux = (vim.fn.has("unix") == 1) and not is_mac

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
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
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
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "ramilito/kubectl.nvim",
    config = function()
      require("kubectl").setup()
    end,
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
    event = "VeryLazy",
    config = function()
      require("mason-nvim-lint").setup({
        -- ensure_installed already covers every linter, so turn off the
        -- automatic (on-FileType) installer to avoid the install race that
        -- throws "Package is already installing".
        automatic_installation = false,
        quiet_mode = true,
        -- Only the linters Mason can actually build on this machine.
        ensure_installed = {
          "eslint_d",
          "shellcheck",
          "jsonlint",
          "markdownlint",
          "stylelint",
          "htmlhint",
        },
        -- Managed outside Mason (uv tools + luarocks), found on PATH by
        -- nvim-lint; tell Mason not to try installing them.
        ignore_install = {
          "pylint",   -- uv tool install pylint
          "yamllint", -- uv tool install yamllint
          "luacheck", -- luarocks install luacheck
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
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash", "c", "cpp", "css", "go", "html", "javascript", "json",
          "lua", "luadoc", "markdown", "markdown_inline", "python", "query",
          "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
        },
      })

      -- The main branch no longer auto-enables features; do it per buffer.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          -- Only start if a parser for this filetype is actually installed.
          if lang and pcall(vim.treesitter.language.add, lang) then
            vim.treesitter.start(args.buf)
            -- Treesitter-based indentation (experimental upstream).
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

}
-- Plugin configuration
require("lazy").setup(plugins, opts)
require("catppuccin").setup()
-- Additions setups
vim.opt.number = true
vim.opt.relativenumber = true
local function ToggleNumber()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
  else
    vim.wo.relativenumber = true
  end

  vim.wo.number = true
end

vim.keymap.set("n", "<leader>n", ToggleNumber, {
  desc = "Toggle relative line numbers",
})
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
  local python = is_win and "python" or "python3"
  local border_opts = { winblend = 10, winhighlight = "Normal:Normal,FloatBorder:FloatBorder" }

  local function run_command(cmd)
    vim.cmd("!" .. cmd)
  end

  -- Pick a JavaScript file (via vim glob, no shell `find`) and run it with node.
  local function run_node_script()
    local js_files = vim.fn.glob("*.js", false, true)
    if #js_files == 0 then
      print("No JavaScript files found in the current directory.")
      return
    end
    local items = {}
    for _, file in ipairs(js_files) do
      table.insert(items, Menu.item(file))
    end
    Menu({
      position = "50%",
      size = { width = 40, height = math.min(#items + 2, 10) },
      border = { style = "rounded", text = { top = " Select JavaScript File ", top_align = "center" } },
      win_options = border_opts,
    }, {
      lines = items,
      on_submit = function(item)
        run_command("node " .. item.text)
      end,
    }):mount()
  end

  -- Compile current C file with GCC (.out) or Wingcc (.exe), then run it.
  local function run_c_compilation()
    local exe_name = vim.fn.expand("%:r")
    local function prompt_arguments(compiler_cmd, ext)
      Input({
        position = "50%",
        size = { width = 40 },
        border = { style = "rounded", text = { top = " Enter Arguments ", top_align = "center" } },
        win_options = border_opts,
      }, {
        prompt = "Args: ",
        on_submit = function(args)
          local runner = (is_win and "" or "./") .. exe_name .. ext
          run_command(compiler_cmd .. " && echo '' && " .. runner .. " " .. (args or ""))
        end,
      }):mount()
    end
    Menu({
      position = "50%",
      size = { width = 30, height = 5 },
      border = { style = "rounded", text = { top = " Select Compiler ", top_align = "center" } },
      win_options = border_opts,
    }, {
      lines = { Menu.item("GCC"), Menu.item("Wingcc") },
      on_submit = function(compiler)
        if compiler.text == "GCC" then
          prompt_arguments("gcc % -o " .. exe_name .. ".out", ".out")
        elseif compiler.text == "Wingcc" then
          prompt_arguments("wingcc % -o " .. exe_name .. ".exe", ".exe")
        end
      end,
    }):mount()
  end

  -- npm install <pkg> or run a script parsed from package.json (via vim readfile).
  local function run_npm()
    local has_package_json = vim.fn.filereadable("package.json") == 1
    Menu({
      position = "50%",
      size = { width = 40, height = 3 },
      border = { style = "rounded", text = { top = " NPM Options ", top_align = "center" } },
      win_options = border_opts,
    }, {
      lines = { Menu.item("Install Package"), Menu.item("Run Script") },
      on_submit = function(item)
        if item.text == "Install Package" then
          Input({
            position = "50%",
            size = { width = 40 },
            border = { style = "rounded", text = { top = " Package Name (empty = npm install) ", top_align = "center" } },
            win_options = border_opts,
          }, {
            prompt = "> ",
            default_value = "",
            on_submit = function(value)
              run_command(value == "" and "npm install" or ("npm install " .. value))
            end,
          }):mount()
        elseif item.text == "Run Script" and has_package_json then
          local ok, pkg = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile("package.json"), "\n"))
          if not ok or not pkg.scripts or vim.tbl_isempty(pkg.scripts) then
            print("No scripts found in package.json or unable to parse it.")
            return
          end
          local items = {}
          for name, _ in pairs(pkg.scripts) do
            table.insert(items, Menu.item(name))
          end
          table.sort(items, function(a, b)
            return a.text < b.text
          end)
          Menu({
            position = "50%",
            size = { width = 40, height = math.min(#items + 2, 10) },
            border = { style = "rounded", text = { top = " Select NPM Script ", top_align = "center" } },
            win_options = border_opts,
          }, {
            lines = items,
            on_submit = function(script_item)
              run_command("npm run " .. script_item.text)
            end,
          }):mount()
        elseif item.text == "Run Script" then
          print("No package.json found in the current directory.")
        end
      end,
    }):mount()
  end

  Menu({
    position = "50%",
    size = { width = 30, height = 5 },
    border = { style = "rounded", text = { top = " Run Configuration ", top_align = "center" } },
    win_options = border_opts,
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
        run_c_compilation()
      elseif item.text == "Run Node Script" then
        run_node_script()
      elseif item.text == "Run Python Script" then
        run_command(python .. " %")
      elseif item.text == "NPM Options" then
        run_npm()
      end
    end,
  }):mount()
end

vim.api.nvim_set_keymap("n", "<leader>m", ":lua open_menu()<CR>", { noremap = true, silent = true })

-- Use treemux (a tmux popup file tree) when tmux is available on unix;
-- otherwise fall back to the real nvim-tree (e.g. on Windows).
local has_tmux = (vim.fn.executable("tmux") == 1) and not is_win

function _G.open_treemux()
  if has_tmux then
    vim.fn.system("tmux display-popup -E 'treemux'")
  else
    require("nvim-tree.api").tree.toggle()
  end
end

-- Only redirect the NvimTree commands to treemux when tmux is present;
-- on Windows the native nvim-tree commands are left intact.
if has_tmux then
  for _, name in ipairs({ "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "TreemuxToggle" }) do
    vim.api.nvim_create_user_command(name, function()
      _G.open_treemux()
    end, {})
  end
end

-- Handle directory opening: cd into it, drop the dir buffer, open the tree.
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local args = vim.fn.argv()
    if #args > 0 and vim.fn.isdirectory(args[1]) == 1 then
      vim.cmd("cd " .. vim.fn.fnameescape(args[1]))
      vim.cmd("bd")
      _G.open_treemux()
    end
  end,
})

-- Python provider: pyenv on macOS, project venv on Linux, PATH lookup on Windows.
if is_mac then
  vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/shims/python3")
elseif is_linux then
  vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/venv/bin/python3")
end


vim.keymap.set("n", "<leader>y", 'ggVG"+y')
vim.keymap.set("n", "<leader>a", "ggVG", { noremap = true, desc = "Select entire file" })
