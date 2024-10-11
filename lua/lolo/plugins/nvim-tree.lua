-- Return the options table
return {
  -- Your configuration options here
  renderer = {
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "", -- icon for folder closed
          arrow_open = "",   -- icon for folder open
        },
      },
    },
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
}

