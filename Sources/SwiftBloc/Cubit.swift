//
//  Cubit.swift
//  SwiftBloc
//
//  Created by Deepak Kumar Maurya on 31/07/25.
//

import Foundation
import Combine

/// Simplified version of BLoC that doesn't use events, only direct state emission
@MainActor
open class Cubit<State: BlocState>: ObservableObject {
    
    /// Current state of the Cubit
    @Published public private(set) var state: State
    
    /// Initializes the Cubit with an initial state
    public init(initialState: State) {
        self.state = initialState
    }
    
    /// Emits a new state
    public func emit(_ newState: State) {
        state = newState
    }
}
