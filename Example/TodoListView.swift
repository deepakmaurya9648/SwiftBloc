import SwiftBloc
import SwiftUI

struct TodoListView: View {
    @StateObject private var todoCubit = TodoCubit()
    @State private var newTodoTitle = ""

    var body: some View {
        NavigationView {
            ZStack {
                if todoCubit.isLoading {
                    ProgressView("Loading todos...")
                } else if let todos = todoCubit.getLoadedData() {
                    VStack {
                        List {
                            ForEach(todos) { todo in
                                TodoRowView(todo: todo) {
                                    todoCubit.toggleTodo(todo)
                                } onDelete: {
                                    todoCubit.deleteTodo(todo)
                                }
                            }
                        }

                        HStack {
                            TextField("New todo", text: $newTodoTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button("Add") {
                                if !newTodoTitle.isEmpty {
                                    todoCubit.addTodo(newTodoTitle)
                                    newTodoTitle = ""
                                }
                            }
                        }
                        .padding()
                    }
                } else if let error = todoCubit.getError() as? Error {
                    VStack {
                        Text("Error: \(error.localizedDescription)")
                        Button("Retry") {
                            // Reload todos
                        }
                    }
                }
            }
            .navigationTitle("SwiftBloc Todos")
        }
    }
}

struct TodoRowView: View {
    let todo: Todo
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }

            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .gray : .primary)

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TodoListView()
}
