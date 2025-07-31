//
//  BlocBuilder.swift
//  SwiftBloc
//
//  Created by Deepak Kumar Maurya on 31/07/25.
//

import SwiftUI
import Combine

/// SwiftUI view that rebuilds when BLoC state changes
public struct BlocBuilder<B: Bloc<Event, State>, Event: BlocEvent, State: BlocState, Content: View>: View {
    
    @ObservedObject private var bloc: B
    private let builder: (State) -> Content
    private let buildWhen: ((State, State) -> Bool)?
    
    public init(
        bloc: B,
        buildWhen: ((State, State) -> Bool)? = nil,
        @ViewBuilder builder: @escaping (State) -> Content
    ) {
        self.bloc = bloc
        self.buildWhen = buildWhen
        self.builder = builder
    }
    
    public var body: some View {
        builder(bloc.state)
    }
}

/// SwiftUI view that rebuilds when Cubit state changes
public struct CubitBuilder<C: Cubit<State>, State: BlocState, Content: View>: View {
    
    @ObservedObject private var cubit: C
    private let builder: (State) -> Content
    private let buildWhen: ((State, State) -> Bool)?
    
    public init(
        cubit: C,
        buildWhen: ((State, State) -> Bool)? = nil,
        @ViewBuilder builder: @escaping (State) -> Content
    ) {
        self.cubit = cubit
        self.buildWhen = buildWhen
        self.builder = builder
    }
    
    public var body: some View {
        builder(cubit.state)
    }
}
