-- Add "nightscout" to your existing lualine sections:
require("lualine").setup({
  sections = {
    lualine_x = { "nightscout", "encoding", "fileformat", "filetype" },
  },
})
