return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<S-TAB>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<TAB>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<C-S-p>", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<C-S-d>", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
  },
}
