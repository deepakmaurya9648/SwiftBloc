import Foundation
import SwiftBloc

@MainActor
class CounterCubit: Cubit<Int> {
    init() {
        super.init(initialState: 0)
    }

    // Increment the counter
    func increment() {
        emit(state + 1)
    }

    // Decrement the counter
    func decrement() {
        emit(state - 1)
    }

    // Reset the counter
    func reset() {
        emit(0)
    }
}
