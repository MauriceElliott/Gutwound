package game

import pd "../packages"
import fmt "core:fmt"
import str "core:strings"


log :: proc(format: string, args: ..any) {
	log_message := str.clone_to_cstring(fmt.tprintf(format, ..args))
	pd_api.system.log_to_console(log_message)
	pd_api.graphics.set_draw_mode(.Fill_White)
	pd_api.graphics.draw_text(log_message, len(log_message), .ASCII, 100, 100)
	append(&game_state.log_messages, log_message)
}

draw_logs :: proc() {
	x: i32 = 0
	y: i32 = 0

	pd_api.graphics.set_draw_mode(.Fill_White)
	for log_message in game_state.log_messages {
		pd_api.graphics.draw_text(log_message, len(log_message), .ASCII, x, y)
		y += 20
	}
	pd_api.graphics.set_draw_mode(.Fill_Black)
	clear(&game_state.log_messages)
}

