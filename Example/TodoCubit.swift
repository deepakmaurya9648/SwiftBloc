import Foundation
import SwiftBloc

@MainActor
class TodoCubit: Cubit<TodoState> {
    init() {
        super.init(initialState: .initial)
        // Load initial todos
        loadTodos()
    }

    private func loadTodos() {
        // Simulating loading data from a data source
        emitLoading()

        // Simulate network delay
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second delay
            let initialTodos = [
                Todo(title: "Learn SwiftBloc"),
                Todo(title: "Build Amazing Apps"),
                Todo(title: "Share with Community"),
            ]
            emitLoaded(initialTodos)
        }
    }

    func addTodo(_ title: String) {
        guard let currentTodos = getLoadedData() else {
            return
        }

        var updatedTodos = currentTodos
        updatedTodos.append(Todo(title: title))
        emitLoaded(updatedTodos)
    }

    func toggleTodo(_ todo: Todo) {
        guard let currentTodos = getLoadedData() else {
            return
        }

        var updatedTodos = currentTodos
        if let index = updatedTodos.firstIndex(where: { $0.id == todo.id }) {
            updatedTodos[index].isCompleted.toggle()
            emitLoaded(updatedTodos)
        }
    }

    func deleteTodo(_ todo: Todo) {
        guard let currentTodos = getLoadedData() else {
            return
        }

        let updatedTodos = currentTodos.filter { $0.id != todo.id }
        emitLoaded(updatedTodos)
    }
}
