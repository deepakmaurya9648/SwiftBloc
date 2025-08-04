# SwiftBloc 🚀

A Swift Package inspired by Flutter's BLoC (Business Logic Component) architecture pattern. SwiftBloc helps you separate business logic from UI and manage app state in a structured, predictable way using Combine and SwiftUI.

## 🎯 What is BLoC?

The BLoC (Business Logic Component) pattern separates presentation from business logic, making your code:

- **Testable**: Business logic is isolated and easy to unit test
- **Reusable**: BLoCs can be shared across different UI components
- **Predictable**: Unidirectional data flow makes state changes predictable
- **Maintainable**: Clear separation of concerns

### Flow Diagram
```
UI Events → BLoC → State Changes → UI Updates
```

## 📦 Installation

### Swift Package Manager

Add SwiftBloc to your project using Xcode:

1. Go to **File > Add Package Dependencies**
2. Enter the repository URL: `https://github.com/yourusername/SwiftBloc.git`
3. Select your desired version
4. Add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/deepakmaurya9648/SwiftBloc.git", from: "1.0.0")
]
```

## 🚀 Quick Start

### 1. Import SwiftBloc

```swift
import SwiftBloc
import SwiftUI
```

### 2. Define Your Events and States

```swift
// Events - What can happen
enum CounterEvent: BlocEvent {
    case increment
    case decrement
    case reset
}

// State - What the UI needs to know
struct CounterState: BlocState {
    let count: Int
    let isEven: Bool
    
    init(count: Int) {
        self.count = count
        self.isEven = count % 2 == 0
    }
}
```

### 3. Create Your BLoC

```swift
class CounterBloc: Bloc<CounterEvent, CounterState> {
    
    init() {
        super.init(initialState: CounterState(count: 0))
    }
    
    override func mapEventToState(_ event: CounterEvent) -> AnyPublisher<CounterState, Never> {
        switch event {
        case .increment:
            return emit(CounterState(count: state.count + 1))
            
        case .decrement:
            return emit(CounterState(count: state.count - 1))
            
        case .reset:
            return emit(CounterState(count: 0))
        }
    }
}
```

### 4. Use in SwiftUI

```swift
struct CounterView: View {
    @StateObject private var counterBloc = CounterBloc()
    
