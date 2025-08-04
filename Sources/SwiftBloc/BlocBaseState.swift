import Foundation

/// Base state enum that provides common state patterns
public enum BlocBaseState<T, E: Error>: BlocState {
    /// Initial state when the bloc is created
    case initial
    /// Loading state while processing
    case loading
    /// Success state with associated data
    case loaded(T)
    /// Error state with associated error
    case failure(E)
}
