return {
  -- colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night", -- storm, night, day, deep, cool
      transparent = vim.g.transparent,
      styles = {
        sidebars = vim.g.transparent and "transparent" or "dark",
        floats = vim.g.transparent and "transparent" or "dark",
      },
    },
  },
  -- change dashboard logo
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = {
        preset = {
          header = [[
     █████╗  ██████╗███████╗
    ██╔══██╗██╔════╝██╔════╝
    ███████║██║     █████╗  
    ██╔══██║██║     ██╔══╝  
    ██║  ██║╚██████╗███████╗
    ╚═╝  ╚═╝ ╚═════╝╚══════╝]],
        },
      }
    end,
  },
  -- override some noice config
  {
    "folke/noice.nvim",
    opts = {
      messages = {
        view = "mini",
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = {
          enabled = true,
        },
        message = {
          view = "mini",
          opts = {},
        },
        signature = {
          auto_open = { enabled = false },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
      views = {
        mini = {
          win_options = {
            winblend = 0,
          },
        },
        hover = {
          size = {
            max_width = 80,
            width = "auto",
            height = "auto",
          },
        },
      },
      cmdline = {
        format = {
          cmdline = { title = "ACE" },
        },
      },
    },
  },
  -- inline diagnostic more pretty
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = {
      preset = "amongus",
    },
    config = function(_, opts)
      vim.diagnostic.config({ virtual_text = false })
      require("tiny-inline-diagnostic").setup(opts)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[5] = nil
    end,
  },
}
