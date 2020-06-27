
import Foundation

/// The Board class represents the logical implementation of a
/// Tic-Tac-Toe playing board, without any visual (UI)
/// implementation.
class Board {
    typealias Position = Int
    
    public private(set) var state: State {
        didSet {
            switch state {
                case .playing(let mark):
                    delegate?.markChanged(self, mark: mark)
                case .draw, .won:
                    delegate?.gameEnded(self, state: state)
            }
        }
    }
    
    public var delegate: BoardDelegate? {
        didSet {
            if let mark = currentMark {
                delegate?.markChanged(self, mark: mark)
            }
        }
    }
    
    public var currentMark: Mark? {
        guard case .playing(let mark) = state else { return nil }
        return mark
    }
    
    public var availablePositions: [Position] {
        return cells
            .indices
            .filter { cells[$0] == .empty }
    }
    
    public var hasMoves: Bool {
        return !availablePositions.isEmpty
    }
    
    private var cells: [Mark]
    
    init() {
        state = .playing(.cross)
        cells = .init(repeating: .empty, count: 9)
    }
    
    /// Play a move as the current player (mark) at
    /// the provided position
    ///
    /// - parameter position: Position at which to play your mark (0 through 9)
    public func play(at position: Position) throws {
        guard ..<cells.count ~= position else {
            fatalError("There's no board cell at this position!")
        }
        
        guard let mark = currentMark else {
            throw Board.PlayError.noGame
        }
        
        guard cells[position] == .empty else {
            throw Board.PlayError.alreadyPlayed
        }
        
        cells[position] = mark
        
        if isGameWon {
            state = .won(mark)
        } else if !hasMoves {
            state = .draw
        } else {
            // Switch from X to O, or vice-versa
            state.toggle()
            delegate?.markPlayed(self, mark: mark, position: position)
        }
    }
    
    /// Play a random play at a random available position on the board
    public func playRandom() throws {
        guard let sign = currentMark?.sign else { return }
        
        let position = availablePositions.random()
        
        print("🎲 \(sign) playing at random in \(position)")
        
        try play(at: position)
    }
    
    /// Returns true if the board reflects a win by the current player (mark)
    private var isGameWon: Bool {
        guard let mark = currentMark else { fatalError("No ongoing game") }
        
        /// This method tests for winnings in a very naive way.
        /// It just checks if the current player has marks at
        /// any of the possible winning-streaks indices.
        let winningSets = [
            // Rows
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            
            // Columns
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            
            // Diagnoals
            [0, 4, 8],
            [2, 4, 6]
            ].map(Set.init)
        
        let markedIndices = Set(cells
            .indices
            .filter { cells[$0] == mark })
        
        for winningSet in winningSets {
            if winningSet.isSubset(of: markedIndices) {
                return true
            }
        }
        
        return false
    }
}

// MARK: - Board State
extension Board {
    enum State {
        case playing(Mark)
        case won(Mark)
        case draw
        
        fileprivate mutating func toggle() {
            guard case .playing(let mark) = self else { return }
            
            self = mark == .cross ? .playing(.nought) : .playing(.cross)
        }
    }
}

extension Board.State: CustomStringConvertible {
    var description: String {
        switch self {
            case .playing(let mark): return "Playing as \(mark)"
            case .won(let mark): return "Won by \(mark)"
            case .draw: return "Draw"
        }
    }
}

extension Board.State: Equatable {}
func == (lhs: Board.State, rhs: Board.State) -> Bool {
    switch (lhs, rhs) {
        case let (.playing(mark1), .playing(mark2)): return mark1 == mark2
        case let (.won(mark1), .won(mark2)): return mark1 == mark2
        case (.draw, .draw): return true
        default: return false
    }
}

// MARK: - Provide a "prettified" representation of the board
extension Board: CustomStringConvertible {
    var description: String {
        var board = ""
        
        for (idx, cell) in cells.enumerated() {
            let sign = cell.sign
            
            if idx % 3 == 0 {
                if idx != 0 { board += "\n" }
                board += "      -------------\n      |"
            }
            
            board += " \(sign) |"
        }
        
        board += "      \n      -------------"
        
        return board
    }
}

protocol BoardDelegate {
    func gameEnded(_ board: Board, state: Board.State)
    func markChanged(_ board: Board, mark: Board.Mark)
    func markPlayed(_ board: Board, mark: Board.Mark, position: Board.Position)
}
