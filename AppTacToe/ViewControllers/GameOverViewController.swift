
import UIKit

class GameOverViewController: UIViewController {
  @IBOutlet weak private var lblMessage: UILabel!
  @IBOutlet weak private var imgWinner: UIImageView!
  
  public var winner: UIImage?
  public var delegate: GameOverDelegate?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    if let winner = winner {
      lblMessage.text = "The winner is:"
      imgWinner.image = winner
    } else {
      lblMessage.text = "Draw!"
      imgWinner.image = #imageLiteral(resourceName: "Draw")
    }
  }
  
  @IBAction private func dismiss() {
    delegate?.didDismiss(self)
    dismiss(animated: true)
  }
}

protocol GameOverDelegate {
  func didDismiss(_ gameOverViewController: GameOverViewController)
}
