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
import SFSafeSymbols
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
                .id(state.contentId)
                .when(state.shouldShowEmptyView) { _ in
                    emptyStateView()
                }
                .task {
                    await getPokemonDetail()
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
                        let length = geometry.size.width - (SpaceToken.m * 2)
                        let size = CGSize(width: length, height: length)
                        mainVisual(size: size, data: data)
                        description(data: data)
                        status(data: data)
                        information(data: data)
                        Spacer()
                    }
                    .padding(.horizontal, SpaceToken.m)
                    .padding(.top, 64)
                }
                .refreshableScrollView(spaceName: "PokemonDetail") {
                    await refresh()
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
            fallbackUrl: data.subImageUrl
        ) { image in
            image
                .resizable()
                .aspectRatio(AspectToken.square.value, contentMode: .fill)
                .shadow(color: Color(.shadow), radius: RadiusToken.s, x: -4, y: 4)
        }
        .frame(width: size.width, height: size.width)
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
            FavoriteButton(
                isFavorite: Binding(
                    get: {
                        state.isFavorite
                    },
                    set: { _ in }
                )
            ) { isFavorite in
                Task {
                    await updateIsFavorite(isFavorite)
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
        .padding(SpaceToken.s)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackgroundPrimary))
        .cornerRadius(RadiusToken.l)
    }

    private func statusImage(_ status: PokemonStatus) -> some View {
        Image(systemSymbol: ViewLogic.getSymbolForStatusImage(status))
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

    @ViewBuilder
    private func informationItemView(_ type: PokemonDetail.Information.InfoType) -> some View {
        let input = ViewLogic.generateInformationItemViewInput(type)

        HStack {
            HStack {
                CenteringView {
                    Image(systemSymbol: input.symbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundStyle(Color(.labelPrimary))
                }
                .frame(width: 32)
                Text(input.title)
                    .fontWithLineHeight(token: .subheadlineRegular)
                    .foregroundStyle(Color(.labelPrimary))
                    .lineLimit(1)
                Spacer()
            }
            Text(input.description)
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

    private func emptyStateView() -> some View {
        GeometryReader { geometry in
            CenteringView {
                ProgressView()
                    .frame(width: 64, height: 64)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .refreshableScrollView(spaceName: "PokemonDetailEmptyState") {
                await refresh()
            }
        }
    }
}

// MARK: - Error handling
extension PokemonDetailView {

    private func getPokemonDetail() async {
        do {
            try await state.getPokemonDetail()
        } catch {
            router.presentAlertView(
                error: error,
                buttons: [
                    .ok(action: nil),
                    .retry {
                        Task {
                            await getPokemonDetail()
                        }
                    },
                ]
            )
        }
    }

    private func refresh() async {
        do {
            try? await Task.sleep(for: .seconds(1.0))
            try await state.refresh()
        } catch {
            router.presentAlertView(
                error: error,
                buttons: [
                    .ok(action: nil),
                    .retry {
                        Task {
                            await refresh()
                        }
                    },
                ]
            )
        }
    }

    private func updateIsFavorite(_ value: Bool) async {
        do {
            try await state.updateIsFavorite(value)
        } catch {
            router.presentAlertView(
                error: error,
                buttons: [
                    .ok(action: nil),
                ]
            )
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
