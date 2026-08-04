return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#000002",
        dark_bg    = "#000002",
        darker_bg  = "#000001",
        lighter_bg = "#1a1a1b",

        fg         = "#8667b7",
        dark_fg    = "#654d89",
        light_fg   = "#987ec2",
        bright_fg  = "#a48dc9",
        muted      = "#525978",

        red        = "#f90020",
        yellow     = "#eaff0d",
        orange     = "#fa2641",
        green      = "#3dff05",
        cyan       = "#00d3ff",
        blue       = "#ff78ff",
        purple     = "#fd02fb",
        brown      = "#961727",

        bright_red    = "#ff4d63",
        bright_yellow = "#879400",
        bright_green  = "#1e8f00",
        bright_cyan   = "#008799",
        bright_blue   = "#f99ef9",
        bright_purple = "#940593",

        accent               = "#ff78ff",
        cursor               = "#8667b7",
        foreground           = "#8667b7",
        background           = "#000002",
        selection             = "#1a1a1b",
        selection_foreground = "#8667b7",
        selection_background = "#1a1a1b",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
