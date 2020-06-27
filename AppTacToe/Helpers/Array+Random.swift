
import Foundation

extension Array {
  public func random() -> Element {
    let itemCount = count
    guard itemCount > 0 else { fatalError("Array is empty!") }
    
    let randomIdx = Int(arc4random_uniform(UInt32(itemCount)))
    return self[randomIdx]
  }
}
