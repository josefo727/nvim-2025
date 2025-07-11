local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_layout = require("telescope.actions.layout")

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local filetype_hook = function(filepath, bufnr, opts)
  -- Here for example you can say: if ft == "xyz" then this_regex_highlighing else nothing end
  --
  local is_image = function(filepath)
    local image_extensions = { "png", "jpg" } -- Supported image formats
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    local extension = split_path[#split_path]
    return vim.tbl_contains(image_extensions, extension)
  end
  if not is_image(filepath) then
    return true
  end
  local ui = require("image.ui")
  local options = require("image.options")
  local dimensions = require("image.dimensions")
  local api = require("image.api")
  local config = require("image.config")
  local user_opts = {
    render = {
      foreground_color = true,
      background_color = true,
    },
  }
  local global_opts = vim.tbl_deep_extend("force", config.DEFAULT_OPTS, user_opts)

  local ascii_width, ascii_height, horizontal_padding, vertical_padding, img_width, img_height =
    dimensions.calculate_ascii_width_height(opts.winid, filepath, global_opts)
  options.set_options_before_render(bufnr)
  ui.buf_clear(bufnr)
  local label = ui.create_label(
    filepath,
    ascii_width,
    horizontal_padding,
    global_opts.render.show_image_dimensions,
    img_width,
    img_height
  )

  api.get_ascii_data_sync(filepath, ascii_width, ascii_height, global_opts, function(ascii_data)
    ui.buf_insert_data_with_padding(bufnr, ascii_data, horizontal_padding, vertical_padding, label, global_opts)

    options.set_options_after_render(bufnr)
  end)
  return false
end

require("telescope").setup({
  defaults = {
    preview = {
      filetype_hook = filetype_hook,
    },
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",

    winblend = 0,

    layout_strategy = "horizontal",
    layout_config = {
      width = 0.95,
      height = 0.85,
      -- preview_cutoff = 120,
      prompt_position = "bottom",

      horizontal = {
        preview_width = function(_, cols, _)
          if cols > 200 then
            return math.floor(cols * 0.5)
          else
            return math.floor(cols * 0.7)
          end
        end,
      },

      vertical = {
        width = 0.9,
        height = 0.95,
        preview_height = 0.5,
      },

      flex = {
        horizontal = {
          preview_width = 0.9,
        },
      },
    },

    selection_strategy = "reset",
    sorting_strategy = "descending",
    scroll_strategy = "cycle",
    color_devicons = true,

    mappings = {
      i = {
        -- ["<C-x>"] = false,
        -- ["<C-s>"] = actions.select_horizontal,
        ["<C-n>"] = "move_selection_next",

        ["<C-y>"] = set_prompt_to_entry_value,

        -- These are new :)
        ["<M-p>"] = action_layout.toggle_preview,
        ["<M-m>"] = action_layout.toggle_mirror,
        -- ["<M-p>"] = action_layout.toggle_prompt_position,

        -- ["<M-m>"] = actions.master_stack,

        -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        -- This is nicer when used with smart-history plugin.
        ["<C-k>"] = actions.cycle_history_next,
        ["<C-j>"] = actions.cycle_history_prev,

        -- ["<c-space>"] = function(prompt_bufnr)
        -- 	local opts = {
        -- 		callback = actions.toggle_selection,
        -- 		loop_callback = actions.send_selected_to_qflist,
        -- 	}
        -- 	require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
        -- end,

        -- ["<C-w>"] = function()
        -- 	vim.api.nvim_input("<c-s-w>")
        -- end,
      },
    },

    -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    -- file_ignore_patterns = nil,

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    history = {
      path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
      limit = 100,
    },
    -- buffer_previewer_maker = new_maker,
  },

  pickers = {
    fd = {
      mappings = {
        n = {
          ["kj"] = "close",
        },
      },
    },

    git_branches = {
      mappings = {
        i = {
          ["<C-a>"] = false,
        },
      },
    },
  },

  extensions = {
    fzy_native = {
      override_generic_sorter = true,
      override_file_sorter = true,
    },

    fzf_writer = {
      use_highlighter = false,
      minimum_grep_characters = 6,
    },

    hop = {
      -- keys define your hop keys in order; defaults to roughly lower- and uppercased home row
      keys = { "a", "s", "d", "f", "g", "h", "j", "k", "l", ";" }, -- ... and more

      -- Highlight groups to link to signs and lines; the below configuration refers to demo
      -- sign_hl typically only defines foreground to possibly be combined with line_hl
      sign_hl = { "WarningMsg", "Title" },

      -- optional, typically a table of two highlight groups that are alternated between
      line_hl = { "CursorLine", "Normal" },

      -- options specific to `hop_loop`
      -- true temporarily disables Telescope selection highlighting
      clear_selection_hl = false,
      -- highlight hopped to entry with telescope selection highlight
      -- note: mutually exclusive with `clear_selection_hl`
      trace_entry = true,
      -- jump to entry where hoop loop was started from
      reset_selection = true,
    },

    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        borderchars = {
          prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          results = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
          preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
        width = 0.8,
        previewer = false,
      }),
    },
  },
})

-- require("telescope").load_extension("notify")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("fzf")
