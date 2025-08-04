import Foundation
import SwiftBloc

@MainActor
class CounterCubit: Cubit<CounterState> {
    init() {
        super.init(initialState: .initial)
    }

    // Increment the counter
    func increment() {
        emit(CounterState(count: state.count + 1))
    }

    // Decrement the counter
    func decrement() {
        emit(CounterState(count: state.count - 1))
    }

    // Reset the counter
    func reset() {
        emit(.initial)
    }
}
