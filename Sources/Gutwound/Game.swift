import PlaydateKit

final class Game: PlaydateGame {
    let casper = Casper()
    let player: Player
    init() {
        player = Player("Images/Character/man", x: 200, y: 120)
    }
    func update() -> Bool {
        Sprite.updateAndDrawDisplayListSprites()
        return true
    }

    func gameWillPause() {
        
    }
}
