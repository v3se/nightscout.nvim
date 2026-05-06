# nightscout.nvim

Blood glucose readings from [Nightscout](https://nightscout.github.io/) in your Neovim statusline.

Displays current glucose in mmol/L with a trend arrow — e.g. `5.4↗`

## Requirements

- Neovim 0.10+
- `curl` on `$PATH`

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "v3se/nightscout.nvim",
  version = "*",
  opts = {},
}
```

## Configuration

Credentials are read from environment variables by default:

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

Add `"nightscout"` to your lualine sections:

```lua
require("lualine").setup({
  sections = {
    lualine_x = { "nightscout", "encoding", "fileformat", "filetype" },
  },
})
```

## Trend arrows

`↑↑` `↑` `↗` `→` `↘` `↓` `↓↓`
