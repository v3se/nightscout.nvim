# nightscout.nvim

Blood glucose readings from [Nightscout](https://nightscout.github.io/) in your Neovim statusline.

Displays current glucose in mmol/L with a trend arrow — e.g. `5.4↗`

## Requirements

- Neovim 0.10+
- `curl` on `$PATH`
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) (auto-installed as a dependency)

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

Create `~/.config/nvim/lua/plugins/nightscout.lua`:

```lua
return {
  "v3se/nightscout.nvim",
  version = "*",
  dependencies = { "nvim-lualine/lualine.nvim" },
  opts = {},
}
```

## Configuration

Credentials are read from environment variables by default (e.g. set in `~/.zshenv`):

```sh
export NIGHTSCOUT_URL="https://your-nightscout-instance.example.com"
export NIGHTSCOUT_TOKEN="your-api-token"
```

Or pass them via `opts`:

```lua
opts = {
  url      = "https://your-nightscout-instance.example.com",
  token    = "your-api-token",
  interval = 60, -- seconds between fetches (default: 60)
}
```

## Lualine

In your existing lualine config (e.g. `~/.config/nvim/lua/plugins/lualine.lua`), add `"nightscout"` to your sections:

```lua
require("lualine").setup({
  sections = {
    lualine_x = { "nightscout", "encoding", "fileformat", "filetype" },
  },
})
```

## Trend arrows

`↑↑` `↑` `↗` `→` `↘` `↓` `↓↓`
