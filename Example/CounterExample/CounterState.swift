import Foundation
import SwiftBloc

// Simple state that just holds a count value
struct CounterState: BlocState {
    let count: Int

    static var initial: CounterState {
        CounterState(count: 0)
    }
}
