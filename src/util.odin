package game

import pd "../packages"
import fmt "core:fmt"
import str "core:strings"

log_handler :: proc(format: cstring, args: ..any) {
	pd_api.system.log_to_console(format)
	pd_api.graphics.set_draw_mode(.Fill_White)
	pd_api.graphics.draw_text(format, len(format), .ASCII, 100, 100)
	append(&game_state.log_messages, format)
}

string_log :: proc(format: string, args: ..any) {
	log_message := str.clone_to_cstring(fmt.tprintf(format, ..args))
	log_handler(log_message, args)
}

cstring_log :: proc(cformat: cstring, args: ..any) {
	log_handler(cformat, args)
}

log :: proc {
	string_log,
	cstring_log,
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