    var body: some View {
        BlocBuilder(bloc: counterBloc) { state in
            VStack(spacing: 20) {
                Text("Count: \(state.count)")
                    .font(.largeTitle)
                    .foregroundColor(state.isEven ? .blue : .red)
                
                Text(state.isEven ? "Even" : "Odd")
                    .font(.title2)
                
                HStack(spacing: 15) {
                    Button("−") {
                        counterBloc.add(.decrement)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Reset") {
                        counterBloc.add(.reset)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("+") {
                        counterBloc.add(.increment)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
}
```

## 📚 Core Components

### Bloc<Event, State>

The main BLoC class for event-driven state management:

```swift
class MyBloc: Bloc<MyEvent, MyState> {
    init() {
        super.init(initialState: MyState.initial)
    }
    
    override func mapEventToState(_ event: MyEvent) -> AnyPublisher<MyState, Never> {
        switch event {
        case .doSomething:
            return emit(MyState.updated)
        }
    }
}
```

### Cubit<State>

Simplified version without events, for direct state management:

```swift
class ToggleCubit: Cubit<Bool> {
    init() {
        super.init(initialState: false)
    }
    
    func toggle() {
        emit(!state)
    }
}

// Usage in SwiftUI
CubitBuilder(cubit: toggleCubit) { isToggled in
    Toggle("Feature", isOn: .constant(isToggled))
        .onChange(of: isToggled) { _ in
            toggleCubit.toggle()
        }
}
```

## 🎨 SwiftUI Integration

### BlocBuilder

Rebuilds UI when state changes:

```swift
BlocBuilder(bloc: myBloc) { state in
    Text("Current state: \(state.description)")
}

// With conditional rebuilding
BlocBuilder(
    bloc: myBloc,
    buildWhen: { previous, current in
        previous.importantProperty != current.importantProperty
    }
) { state in
    ExpensiveView(data: state.importantProperty)
}
```

### BlocListener

Performs side effects without rebuilding UI:

```swift
BlocListener(
    bloc: authBloc,
    listener: { state in
        if case .authenticated = state {
            // Navigate to main screen
            navigationManager.navigate(to: .main)
        }
    }
) {
    LoginForm()
}
```

### BlocConsumer

Combines BlocBuilder and BlocListener:

```swift
BlocConsumer(
    bloc: formBloc,
    listener: { state in
        if case .error(let message) = state {
            showAlert(message)
        }
    },
    builder: { state in
        FormView(isLoading: state.isLoading)
    }
)
```

### BlocProvider

Provides BLoC to child widgets:

```swift
BlocProvider(create: { AuthBloc() }) {
    NavigationView {
        ContentView()
    }
}

// Access in child views
struct ContentView: View {
    @EnvironmentObject var authBloc: AuthBloc
    
    var body: some View {
        // Use authBloc here
    }
}
```

## 💡 Advanced Examples

### Weather App

```swift
// Events
enum WeatherEvent: BlocEvent {
    case fetchWeather(city: String)
    case refresh
}

// States
enum WeatherState: BlocState {
    case initial
    case loading
    case loaded(Weather)
    case error(String)
}

// BLoC
class WeatherBloc: Bloc<WeatherEvent, WeatherState> {
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
        super.init(initialState: .initial)
    }
    
    override func mapEventToState(_ event: WeatherEvent) -> AnyPublisher<WeatherState, Never> {
        switch event {
        case .fetchWeather(let city):
            return fetchWeatherFlow(for: city)
        case .refresh:
            return refreshWeatherFlow()
        }
    }
    
    private func fetchWeatherFlow(for city: String) -> AnyPublisher<WeatherState, Never> {
        return Publishers.Sequence(sequence: [WeatherState.loading])
            .append(
                weatherService.getWeather(for: city)
                    .map { WeatherState.loaded($0) }
                    .catch { error in
                        Just(WeatherState.error(error.localizedDescription))
                    }
            )
            .eraseToAnyPublisher()
    }
}

// SwiftUI View
struct WeatherView: View {
    @StateObject private var weatherBloc = WeatherBloc(
        weatherService: WeatherService()
    )
    
    var body: some View {
        BlocConsumer(
            bloc: weatherBloc,
            listener: { state in
                if case .error(let message) = state {
                    // Show error toast
                    showErrorToast(message)
                }
            },
            builder: { state in
                switch state {
                case .initial:
                    WelcomeView {
                        weatherBloc.add(.fetchWeather(city: "London"))
                    }
                    
                case .loading:
                    ProgressView("Loading weather...")
                    
                case .loaded(let weather):
                    WeatherDetailView(weather: weather) {
                        weatherBloc.add(.refresh)
                    }
                    
                case .error:
                    ErrorView {
                        weatherBloc.add(.refresh)
                    }
                }
            }
        )
    }
}
```

### Form Validation

```swift
// Form State
struct FormState: BlocState {
    let email: String
    let password: String
    let isEmailValid: Bool
    let isPasswordValid: Bool
    let isLoading: Bool
    
    var isFormValid: Bool {
        isEmailValid && isPasswordValid
    }
}

// Form Cubit (simpler for forms)
class FormCubit: Cubit<FormState> {
    init() {
        super.init(initialState: FormState(
            email: "",
            password: "",
            isEmailValid: false,
            isPasswordValid: false,
            isLoading: false
        ))
    }
    
    func updateEmail(_ email: String) {
        emit(FormState(
            email: email,
            password: state.password,
            isEmailValid: isValidEmail(email),
            isPasswordValid: state.isPasswordValid,
            isLoading: state.isLoading
        ))
    }
    
    func updatePassword(_ password: String) {
        emit(FormState(
            email: state.email,
            password: password,
            isEmailValid: state.isEmailValid,
            isPasswordValid: password.count >= 6,
            isLoading: state.isLoading
        ))
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
}
```

## 🧪 Testing

SwiftBloc makes testing easy by isolating business logic:

```swift
import XCTest
@testable import YourApp

class CounterBlocTests: XCTestCase {
    var counterBloc: CounterBloc!
    
    override func setUp() {
        counterBloc = CounterBloc()
    }
    
    func testInitialState() {
        XCTAssertEqual(counterBloc.state.count, 0)
    }
    
    func testIncrement() {
        // Given
        let expectation = XCTestExpectation(description: "State changed")
        
        // When
        counterBloc.$state
            .dropFirst() // Skip initial state
            .sink { state in
                // Then
                XCTAssertEqual(state.count, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        counterBloc.add(.increment)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
```

## 🎛️ Best Practices

### 1. Keep States Immutable
```swift
struct AppState: BlocState {
    let user: User?
    let isLoading: Bool
    
    // ✅ Create new instances instead of mutating
    func withUser(_ user: User) -> AppState {
        AppState(user: user, isLoading: isLoading)
    }
}
```

### 2. Use Meaningful Event Names
```swift
enum UserEvent: BlocEvent {
    case signInRequested(email: String, password: String)  // ✅ Clear intent
    case signOutRequested                                  // ✅ Clear intent
    // ❌ case buttonTapped
}
```

### 3. Handle All State Cases in UI
```swift
BlocBuilder(bloc: userBloc) { state in
    switch state {
    case .initial: WelcomeView()
    case .loading: ProgressView()
    case .authenticated(let user): MainAppView(user: user)
    case .unauthenticated: LoginView()
    case .error(let message): ErrorView(message: message)
    // ✅ All cases handled
    }
}
```

### 4. Use BlocListener for Side Effects
```swift
BlocListener(
    bloc: navigationBloc,
    listener: { state in
        // ✅ Side effects only
        if state.shouldNavigateToSettings {
            navigate(to: .settings)
        }
    }
) {
    // UI content here
}
```

## � Examples

We provide several examples to help you get started with SwiftBloc:

### [Counter Example](/Example/CounterExample) - Start Here! 🎯
A simple counter application demonstrating basic Cubit usage:
- Basic state management
- Simple UI integration
- Two implementations:
  - Using custom CounterState
  - Direct Int state manipulation
- State change history tracking

### [Todo List Example](/Example/TodoExample) - Real World Usage 📝
A more complex example showing:
- BlocBaseState usage
- Loading states
- Error handling
- CRUD operations
- Async operations

Each example includes:
- Complete source code
- Detailed README
- Best practices
- Step-by-step explanations

## 🗺️ Example Navigation

```
/Example
├── CounterExample/           # Basic counter app
│   ├── README.md            # Counter example guide
│   ├── SimpleCounterCubit/  # Direct Int state version
│   └── CounterCubit/        # Custom state version
│
└── TodoExample/             # Todo list app
    ├── README.md            # Todo example guide
    └── ... 
```

To run the examples:
1. Clone the repository
2. Open the desired example folder
3. Build and run the project
4. Check the example's README for detailed explanations

## �🛠️ Requirements

- iOS 14.0+ / macOS 11.0+ / tvOS 14.0+ / watchOS 7.0+
- Swift 5.9+
- Xcode 15.0+

## 🤝 Contributing

We welcome contributions! Please feel free to:
- Submit Pull Requests
- Report issues
- Suggest new examples
- Improve documentation

## 📄 License

SwiftBloc is available under the MIT license. See the LICENSE file for more info.

## 🙏 Acknowledgments

- Inspired by the [Flutter BLoC library](https://bloclibrary.dev/)
- Built with ❤️ for the Swift community

---

**Happy coding with SwiftBloc! 🎉**

Want to learn more? Check out our [example projects](/Example) to see SwiftBloc in action!
