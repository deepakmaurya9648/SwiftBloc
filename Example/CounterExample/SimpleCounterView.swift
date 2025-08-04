import SwiftBloc
import SwiftUI

struct SimpleCounterView: View {
    @StateObject private var counterCubit = CounterCubit()

    var body: some View {
        VStack(spacing: 20) {
            Text("Simple Counter App")
                .font(.largeTitle)
                .padding()

            Text("\(counterCubit.state)")
                .font(.system(size: 50, weight: .bold))
                .padding()

            HStack(spacing: 20) {
                // Decrement Button
                Button(action: {
                    counterCubit.decrement()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }

                // Reset Button
                Button(action: {
                    counterCubit.reset()
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }

                // Increment Button
                Button(action: {
                    counterCubit.increment()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
            }
            .padding()

            // State Change History
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("State Changes:")
                        .font(.headline)
                        .padding(.bottom, 4)

                    SimpleStateChangeListener(cubit: counterCubit)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .frame(height: 200)
            .padding()
        }
    }
}

// A view that listens to state changes and displays them
struct SimpleStateChangeListener: View {
    @ObservedObject var cubit: CounterCubit
    @State private var stateChanges: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(stateChanges, id: \.self) { change in
                Text(change)
                    .font(.system(.caption, design: .monospaced))
            }
        }
        .onReceive(cubit.$state) { newState in
            let timestamp = Date().formatted(date: .omitted, time: .standard)
            stateChanges.insert("[\(timestamp)] Count: \(newState)", at: 0)
            if stateChanges.count > 10 {
                stateChanges.removeLast()
            }
        }
    }
}

#Preview {
    SimpleCounterView()
}
