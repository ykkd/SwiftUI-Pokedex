//
//  PokemonDetailView.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

private import Dependencies
private import DependencyContainer
import Entity
import Router
import SwiftUI
private import DesignSystem
private import SFSafeSymbols
private import ScreenExtension

// MARK: - PokemonDetailView
public struct PokemonDetailView: View {

    @StateObject private var router: Router

    @State private var state: PokemonDetailViewState

    private let input: CommonScreenInput

    public init(
        router: Router,
        input: CommonScreenInput,
        pokemonNumber: Int
    ) {
        _router = StateObject(wrappedValue: router)
        self.input = input
        state = .init(pokemonNumber: pokemonNumber)
    }

    public var body: some View {
        RouterView(
            router: router,
            withNavigation: input.withNavigation
        ) {
            content()
                .when(state.shouldShowEmptyView) { _ in
                    emptyView()
                }
                .task {
                    await state.getPokemonDetail()
                }
        }
    }
}

extension PokemonDetailView {

    @ViewBuilder
    private func content() -> some View {
        let size = ScreenSizeCalculator.calculate()
        if let data = state.pokemonDetail {
            LazyVStack {
                ZStack {
                    CenteringView {
                        Ellipse()
                            .fill(Color(hex: data.typeHex))
                            .frame(width: size.width * 1.5, height: size.width * 1.5)
                            .clipShape(Rectangle().offset(x: 0, y: size.width * 0.25))
                            .offset(y: -size.width * (state.isBgAniationStarted ? 0.8 : 3.0))
                            .animation(.spring(), value: state.isBgAniationStarted)
                            .task {
                                try? await Task.sleep(for: .seconds(0.1))
                                state.updateIsBgAniationStarted(true)
                            }
                    }
                    ForEach(state.sections, id: \.self) { section in
                        switch section {
                        case .mainVisual:
                            VStack {
                                mainVisual()
                                Spacer()
                            }
                        case .description:
                            EmptyView()
                        case .information:
                            EmptyView()
                        }
                    }
                }
            }
            .padding(.horizontal, SpaceToken.m)
            .refreshableScrollView(spaceName: "PokemonDetail") {
                await state.refresh()
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemBackgroundSecondary))
        } else {
            EmptyView()
        }
    }
}

extension PokemonDetailView {

    @ViewBuilder
    private func mainVisual() -> some View {
        if let data = state.pokemonDetail {
            let size = ScreenSizeCalculator.calculate()
            FallbackableAsyncImage(
                data.imageUrl,
                fallbackUrl: data.subImageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(AspectToken.square.value, contentMode: .fill)
                        .frame(width: size.width * 0.8, height: size.width * 0.8)
                        .shadow(color: Color(.shadow), radius: RadiusToken.s, x: -4, y: 4)
                }
        } else {
            EmptyView()
        }
    }
}

extension PokemonDetailView {

    private func emptyView() -> some View {
        GeometryReader { geometry in
            CenteringView {
                ProgressView()
                    .frame(width: 64, height: 64)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .refreshableScrollView(spaceName: "PokemonDetailEmptyState") {
                await state.refresh()
            }
        }
    }
}

// MARK: - MetaBallView
struct MetaBallView: View {

    @State var progress = 0.0

    var body: some View {
        ZStack {
            Circle()
                .fill(.black)
                .blur(radius: 20.0) // 1
                .frame(width: 100.0, height: 100.0)
                .offset(x: progress * 80.0)
            Circle()
                .fill(.black)
                .blur(radius: 20.0) // 1
                .frame(width: 100.0, height: 100.0)
                .offset(x: -progress * 80.0)
        }
        .frame(width: 300.0, height: 300.0)
        .overlay(
            Color(white: 0.5)
                .blendMode(.colorBurn) // 2
        )
        .overlay(
            Color(white: 1.0)
                .blendMode(.colorDodge) // 3
        )
        .overlay(
            LinearGradient(colors: [.purple, .red],
                           startPoint: .leading,
                           endPoint: .trailing)
                .blendMode(.plusLighter)
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.0)
                    .repeatForever()
            ) {
                progress = 1.0
            }
        }
    }
}
