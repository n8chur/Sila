//
//  StreamButtonView.swift
//  VisionTwitch
//
//  Created by Adam Gastineau on 2/18/24.
//

import SwiftUI
import Twitch

struct StreamButtonView: View {
    @Environment(Router.self) private var router
    @Environment(\.openWindow) private var openWindow

    let stream: Twitch.Stream

    var body: some View {
        AsyncImageButtonView(imageUrl: buildImageUrl(using: self.stream), aspectRatio: 16.0/9.0, overlayAlignment: .bottomTrailing) {
            openWindow(id: "channelVideo", value: stream)
        } content: {
            VStack(alignment: .leading) {
                HStack {
                    Text(self.stream.gameName)
                    Spacer()
                    Text(self.stream.startedAt.formatted())
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)

                Text(self.stream.title)
                    .font(.title3)
                    .lineLimit(1)
                Text(self.stream.userName)
                    .truncationMode(.tail)
                    .lineLimit(1)

//                    tagList(stream.tags)
            }
        } imageOverlay: {
            HStack {
                Image(systemName: Icon.viewerCount)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.red, .white)
                Text(self.stream.viewerCount.formatted(.number))
            }
            .padding(4)
            .background(.black.opacity(0.5))
            .clipShape(.rect(cornerRadius: 8))
            .padding()
        }
        .contextMenu {
            let channelButton = Button {
                self.router.path.append(Route.channel(user: .id(stream.userId)))
            } label: {
                Label("View Channel", systemImage: Icon.channel)
            }

            let categoryButton = Button {
                self.router.path.append(Route.category(game: .id(stream.gameID)))
            } label: {
                Label("More in this Category", systemImage: Icon.category)
            }

            if let last = self.router.path.last {
                switch last {
                case .channel:
                    // We're in a channel view, we're already looking at this channel
                    EmptyView()
                default:
                    channelButton
                }
            } else {
                channelButton
            }

            if let last = self.router.path.last {
                switch last {
                case .category:
                    // We're in a category view, we're already looking at this category
                    EmptyView()
                default:
                    categoryButton
                }
            } else {
                categoryButton
            }
        }
    }

    @ViewBuilder
    func tagList(_ list: [String]) -> some View {
        HStack {
            ForEach(list, id: \.self) { tag in
                TagView(text: tag)
            }
        }
    }

    func buildImageUrl(using stream: Twitch.Stream) -> URL? {
        let url = stream.thumbnailURL.replacingOccurrences(of: "{width}", with: "960").replacingOccurrences(of: "{height}", with: "540")

        return URL(string: url)
    }
}

#Preview {
    NavStack {
        StreamButtonView(stream: STREAM_MOCK())
            .frame(width: 400, height: 300)
    }
}
