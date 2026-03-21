package game

Floor :: struct {
    rooms: [dynamic]Room,
}

floor_create :: proc(rooms: []Room = nil) -> Floor {
    floor: Floor
    floor.rooms = make([dynamic]Room, 0, max(len(rooms), 4))

    if len(rooms) == 0 {
        append(&floor.rooms, room_create("Images/Rooms/TestRoom/testRoomHalf.png"))
    } else {
        for room in rooms {
            append(&floor.rooms, room)
        }
    }

    // All rooms visible for now - to be changed so the floor defines
    // visibility based on where the player entered.
    for &room in floor.rooms {
        room_set_visible(&room, true)
    }

    return floor
}
