package game

import pd "../packages"

Vital :: struct {
	name:  string,
	value: f32,
}

Player_Vitals :: [8]Vital

Player_State :: enum {
	none      = 1,
	walking   = 2,
	searching = 3,
	consuming = 4,
	sleeping  = 5,
	running   = 6,
}

Player_Direction :: enum {
	down  = 1,
	up    = 2,
	left  = 3,
	right = 4,
}

Player :: struct {
	sprite:    ^pd.Sprite,
	x:         f32,
	y:         f32,
	width:     f32,
	height:    f32,
	state:     Player_State,
	vitals:    Player_Vitals,
	direction: Player_Direction,
	speed:     f32,
	animator:  Animator,
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
		Vital{"health", 100},
		Vital{"wound", 0},
		Vital{"delirium", 0},
		Vital{"temperature", 0},
		Vital{"exhaustion", 0},
		Vital{"pain", 0},
		Vital{"hunger", 0},
		Vital{"thirst", 0},
	}

	player := Player {
		x      = x,
		y      = y,
		width  = width,
		height = height,
		state  = .none,
		vitals = player_vitals,
		speed  = 1.5,
	}

	player.sprite = pd_api.sprite.new_sprite()

	bounds_x := player.x - (player.width / 2)
	bounds_y := player.y - (player.height / 2)

	pd_api.sprite.set_bounds(
		player.sprite,
		pd.PDRect{bounds_x, bounds_y, player.width, player.height},
	)

	player.animator = animator_create(image_path, 6, 1000)
	initial_frame := pd_api.graphics.get_table_bitmap(player.animator.table, 0)
	pd_api.sprite.set_image(player.sprite, initial_frame, .Unflipped)

	pd_api.sprite.set_update_function(player.sprite, player_sprite_update)
	pd_api.sprite.add_sprite(player.sprite)

	return player
}

player_sprite_update :: proc "c" (sprite: ^pd.Sprite) {
	context = global_ctx
	player_process_move(&game_state.player)
	player_vitals_update(&game_state.player)
	animator_update(&game_state.player.animator, sprite)
}

//Movement
player_process_move :: proc(player: ^Player) {
	current: pd.Buttons
	pd_api.system.get_button_state(&current, nil, nil)
	adjustment_value := player.speed

	if .Down in current {
		pd_api.sprite.move_by(player.sprite, 0, adjustment_value)
		player.state = .walking
		player.direction = .down
	} else if .Left in current {
		pd_api.sprite.move_by(player.sprite, -adjustment_value, 0)
		player.state = .walking
		player.direction = .left
	} else if .Right in current {
		pd_api.sprite.move_by(player.sprite, adjustment_value, 0)
		player.state = .walking
		player.direction = .right
	} else if .Up in current {
		pd_api.sprite.move_by(player.sprite, 0, -adjustment_value)
		player.state = .walking
		player.direction = .up
	} else {
		player.state = .none
	}
}

//Vitals
get_vital :: proc(vitals: ^Player_Vitals, name: string) -> f32 {
	for vital in vitals {
		if vital.name == name {
			return vital.value
		}
	}
	return 0
}

set_vital :: proc(vitals: ^Player_Vitals, name: string, value: f32) {
	for i := 0; i < len(vitals); i += 1 {
		if vitals[i].name == name {
			vitals[i].value = value
			return
		}
	}
}

adjust_vital :: proc(vitals: ^Player_Vitals, name: string, amount: f32) {
	for i := 0; i < len(vitals); i += 1 {
		if vitals[i].name == name {
			vitals[i].value += amount
			return
		}
	}
}

get_vital_modifier :: proc(value: f32) -> f32 {
	modifier: f32 = 1
	if value >= 30 {
		modifier = 0.15
	} else if value < 30 && value >= 60 {
		modifier = 0.5
	} else if value < 60 && value >= 90 {
		modifier = 0.75
	}
	return modifier
}

penalty: f32 : 1

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

	for vital in player.vitals {
		modifier := get_vital_modifier(vital.value)
		final_adjustment := multiplier * modifier * penalty
		log(string("VITAL: %s, ADJ: %f"), vital.name, final_adjustment)
		adjust_vital(&player.vitals, vital.name, final_adjustment)
	}
}

