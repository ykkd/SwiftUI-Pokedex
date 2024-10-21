//
//  FallbackableAsyncImage.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import SwiftUI

// MARK: - FallbackableAsyncImage
public struct FallbackableAsyncImage<C: View>: View {

    public let content: (Image) -> C
    public let placeholder: (() -> AnyView)?
    public let errorView: ((any Error) -> AnyView)?

    private let primaryUrl: URL?
    private let fallbackUrl: URL?

    @State private var needsFallback: Bool = false

    public init(
        _ primaryUrl: URL?,
        fallbackUrl: URL?,
        content: @escaping (Image) -> C,
        placeholder: (() -> AnyView)? = nil,
        errorView: ((any Error) -> AnyView)? = nil
    ) {
        self.primaryUrl = primaryUrl
        self.fallbackUrl = fallbackUrl
        self.content = content
        self.placeholder = placeholder
        self.errorView = errorView
    }

    public var body: some View {
        if needsFallback {
            asyncImage(fallbackUrl)
        } else {
            asyncImage(primaryUrl) {
                needsFallback = true
            }
        }
    }

    private func asyncImage(_ url: URL?, onError: (() -> Void)? = nil) -> some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                content(image)
            } else if let error = phase.error {
                if let errorView {
                    errorView(error)
                        .onAppear {
                            onError?()
                        }
                } else {
                    EmptyView()
                        .onAppear {
                            onError?()
                        }
                }
            } else {
                if let placeholder {
                    placeholder()
                } else {
                    ProgressView()
                }
            }
        }
    }
}
