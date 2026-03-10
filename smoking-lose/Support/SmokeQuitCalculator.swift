//
//  SmokeQuitCalculator.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import Foundation

extension SmokeQuitCalculator {
    func milestoneDistanceText(quitDate: Date, now: Date = .now) -> String {
        guard let nextMilestone = nextMilestone(quitDate: quitDate, now: now) else {
            return L10n.text(
                "Вы прошли все ключевые этапы восстановления.",
                "You have passed all major recovery milestones."
            )
        }

        let elapsed = calculateDaysSinceQuit(from: quitDate, now: now)
        let remainingMinutes = max(nextMilestone.minutesSinceQuit - Int(floor(elapsed.totalDays * 1_440)), 0)

        if remainingMinutes >= 1_440 {
            return L10n.text(
                "Следующая цель \(L10n.dayDistance(Int(ceil(Double(remainingMinutes) / 1_440.0))))",
                "Next goal \(L10n.dayDistance(Int(ceil(Double(remainingMinutes) / 1_440.0))))"
            )
        }

        if remainingMinutes >= 60 {
            let remainingHours = max(Int(ceil(Double(remainingMinutes) / 60.0)), 1)
            return L10n.text(
                "Следующая цель \(L10n.hourDistance(remainingHours))",
                "Next goal \(L10n.hourDistance(remainingHours))"
            )
        }

        return L10n.text(
            "Следующая цель \(L10n.minuteDistance(max(remainingMinutes, 1)))",
            "Next goal \(L10n.minuteDistance(max(remainingMinutes, 1)))"
        )
    }
}
