
import Foundation

extension Board {
  enum PlayError: Swift.Error {
    case alreadyPlayed
    case noGame
  }
}
