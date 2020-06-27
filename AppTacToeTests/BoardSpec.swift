
import Quick
import Nimble
@testable import AppTacToe

class BoardSpec: QuickSpec {
    override func spec() {
        
        var board: Board!
        
        beforeEach {
            board = Board()
        }
        
        describe("playing") {
            context("a single move") {
                it("should switch to nought") {
                    try! board.playRandom()
                    expect(board.state).to(equal(.playing(.nought)))
                }
            }
            
            context("two moves") {
                it("should switch back to cross") {
                    try! board.playRandom()
                    try! board.playRandom()
                    expect(board.state) == .playing(.cross)
                }
            }
            
            context("a winning move") {
                it("should switch to won state") {
                    // Arrange
                    try! board.play(at: 0)
                    try! board.play(at: 1)
                    try! board.play(at: 3)
                    try! board.play(at: 2)
                    
                    // Act
                    try! board.play(at: 6)
                    
                    // Assert
                    expect(board).to(beWon(by: .cross))
                }
            }
            
            //0|0|x
            //x|x|0
            //0|0|x
            
            context("a draw move") {
                it("should switch to draw state") {
                    // Arrange
                    try! board.play(at: 0)
                    try! board.play(at: 3)
                    try! board.play(at: 6)
                    
                    try! board.play(at: 4)
                    try! board.play(at: 1)
                    try! board.play(at: 2)
                    
                    try! board.play(at: 7)
                    try! board.play(at: 8)
                    
                    //Act
                    try! board.play(at: 5)
                    
                    // Assert
                    expect(board.state) == .draw
                }
            }
            
            
            context("a move that was already played") {
                it("should throw an error") {
                    try! board.play(at: 0)
                    
                    // 2
                    expect { try board.play(at: 0) }
                        .to(throwError(Board.PlayError.alreadyPlayed))
                }
            }
            
            context("a move while the game was already won") {
                it("should throw an error") {
                    // Arrange
                    try! board.play(at: 0)
                    try! board.play(at: 1)
                    try! board.play(at: 3)
                    try! board.play(at: 2)
                    try! board.play(at: 6)
                    
                    // Act & Assert
                    expect { try board.play(at: 7) }
                        .to(throwError(Board.PlayError.noGame))
                }
            }
            
        }
    }
}
