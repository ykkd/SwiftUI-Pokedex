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
        if let data = state.pokemonDetail {
            GeometryReader { geometry in
                ZStack {
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let eclipseHeight = width * 0.8

                        // 長方形を作成
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: width, y: 0))
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                        path.addLine(to: CGPoint(x: 0, y: 0))

                        // 楕円形を作成し、半円部分が長方形下部方向にはみだす位置に配置
                        path.addEllipse(in: CGRect(
                            x: 0,
                            y: height - (eclipseHeight * 0.5),
                            width: width,
                            height: eclipseHeight
                        ))
                    }
                    .fill(Color(hex: data.typeHex))
                    .offset(y: -geometry.size.height * (state.isBgAniationStarted ? 0.75 : 2.0))
                    .animation(.spring(), value: state.isBgAniationStarted)
                    .task {
                        try? await Task.sleep(for: .seconds(0.1))
                        state.updateIsBgAniationStarted(true)
                    }
                    VStack {
                        ForEach(state.sections, id: \.self) { section in
                            switch section {
                            case .mainVisual:
                                mainVisual(size: geometry.size, data: data)
                            case .description:
                                description(data: data)
                            case .information:
                                EmptyView()
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, SpaceToken.m)
                }
                .refreshableScrollView(spaceName: "PokemonDetail") {
                    await state.refresh()
                }
                .naviBarLeadingButton(type: input.naviBarLeadingButtonType) {
                    router.dismiss()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color(.systemBackgroundSecondary))
            }
        } else {
            EmptyView()
        }
    }
}

extension PokemonDetailView {

    @ViewBuilder
    private func mainVisual(size: CGSize, data: PokemonDetail) -> some View {
        FallbackableAsyncImage(
            data.imageUrl,
            fallbackUrl: data.subImageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(AspectToken.square.value, contentMode: .fill)
                    .frame(width: size.width * 0.8, height: size.width * 0.8)
                    .shadow(color: Color(.shadow), radius: RadiusToken.s, x: -4, y: 4)
            }
    }
}

extension PokemonDetailView {

    @ViewBuilder
    private func description(data: PokemonDetail) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: SpaceToken.s) {
                Text(state.numberText)
                    .fontWithLineHeight(token: .titleTwoBold)
                    .foregroundStyle(Color(.labelSecondary))
                    .lineLimit(1)
                Text(data.name.initialLetterUppercased())
                    .fontWithLineHeight(token: .titleOneBold)
                    .foregroundStyle(Color(.labelPrimary))
                    .lineLimit(1)
            }
            Spacer()
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
