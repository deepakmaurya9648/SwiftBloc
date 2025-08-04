# SwiftBloc Example

This example demonstrates how to use SwiftBloc in a SwiftUI project by implementing a simple Todo List application.

## Features

- Loading state handling
- Error state handling
- Add, toggle, and delete todos
- Clean architecture using SwiftBloc pattern

## Project Structure

```
Example/
├── Todo.swift           // Data model
├── TodoState.swift      // State definition using BlocBaseState
├── TodoCubit.swift      // Business logic
├── TodoListView.swift   // Main UI
└── TodoExampleApp.swift // App entry point
```

## How to Use SwiftBloc

1. Define your state using `BlocBaseState` or create a custom state conforming to `BlocState`:
```swift
typealias TodoState = BlocBaseState<[Todo], Error>
```

2. Create a Cubit subclass to manage your state:
```swift
class TodoCubit: Cubit<TodoState> {
    init() {
        super.init(initialState: .initial)
    }
    
    func loadData() {
        emitLoading()
        // Load data...
        emitLoaded(data)
        // Or if error occurs
        emitFailure(error)
    }
}
```

3. Use the Cubit in your SwiftUI views:
```swift
struct MyView: View {
    @StateObject private var cubit = TodoCubit()
    
    var body: some View {
        if cubit.isLoading {
            ProgressView()
        } else if let data = cubit.getLoadedData() {
            // Show data
        } else if let error = cubit.getError() {
            // Show error
        }
    }
}
```

## Key Concepts

1. **State Management**: SwiftBloc provides a predictable state container that helps manage app state.

2. **Cubit**: A simplified version of Bloc that manages state transitions without events.

3. **BlocBaseState**: A generic enum providing common state patterns (initial, loading, loaded, failure).

4. **Reactive Updates**: SwiftBloc integrates with SwiftUI's view updates through @Published properties.

## Benefits

- Clean separation of concerns
- Predictable state management
- Easy testing
- Simplified error handling
- SwiftUI integration

## Tips

1. Use `@StateObject` for Cubits in SwiftUI views
2. Take advantage of helper methods like `isLoading`, `hasLoaded`, etc.
3. Use type-safe state transitions with `emitLoaded`, `emitFailure`, etc.
4. Keep your Cubit focused on a single responsibility
