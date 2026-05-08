package game

import pd "../packages"
import "core:c"
import fmt "core:fmt"
import str "core:strings"

log_handler :: proc(format: cstring, args: ..any) {
	// pd_api.system.log_to_console(format)
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
	y: i32 = 160

	pd_api.graphics.set_draw_mode(.Fill_White)
	for log_message in game_state.log_messages {
		pd_api.graphics.draw_text(log_message, len(log_message), .ASCII, x, y)
		y += 10
	}
	pd_api.graphics.set_draw_mode(.Fill_Black)
	clear(&game_state.log_messages)
}

// Animation

Animator :: struct {
	table:           ^pd.Bitmap_Table,
	frame_count:     int,
	current_frame:   int,
	frame_duration:  u32,
	last_frame_time: u32,
}

animator_create :: proc(path: cstring, frame_count: int, frame_duration_ms: u32) -> Animator {
	err: cstring
	table := pd_api.graphics.load_bitmap_table(path, &err)
	if err != nil {
		log(err)
	}
	return Animator {
		table = table,
		frame_count = frame_count,
		current_frame = 0,
		frame_duration = frame_duration_ms,
		last_frame_time = pd_api.system.get_current_time_milliseconds(),
	}
}

animator_update :: proc(animator: ^Animator, sprite: ^pd.Sprite) {
	now := pd_api.system.get_current_time_milliseconds()
	if (now - animator.last_frame_time) >= animator.frame_duration {
		animator.current_frame = (animator.current_frame + 1) % animator.frame_count
		frame := pd_api.graphics.get_table_bitmap(
			animator.table,
			cast(c.int)animator.current_frame,
		)
		pd_api.sprite.set_image(sprite, frame, .Unflipped)
		animator.last_frame_time = now
	}
}

animator_destroy :: proc(animator: ^Animator) {
	pd_api.graphics.free_bitmap_table(animator.table)
}

load_font :: proc(path: cstring) -> ^pd.Font {
	out_error: cstring = ""
	font := pd_api.graphics.load_font(path, &out_error)
	if out_error != nil {
		log(out_error)
	}
	return font
}

