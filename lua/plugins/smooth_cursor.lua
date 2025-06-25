return {
  "gen740/SmoothCursor.nvim",
  event = "VeryLazy",
  config = function()
    require("smoothcursor").setup({
      autostart = true,
      cursor = "",
      texthl = "SmoothCursor",
      type = "default", -- o "fancy"
      fancy = {
        enable = true,
        head = { cursor = "➤", texthl = "SmoothCursor" },
        body = {
          { cursor = "●", texthl = "SmoothCursorRed" },
          { cursor = "●", texthl = "SmoothCursorOrange" },
          { cursor = "•", texthl = "SmoothCursorYellow" },
        },
        tail = { cursor = "·", texthl = "SmoothCursor" },
      },
    })
  end,
}
