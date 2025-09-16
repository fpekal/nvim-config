return {
	{
		"folke/snacks.nvim",
		opts = function(_, opts)
			opts.terminal.start_insert = false
			opts.terminal.auto_insert = false
			opts.terminal.auto_close = true

			-- override terminal style
			opts.styles = opts.styles or {}
			opts.styles.terminal = vim.tbl_deep_extend("force", opts.styles.terminal or {}, {
				keys = {
					term_normal = {
						"<esc>",
						function(self)
							if self.sending_esc then
								self.sending_esc = false
								return "<esc>"
							end

							if not self.esc_timer then
								self.esc_timer = vim.uv.new_timer()
							end

							if self.esc_timer:is_active() then
								-- Second Esc pressed: exit terminal mode
								self.esc_timer:stop()
								vim.cmd("stopinsert")
								return ""
							end

							local bufnr = vim.api.nvim_get_current_buf()
							self.esc_timer:start(
								400,
								0,
								vim.schedule_wrap(function()
									if
										vim.api.nvim_buf_is_valid(bufnr)
										and bufnr == vim.api.nvim_get_current_buf()
										and vim.bo[bufnr].buftype == "terminal"
										and vim.fn.mode() == "t"
									then
										self.sending_esc = true
										vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "t", true)
									end

									self.esc_timer:stop()
									-- self.esc_timer:close()
									-- self.esc_timer = nil
								end)
							)
						end,
						mode = "t",
						expr = true,
						desc = "Double escape to normal mode (safe passthrough)",
					},
				},
			})
		end,
	},
}
