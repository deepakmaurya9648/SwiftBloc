//
//  BlocProvider.swift
//  SwiftBloc
//
//  Created by Deepak Kumar Maurya on 31/07/25.
//

import SwiftUI

/// Provides a BLoC to its descendants in the SwiftUI view hierarchy
public struct BlocProvider<B: ObservableObject, Content: View>: View {
    
    private let bloc: B
    private let content: Content
    
    public init(
        create: @escaping () -> B,
        @ViewBuilder child: () -> Content
    ) {
        self.bloc = create()
        self.content = child()
    }
    
    public init(
        value: B,
        @ViewBuilder child: () -> Content
    ) {
        self.bloc = value
        self.content = child()
    }
    
    public var body: some View {
        content
            .environmentObject(bloc)
    }
}

/// Environment key for accessing BLoCs from the environment
private struct BlocEnvironmentKey<B: AnyObject>: EnvironmentKey {
    static var defaultValue: B? { nil }
}

extension EnvironmentValues {
    public subscript<B: AnyObject>(blocType: B.Type) -> B? {
        get { self[BlocEnvironmentKey<B>.self] }
        set { self[BlocEnvironmentKey<B>.self] = newValue }
    }
}
