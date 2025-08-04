//
//  Cubit.swift
//  SwiftBloc
//
//  Created by Deepak Kumar Maurya on 31/07/25.
//

@preconcurrency import Combine
import Foundation

/// Simplified version of BLoC that doesn't use events, only direct state emission
@MainActor
open class Cubit<State: BlocState>: ObservableObject {

    /// Current state of the Cubit
    @Published public private(set) var state: State

    /// Stream of state changes
    private var stateSubject = PassthroughSubject<State, Never>()
    public var stateStream: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    /// Cancellables bag
    private var cancellables = Set<AnyCancellable>()

    /// Initializes the Cubit with an initial state
    public init(initialState: State) {
        self.state = initialState
        setupStateObservation()
    }

    private func setupStateObservation() {
        $state
            .sink { [weak self] newState in
                self?.stateSubject.send(newState)
            }
            .store(in: &cancellables)
    }

    /// Emits a new state
    public func emit(_ newState: State) {
        state = newState
    }

    /// Helper method to emit a loading state when State conforms to BlocBaseState
    public func emitLoading() where State == BlocBaseState<Any, Error> {
        emit(.loading)
    }

    /// Helper method to emit a loaded state when State conforms to BlocBaseState
    public func emitLoaded<T>(_ data: T) where State == BlocBaseState<T, Error> {
        emit(.loaded(data))
    }

    /// Helper method to emit a failure state when State conforms to BlocBaseState
    public func emitFailure<E: Error>(_ error: E) where State == BlocBaseState<Any, E> {
        emit(.failure(error))
    }

    /// Helper method to check if the current state is loading
    public var isLoading: Bool {
        if let baseState = state as? BlocBaseState<Any, Error> {
            if case .loading = baseState {
                return true
            }
        }
        return false
    }

    /// Helper method to check if the current state has loaded data
    public var hasLoaded: Bool {
        if let baseState = state as? BlocBaseState<Any, Error> {
            if case .loaded = baseState {
                return true
            }
        }
        return false
    }

    /// Helper method to check if the current state has an error
    public var hasError: Bool {
        if let baseState = state as? BlocBaseState<Any, Error> {
            if case .failure = baseState {
                return true
            }
        }
        return false
    }

    /// Helper method to get the loaded data if available
    public func getLoadedData<T>() -> T? {
        if let baseState = state as? BlocBaseState<T, Error> {
            if case .loaded(let data) = baseState {
                return data
            }
        }
        return nil
    }

    /// Helper method to get the error if present
    public func getError<E: Error>() -> E? {
        if let baseState = state as? BlocBaseState<Any, E> {
            if case .failure(let error) = baseState {
                return error
            }
        }
        return nil
    }

    deinit {
        // Since the class is already @MainActor-isolated, we can safely access cancellables here
        cancellables.removeAll()
    }
}
