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
private import SharedExtension

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
        .ignoresSafeArea(edges: [.top])
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
                                information(data: data)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, SpaceToken.m)
                    .padding(.top, 64)
                }
                .refreshableScrollView(spaceName: "PokemonDetail") {
                    await state.refresh()
                }
                .toolBarButton(placement: .topBarLeading, type: input.naviBarLeadingButtonType) {
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
            FavoriteButton(isFavorited: state.isFavorited) { isFavorited in
                Task {
                    await state.updateIsFavorited(isFavorited)
                }
            }
        }
    }
}

extension PokemonDetailView {

    @ViewBuilder
    private func status(data: PokemonDetail) -> some View {
        Grid(horizontalSpacing: SpaceToken.s, verticalSpacing: SpaceToken.s) {
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
            Text(status.type.title)
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
            .aspectRatio(contentMode: .fit)
            .frame(height: 24)
    }
}

extension PokemonDetailView {

    @ViewBuilder
    private func information(data: PokemonDetail) -> some View {
        VStack(spacing: SpaceToken.s) {
            ForEach(data.information.infoTypes, id: \.self) { type in
                informationItemView(type)
            }
        }
    }

    private func informationItemView(_ type: PokemonDetail.Information.InfoType) -> some View {
        let symbol: SFSymbol
        let title: String
        let description: String

        switch type {
        case let .pokemonTypes(pokemonTypes):
            symbol = .dropHalffull
            title = "Type"
            let joined = pokemonTypes.map(\.text).joined(separator: " ")
            description = joined
        case let .height(height):
            symbol = .personFill
            title = "Height"
            description = "\(height)m"
        case let .weight(weight):
            symbol = .scalemassFill
            title = "Weight"
            description = "\(weight)kg"
        case let .firstAbility(ability):
            symbol = .circleLefthalfFilled
            title = "Ability 1"
            description = "\(ability)"
        case let .secondAbility(ability):
            symbol = .circleRighthalfFilled
            title = "Ability 2"
            description = "\(ability ?? "None")"
        case let .hiddenAblity(ability):
            symbol = .circleInsetFilled
            title = "Hidden Ablity"
            description = "\(ability ?? "None")"
        }

        return HStack {
            HStack {
                CenteringView {
                    Image(systemSymbol: symbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundStyle(Color(.labelPrimary))
                }
                .frame(width: 32)
                Text(title)
                    .fontWithLineHeight(token: .subheadlineRegular)
                    .foregroundStyle(Color(.labelPrimary))
                    .lineLimit(1)
                Spacer()
            }
            Text(description)
                .fontWithLineHeight(token: .subheadlineRegular)
                .foregroundStyle(Color(.labelPrimary))
                .lineLimit(1)
        }
        .padding(.vertical, SpaceToken.s)
        .padding(.horizontal, SpaceToken.l)
        .background(Color(.systemBackgroundPrimary))
        .cornerRadius(RadiusToken.l)
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

#Preview {
    PokemonDetailView(
        router: .init(isPresented: .constant(.pokemonDetail(number: 1))),
        input: .init(withNavigation: false, naviBarLeadingButtonType: .back),
        pokemonNumber: 1
    )
}
