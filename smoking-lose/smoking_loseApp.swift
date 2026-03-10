//
//  smoking_loseApp.swift
//  smoking-lose
//
//  Created by Vladislav Adamets on 28.02.2026.
//

import SwiftUI
import SwiftData

@main
struct smoking_loseApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
        ])
        let persistentStoreURL = storeURL()
        let modelConfiguration = ModelConfiguration(schema: schema, url: persistentStoreURL)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            resetStore(at: persistentStoreURL)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer after store reset: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(AppPalette.accent)
        }
        .modelContainer(sharedModelContainer)
    }

    private static func storeURL() -> URL {
        let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let directoryURL = baseURL.appendingPathComponent("SmokingLose", isDirectory: true)

        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)

        return directoryURL.appendingPathComponent("smoking-lose.store")
    }

    private static func resetStore(at url: URL) {
        let fileManager = FileManager.default
        let sidecars = [
            url,
            URL(fileURLWithPath: url.path + "-shm"),
            URL(fileURLWithPath: url.path + "-wal"),
        ]

        for fileURL in sidecars where fileManager.fileExists(atPath: fileURL.path) {
            try? fileManager.removeItem(at: fileURL)
        }
    }
}
