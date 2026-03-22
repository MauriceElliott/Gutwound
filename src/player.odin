package game

import pd "../packages"

Player_Vitals :: struct {
	health:      f32,
	wound:       f32,
	delirium:    f32,
	temperature: f32,
	exhaustion:  f32,
	pain:        f32,
	hunger:      f32,
	thirst:      f32,
}

Player_State :: enum {
	none      = 1,
	walking   = 2,
	searching = 3,
	consuming = 4,
	sleeping  = 5,
	running   = 6,
}

Player :: struct {
	sprite: ^pd.Sprite,
	x:      f32,
	y:      f32,
	width:  f32,
	height: f32,
	state:  Player_State,
	vitals: ^Player_Vitals,
}

//Visuals
player_create :: proc(
	image_path: cstring,
	x: f32,
	y: f32,
	width: f32 = 48,
	height: f32 = 66,
) -> Player {

	player_vitals := Player_Vitals {
		health      = 100,
		wound       = 100,
		delirium    = 0,
		temperature = 0,
		exhaustion  = 0,
		pain        = 0,
		hunger      = 0,
		thirst      = 0,
	}

	player := Player {
		x      = x,
		y      = y,
		width  = width,
		height = height,
		state  = .none,
		vitals = &player_vitals,
	}

	player.sprite = pd_api.sprite.new_sprite()

	bounds_x := player.x - (player.width / 2)
	bounds_y := player.y - (player.height / 2)

	pd_api.sprite.set_bounds(
		player.sprite,
		pd.PDRect{bounds_x, bounds_y, player.width, player.height},
	)

	err: cstring
	image := pd_api.graphics.load_bitmap(image_path, &err)
	pd_api.sprite.set_image(player.sprite, image, .Unflipped)

	pd_api.sprite.set_update_function(player.sprite, player_sprite_update)
	pd_api.sprite.add_sprite(player.sprite)

	return player
}

player_sprite_update :: proc "c" (sprite: ^pd.Sprite) {
	context = global_ctx
	player_process_move(&game_state.player)
}

//Movement
player_process_move :: proc(player: ^Player) {
	current: pd.Buttons
	pd_api.system.get_button_state(&current, nil, nil)

	if .Down in current do pd_api.sprite.move_by(player.sprite, 0, 1)
	if .Left in current do pd_api.sprite.move_by(player.sprite, -1, 0)
	if .Right in current do pd_api.sprite.move_by(player.sprite, 1, 0)
	if .Up in current do pd_api.sprite.move_by(player.sprite, 0, -1)
}

//Vitals
penalty :: 1
player_vitals_update :: proc(player: ^Player) {
	multiplier: f32 = 0

	switch player.state {
	case .walking:
		multiplier = 0.3
	case .running:
		multiplier = 1.3
	case .searching:
		multiplier = 0.1
	case .consuming:
		multiplier = -0.1
	case .none:
		multiplier = 0
	case .sleeping:
		multiplier = -1.3
	}

	//TO BE CONTINUED, Health and stats decrease with muliplyer and penalty
}

