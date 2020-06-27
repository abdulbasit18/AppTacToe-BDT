
import Foundation

extension Board {
  enum Mark: CustomStringConvertible {
    case empty
    case nought
    case cross
    
    var description: String {
      switch self {
      case .empty: return "Empty"
      case .nought: return "Nought"
      case .cross: return "Cross"
      }
    }
    
    var sign: String {
      switch self {
      case .empty: return " "
      case .nought: return "O"
      case .cross: return "X"
      }
    }
  }
}
