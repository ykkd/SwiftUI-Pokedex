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
                    backgroundShape(geometry.size, shapeColor: Color(hex: data.typeHex))
                    VStack {
                        ForEach(state.sections, id: \.self) { section in
                            switch section {
                            case .mainVisual:
                                mainVisual(size: geometry.size, data: data)
                            case .description:
                                description(data: data)
                            case .status:
                                status(data: data)
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
    private func backgroundShape(_ size: CGSize, shapeColor: Color) -> some View {
        Path { path in
            let width = size.width
            let height = size.height
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
        .fill(shapeColor)
        .offset(y: -size.height * (state.isBgAniationStarted ? 0.75 : 2.0))
        .animation(.spring(), value: state.isBgAniationStarted)
        .task {
            try? await Task.sleep(for: .seconds(0.1))
            state.updateIsBgAniationStarted(true)
        }
    }
}

extension PokemonDetailView {

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

    private func description(data: PokemonDetail) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: .zero) {
                Text(state.numberText)
                    .fontWithLineHeight(token: .headlineSemibold)
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

extension Array {

    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        var currentIndex = 0
        while currentIndex < count {
            let endIndex = Swift.min(currentIndex + size, count)
            chunks.append(Array(self[currentIndex ..< endIndex]))
            currentIndex = endIndex
        }
        return chunks
    }
}

extension PokemonDetailView {

    @ViewBuilder
    private func status(data: PokemonDetail) -> some View {
        Grid(horizontalSpacing: SpaceToken.s, verticalSpacing: SpaceToken.s) {
            // 3列のグリッドを作成
            ForEach(data.status.chunked(into: 3), id: \.self) { rowItems in
                GridRow {
                    ForEach(rowItems, id: \.self) { item in
                        statusItemView(item)
                    }
                }
            }
        }
    }

    private func statusItemView(_ status: PokemonStatus) -> some View {
        VStack {
            statusImage(status)
            Text(status.type.rawValue.initialLetterUppercased())
                .fontWithLineHeight(token: .captionTwoRegular)
                .foregroundStyle(Color(.labelPrimary))
                .lineLimit(2)
            Text("\(status.value)")
                .fontWithLineHeight(token: .bodySemibold)
                .foregroundStyle(Color(.labelPrimary))
                .lineLimit(1)
        }
        .padding(SpaceToken.m)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackgroundPrimary))
        .cornerRadius(RadiusToken.l)
    }

    private func statusImage(_ status: PokemonStatus) -> some View {
        let symbolName: SFSymbol = switch status.type {
        case .attack:
            .flameFill
        case .defense:
            .shieldFill
        case .hp:
            .heartFill
        case .specialAttack:
            .firewallFill
        case .specialDefense:
            .boltShield
        case .speed:
            .figureRun
        }

        return Image(systemSymbol: symbolName)
            .resizable()
            .foregroundStyle(Color(.labelPrimary))
            .frame(width: 24, height: 24)
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
