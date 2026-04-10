return {
 "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
   dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
	  { "<leader>ff", "<cmd>Telescope find_files<cr>",  mode = "n", desc = "Telescope find files" },
	  { "<leader>fg", "<cmd>Telescope live_grep<cr>",  mode = "n",desc = "Telescope live grep" },
	  { "<leader>fb", "<cmd>Telescope buffers<cr>",  mode = "n", desc = "Telescope buffers" },
  }
}
