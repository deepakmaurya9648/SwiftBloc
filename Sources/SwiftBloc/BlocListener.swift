//
//  BlocListener.swift
//  SwiftBloc
//
//  Created by Deepak Kumar Maurya on 31/07/25.
//

import SwiftUI
import Combine

/// SwiftUI view that listens to BLoC state changes and performs side effects
public struct BlocListener<
    B: Bloc<Event, BlocStateType>,
    Event: BlocEvent,
    BlocStateType: BlocState,
    Content: View
>: View {
    
    @ObservedObject private var bloc: B
    private let listener: (BlocStateType) -> Void
    private let listenWhen: ((BlocStateType, BlocStateType) -> Bool)?
    private let content: Content
    
    @State private var previousState: BlocStateType?
    
    public init(
        bloc: B,
        listenWhen: ((BlocStateType, BlocStateType) -> Bool)? = nil,
        listener: @escaping (BlocStateType) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.bloc = bloc
        self.listenWhen = listenWhen
        self.listener = listener
        self.content = content()
    }
    
    public var body: some View {
        content
            .onReceive(bloc.$state) { newState in
                if let previous = previousState {
                    if listenWhen?(previous, newState) ?? true {
                        listener(newState)
                    }
                }
                previousState = newState
            }
            .onAppear {
                previousState = bloc.state
            }
    }
}
