package game

import pd "../packages"

Room :: struct {
	sprite: ^pd.Sprite,
}

room_create :: proc(image_path: cstring) -> Room {
	room: Room

	room.sprite = pd_api.sprite.new_sprite()

	pd_api.sprite.set_bounds(room.sprite, pd.PDRect{0, 0, 400, 240})

	err: cstring
	image := pd_api.graphics.load_bitmap(image_path, &err)
	pd_api.sprite.set_image(room.sprite, image, .Unflipped)

	pd_api.sprite.add_sprite(room.sprite)
	pd_api.sprite.move_to(room.sprite, 100, 60)

	return room
}

room_set_visible :: proc(room: ^Room, visible: bool) {
	pd_api.sprite.set_visible(room.sprite, 1 if visible else 0)
}

