
import UIKit

class BoardViewController: UIViewController {
  @IBOutlet private var tiles: [UIButton]!
  public private(set) var board: Board! {
    didSet {
      board.delegate = self
    }
  }

  @IBOutlet weak private var imgCurrent: UIImageView!
  @IBOutlet weak private var lblCurrent: UILabel!

  private var markCross: UIImage!
  private var markNought: UIImage!

  override func viewDidLoad() {
    super.viewDidLoad()
    startGame()
  }

  @IBAction private func didTapTile(_ tile: UIButton) {
    guard let position = tiles.index(of: tile) else { return }

    do {
      try board.play(at: position)
    } catch let err as Board.PlayError {
      switch err {
      case .alreadyPlayed: print("⚠️ This position has already been played")
      case .noGame: print("⚠️ There's no ongoing game at the moment")
      }
    } catch let err {
      fatalError("Unexpected error occured: \(err)")
    }
  }

  private func startGame() {
    markCross = [#imageLiteral(resourceName: "iOS1"), #imageLiteral(resourceName: "iOS2"), #imageLiteral(resourceName: "iOS3"), #imageLiteral(resourceName: "iOS4"), #imageLiteral(resourceName: "iOS5")].random()
    markNought = [#imageLiteral(resourceName: "android1"), #imageLiteral(resourceName: "android2"), #imageLiteral(resourceName: "android3"), #imageLiteral(resourceName: "android4"), #imageLiteral(resourceName: "android5")].random()
    board = Board()
    tiles.forEach { $0.setImage(nil, for: .normal) }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let gameOver = segue.destination as? GameOverViewController else { return }

    gameOver.delegate = self

    if case .won(let mark) = board.state {
      gameOver.winner = mark == .cross ? markCross : markNought
    }
  }
}

extension BoardViewController: BoardDelegate {
  func gameEnded(_ board: Board, state: Board.State) {
    switch state {
    case .won(let mark):
      print("🎉 Game won by \(mark), Congrats!")
      print(board)
    case .draw:
      print("🤝 Game ended with a Draw")
      print(board)
    default: break
    }

    performSegue(withIdentifier: "GameOver", sender: self)
  }

  func markPlayed(_ board: Board, mark: Board.Mark, position: Board.Position) {
    let tile = tiles[position]
    tile.setImage(mark == .cross ? markCross : markNought,
                  for: .normal)

  }

  func markChanged(_ board: Board, mark: Board.Mark) {
    imgCurrent.image = mark == .cross ? markCross : markNought
    lblCurrent.text = mark == .cross ? "You" : "Computer"
    print("🎲 Currently playing: \(mark)")

    // If mark is Nought, make the computer Play.
    // Also delay the auto-play so it visually makes sense.
    view.isUserInteractionEnabled = mark == .cross
    if mark == .nought {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
        guard let `self` = self else { return }

        do {
          try self.board.playRandom()
        } catch let err {
          fatalError("An unexpected error occured. Playing at random should never throw an error: \(err)")
        }
      }
    }
  }
}

extension BoardViewController: GameOverDelegate {
  func didDismiss(_ gameOverViewController: GameOverViewController) {
    print("♻️ Restarting game!")
    startGame()
  }
}
