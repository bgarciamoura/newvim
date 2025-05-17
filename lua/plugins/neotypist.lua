return {
	"JohnnyJumper/neotypist",
	config = function()
		require("neotypist").setup({
			-- Time in milliseconds between notifications (default: 60000)
			notify_interval = 60 * 1000,

			high = 80,

			low = 20,

			high_message = "⚡️ You're a cheetah!",

			low_message = "🐢 Slowpoke!",

			show_virt_text = true,

			notify = true,

			update_time = 300,

			virt_text = function(wpm)
				return ("🚀 WPM: %.0f"):format(wpm)
			end,

			virt_text_pos = "right_align",
		})
	end,
}
