# Counter Example with SwiftBloc

This is a simple counter application that demonstrates the basic usage of SwiftBloc's Cubit pattern.

## Features

- Increment counter
- Decrement counter
- Reset counter
- State change history display
- Clean SwiftUI integration

## Project Structure

```
CounterExample/
├── CounterState.swift     // State definition
├── CounterCubit.swift     // Business logic
├── CounterView.swift      // UI implementation
└── CounterExampleApp.swift // App entry point
```

## Key Points Demonstrated

1. **Simple State Management**
   - Using a basic `CounterState` structure
   - Immutable state updates
   - State history tracking

2. **Cubit Usage**
   - Defining clear actions (increment, decrement, reset)
   - State emission
   - SwiftUI integration with @StateObject

3. **SwiftUI Integration**
   - Clean view architecture
   - State observation
   - UI updates

## How It Works

1. **State Definition**
```swift
struct CounterState: BlocState {
    let count: Int
    static var initial: CounterState {
        CounterState(count: 0)
    }
}
```

2. **Cubit Implementation**
```swift
class CounterCubit: Cubit<CounterState> {
    func increment() {
        emit(CounterState(count: state.count + 1))
    }
    
    func decrement() {
        emit(CounterState(count: state.count - 1))
    }
}
```

3. **View Integration**
```swift
struct CounterView: View {
    @StateObject private var counterCubit = CounterCubit()
    
    var body: some View {
        // UI implementation using counterCubit.state
    }
}
```

## Running the Example

1. Open the CounterExample directory
2. Build and run the project
3. Try out the increment, decrement, and reset functionality
4. Observe the state change history at the bottom of the screen
