//
//  RecoveryNotificationManager.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import Foundation
import UserNotifications

struct RecoveryNotificationManager {
    private static let identifierPrefix = "recovery-milestone-"

    func refreshNotifications(for profile: UserProfile) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }

            let identifiers = HealthMilestone.timeline.map { Self.identifier(for: $0) }
            center.removePendingNotificationRequests(withIdentifiers: identifiers)

            let requests = scheduledRequests(for: profile)
            for request in requests {
                center.add(request) { _ in }
            }
        }
    }

    private func scheduledRequests(for profile: UserProfile, now: Date = .now) -> [UNNotificationRequest] {
        HealthMilestone.timeline.compactMap { milestone in
            let fireDate = profile.quitDate.addingTimeInterval(TimeInterval(milestone.minutesSinceQuit * 60))
            guard fireDate > now.addingTimeInterval(5) else { return nil }

            let content = UNMutableNotificationContent()
            content.title = L10n.text("Новый шаг восстановления", "New recovery step")
            content.body = "\(milestone.timelineLabel): \(milestone.title)"
            content.sound = .default

            let components = Calendar.autoupdatingCurrent.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: fireDate
            )
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            return UNNotificationRequest(
                identifier: Self.identifier(for: milestone),
                content: content,
                trigger: trigger
            )
        }
    }

    private static func identifier(for milestone: HealthMilestone) -> String {
        "\(identifierPrefix)\(milestone.id)"
    }
}
