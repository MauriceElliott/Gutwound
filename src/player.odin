package game

import pd "../packages"

Player :: struct {
    sprite: ^pd.Sprite,
    x:      f32,
    y:      f32,
    width:  f32,
    height: f32,
}

player_create :: proc(image_path: cstring, x: f32, y: f32, width: f32 = 48, height: f32 = 66) -> Player {
    player := Player{
        x      = x,
        y      = y,
        width  = width,
        height = height,
    }

    player.sprite = pd_api.sprite.new_sprite()

    bounds_x := player.x - (player.width / 2)
    bounds_y := player.y - (player.height / 2)
    pd_api.sprite.set_bounds(player.sprite, pd.PDRect{bounds_x, bounds_y, player.width, player.height})

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

player_process_move :: proc(player: ^Player) {
    current: pd.Buttons
    pd_api.system.get_button_state(&current, nil, nil)

    if .Down  in current do pd_api.sprite.move_by(player.sprite, 0, 1)
    if .Left  in current do pd_api.sprite.move_by(player.sprite, -1, 0)
    if .Right in current do pd_api.sprite.move_by(player.sprite, 1, 0)
    if .Up    in current do pd_api.sprite.move_by(player.sprite, 0, -1)
}
