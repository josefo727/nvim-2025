return {
  "adalessa/laravel.nvim",
  branch = "4.x",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-dotenv",
    "MunifTanjim/nui.nvim",
    "nvimtools/none-ls.nvim",
    "nvim-neotest/nvim-nio",
    "ravitemer/mcphub.nvim",
  },
  cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
  keys = {
    {
      "<leader>la",
      function()
        Laravel.pickers.artisan()
      end,
      desc = "Artisan picker",
    },
    {
      "<leader>lr",
      function()
        Laravel.pickers.routes()
      end,
      desc = "Routes picker",
    },
    {
      "<leader>ll",
      function()
        Laravel.pickers.laravel()
      end,
      desc = "Laravel picker",
    },
    {
      "<leader>lm",
      function()
        Laravel.pickers.make()
      end,
      desc = "Make",
    },
    {
      "<leader>lo",
      function()
        Laravel.pickers.resources()
      end,
      desc = "Resources",
    },
    {
      "<leader>lc",
      function()
        Laravel.pickers.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>lt",
      function()
        Laravel.commands.run("actions")
      end,
      desc = "Run actions",
    },
    {
      "<leader>lh",
      function()
        Laravel.run("artisan docs")
      end,
      desc = "Open docs",
    },
    {
      "<leader>lp",
      function()
        Laravel.commands.run("command_center")
      end,
      desc = "Command center",
    },
    {
      "gf",
      function()
        local ok, res = pcall(function()
          if Laravel.app("gf").cursorOnResource() then
            return "<cmd>lua Laravel.commands.run('gf')<cr>"
          end
        end)
        if not ok or not res then
          return "gf"
        end
        return res
      end,
      expr = true,
      noremap = true,
      desc = "Go to Laravel resource",
    },
  },
  event = { "VeryLazy" },
  opts = {
    lsp_server = "intelephense", -- o "intelephense" si prefieres
    features = {
      pickers = {
        provider = "snacks", -- puedes usar "telescope" también
      },
    },
    user_commands = {
      composer = {
        quality = {
          cmd = { "quality" },
          desc = "Run composer quality script",
        },
      },
    },
  },
}
