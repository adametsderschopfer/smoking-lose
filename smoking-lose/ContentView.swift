//
//  ContentView.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Query(sort: \UserProfile.createdAt, order: .forward) private var profiles: [UserProfile]
    @StateObject private var viewModel = MainViewModel()

    private var activeProfile: UserProfile? {
        profiles.first
    }

    var body: some View {
        Group {
            if let profile = activeProfile {
                MainDashboardView(profile: profile, viewModel: viewModel)
                    .task {
                        viewModel.handleAppBecameActive()
                    }
                    .onChange(of: scenePhase) { _, newPhase in
                        guard newPhase == .active else { return }
                        viewModel.handleAppBecameActive()
                    }
            } else {
                ProfileFormView(mode: .onboarding)
            }
        }
        .preferredColorScheme(.dark)
        .animation(.snappy(duration: 0.35), value: profiles.count)
    }
}
