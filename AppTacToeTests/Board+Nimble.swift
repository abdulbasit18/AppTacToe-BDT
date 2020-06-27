
import Quick
import Nimble
@testable import AppTacToe

func beWon(by: Board.Mark) -> Predicate<Board> {
    return Predicate { expression in

        guard let board = try expression.evaluate() else {
            return PredicateResult(status: .fail,
                                   message: .fail("failed evaluating expression"))
        }
        
        guard board.state == .won(by) else {
            return PredicateResult(status: .fail,
                                   message: .expectedCustomValueTo("be Won by \(by)", "\(board.state)"))
        }
        
        return PredicateResult(status: .matches,
                               message: .expectedTo("expectation fulfilled"))
    }
}

