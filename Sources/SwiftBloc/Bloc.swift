//
//  Bloc.swift
//  SwiftBloc
//
//  Created by Deepak Kumar Maurya on 31/07/25.
//

import Foundation
import Combine

/// Base BLoC class that manages state transitions based on events
@MainActor
open class Bloc<Event: BlocEvent, State: BlocState>: ObservableObject {
    
    /// Current state of the BLoC
    @Published public private(set) var state: State
    
    /// Internal subject for handling events
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    /// Set to store cancellables
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes the BLoC with an initial state
    public init(initialState: State) {
        self.state = initialState
        setupEventHandling()
    }
    
    /// Adds an event to the BLoC
    public func add(_ event: Event) {
        eventSubject.send(event)
    }
    
    /// Override this method to handle events and emit new states
    open func mapEventToState(_ event: Event) -> AnyPublisher<State, Never> {
        fatalError("mapEventToState must be overridden in subclass")
    }
    
    /// Sets up the event handling pipeline
    private func setupEventHandling() {
        eventSubject
            .flatMap { [weak self] event -> AnyPublisher<State, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.mapEventToState(event)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
                self?.state = newState
            }
            .store(in: &cancellables)
    }
    
    /// Emits a single state
    open func emit(_ state: State) -> AnyPublisher<State, Never> {
        Just(state).eraseToAnyPublisher()
    }
    
    /// Emits multiple states in sequence
    open func emitSequence(_ states: [State]) -> AnyPublisher<State, Never> {
        Publishers.Sequence(sequence: states)
            .eraseToAnyPublisher()
    }
    
    /// Called when the BLoC is being deallocated
    deinit {
    }
}
