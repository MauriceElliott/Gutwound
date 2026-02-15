import PlaydateKit

class Floor {
    var rooms: Array<Room>
    init(rooms: Array<Room> = Array<Room>(arrayLiteral: Room("Images/Rooms/TestRoom/testRoomHalf.png"))) {
        self.rooms = rooms
        for room in self.rooms {
            // To be changed to false and then the floor itself will define which room is visible depending on where the player has entered.
            room.isVisible = true
        }
    }
    
    func update() {
        
    }
}
