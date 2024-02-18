//
//  BrowseView.swift
//  VisionTwitch
//
//  Created by Adam Gastineau on 2/18/24.
//

import SwiftUI

struct BrowseView: View {
    var body: some View {
        DataView(taskClosure: { api in
            return Task {
                let (streams, _) = try await api.getStreams(limit: 100)
                return streams
            }
        }, content: { streams in
            StreamGridPageView(streams: streams)
        }, error: { _ in
            Text("Error")
        }, requiresAuth: true, runOnAppear: true)
    }
}
