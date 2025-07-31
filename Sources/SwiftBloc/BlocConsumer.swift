//
//  BlocConsumer.swift
//  SwiftBloc
//
//  Created by Deepak Kumar Maurya on 31/07/25.
//

import SwiftUI

/// SwiftUI view that combines BlocBuilder and BlocListener
public struct BlocConsumer<B: Bloc<Event, State>, Event: BlocEvent, State: BlocState, Content: View>: View {
    
    private let bloc: B
    private let builder: (State) -> Content
    private let listener: (State) -> Void
    private let buildWhen: ((State, State) -> Bool)?
    private let listenWhen: ((State, State) -> Bool)?
    
    public init(
        bloc: B,
        buildWhen: ((State, State) -> Bool)? = nil,
        listenWhen: ((State, State) -> Bool)? = nil,
        listener: @escaping (State) -> Void,
        @ViewBuilder builder: @escaping (State) -> Content
    ) {
        self.bloc = bloc
        self.buildWhen = buildWhen
        self.listenWhen = listenWhen
        self.listener = listener
        self.builder = builder
    }
    
    public var body: some View {
        BlocListener(
            bloc: bloc,
            listenWhen: listenWhen,
            listener: listener
        ) {
            BlocBuilder(
                bloc: bloc,
                buildWhen: buildWhen,
                builder: builder
            )
        }
    }
}
