package game

import pd "../packages"
import "base:runtime"

pd_api: ^pd.Api
global_ctx: runtime.Context
game_state: Game

general_font: ^pd.Font
dialogue_font: ^pd.Font

Game :: struct {
	casper:       Floor,
	player:       Player,
	log_messages: [dynamic]cstring,
}

@(export)
eventHandler :: proc "c" (api: ^pd.Api, event: pd.System_Event, arg: u32) -> i32 {
	#partial switch event {
	case .Init:
		pd_api = api
		global_ctx = pd.playdate_context_create(api)
		context = global_ctx
		game_init()
		api.system.set_update_callback(update_callback, nil)
	case .Terminate:
		context = global_ctx
		pd.playdate_context_destroy(&global_ctx)
	}
	return 0
}

update_callback :: proc "c" (userdata: rawptr) -> pd.Update_Result {
	context = global_ctx
	game_update()
	return .Update_Display
}

game_init :: proc() {
	game_state.casper = floor_create()
	game_state.player = player_create("assets/bitmaps/characters/man-idle-down", 200, 120)
	dialogue_font := load_font("assets/fonts/garnet_9.pft")
	general_font := load_font("assets/fonts/onyx_9.pft")
	pd_api.graphics.set_font(general_font)
}

game_update :: proc() {
	pd_api.sprite.update_and_draw_sprites()
	draw_logs()
}

