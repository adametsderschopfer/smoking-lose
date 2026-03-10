//
//  AppSupport.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum AppLanguage: String {
    case russian
    case english

    static var systemDefault: AppLanguage {
        let primaryLanguage = Locale.preferredLanguages.first?
            .split(separator: "-")
            .first?
            .lowercased()

        return primaryLanguage == "ru" ? .russian : .english
    }
}

enum L10n {
    static var currentLanguage: AppLanguage {
        AppLanguage.systemDefault
    }

    static var isRussian: Bool {
        currentLanguage == .russian
    }

    static func text(_ russian: String, _ english: String) -> String {
        currentLanguage == .russian ? russian : english
    }

    static func count(_ value: Int, ruOne: String, ruFew: String, ruMany: String, enOne: String, enMany: String) -> String {
        if isRussian {
            let mod10 = value % 10
            let mod100 = value % 100

            let word: String
            if mod10 == 1 && mod100 != 11 {
                word = ruOne
            } else if (2...4).contains(mod10) && !(12...14).contains(mod100) {
                word = ruFew
            } else {
                word = ruMany
            }

            return "\(value) \(word)"
        }

        return "\(value) \(value == 1 ? enOne : enMany)"
    }

    static func smokeFreeDuration(days: Int, hours: Int, minutes: Int) -> String {
        let daysText = count(days, ruOne: "день", ruFew: "дня", ruMany: "дней", enOne: "day", enMany: "days")
        let hoursText = count(hours, ruOne: "час", ruFew: "часа", ruMany: "часов", enOne: "hour", enMany: "hours")
        let minutesText = count(minutes, ruOne: "минута", ruFew: "минуты", ruMany: "минут", enOne: "minute", enMany: "minutes")
        return text(
            "Вы не курите \(daysText) \(hoursText) \(minutesText)",
            "Smoke-free for \(daysText) \(hoursText) \(minutesText)"
        )
    }

    static func dayDistance(_ days: Int) -> String {
        let dayText = count(days, ruOne: "день", ruFew: "дня", ruMany: "дней", enOne: "day", enMany: "days")
        return text("через \(dayText)", "in \(dayText)")
    }

    static func hourDistance(_ hours: Int) -> String {
        let hourText = count(hours, ruOne: "час", ruFew: "часа", ruMany: "часов", enOne: "hour", enMany: "hours")
        return text("через \(hourText)", "in \(hourText)")
    }

    static func minuteDistance(_ minutes: Int) -> String {
        let minuteText = count(minutes, ruOne: "минуту", ruFew: "минуты", ruMany: "минут", enOne: "minute", enMany: "minutes")
        return text("через \(minuteText)", "in \(minuteText)")
    }
}

enum AppPalette {
    static let accent = Color(red: 0.36, green: 0.77, blue: 0.95)
    static let accentSecondary = Color(red: 0.17, green: 0.52, blue: 0.88)
    static let success = Color(red: 0.35, green: 0.86, blue: 0.52)
    static let warning = Color(red: 0.98, green: 0.65, blue: 0.24)
    static let danger = Color(red: 0.95, green: 0.36, blue: 0.38)
    static let track = Color(red: 0.13, green: 0.16, blue: 0.22)
}

struct AppBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark
                    ? [
                        Color(red: 0.04, green: 0.06, blue: 0.10),
                        Color(red: 0.08, green: 0.11, blue: 0.16),
                        AppPalette.accentSecondary.opacity(0.35)
                    ]
                    : [
                        Color(red: 0.94, green: 0.97, blue: 1.0),
                        Color(red: 0.88, green: 0.93, blue: 0.98),
                        AppPalette.accent.opacity(0.22)
                    ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(AppPalette.accent.opacity(colorScheme == .dark ? 0.18 : 0.12))
                .frame(width: 280, height: 280)
                .blur(radius: 20)
                .offset(x: -130, y: -240)

            RoundedRectangle(cornerRadius: 64, style: .continuous)
                .fill(AppPalette.accentSecondary.opacity(colorScheme == .dark ? 0.18 : 0.12))
                .frame(width: 280, height: 320)
                .rotationEffect(.degrees(28))
                .offset(x: 160, y: 300)
                .blur(radius: 20)
        }
        .ignoresSafeArea()
    }
}

struct SurfaceCard<Content: View>: View {
    private let content: Content
    @Environment(\.colorScheme) private var colorScheme

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.72))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(colorScheme == .dark ? .white.opacity(0.10) : .white.opacity(0.56), lineWidth: 1)
            )
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.28 : 0.10), radius: 18, x: 0, y: 10)
    }
}

extension Double {
    func currencyString(fractionDigits: Int = 2) -> String {
        let code = Locale.autoupdatingCurrent.currency?.identifier ?? "RUB"
        return formatted(.currency(code: code).precision(.fractionLength(fractionDigits)))
    }

    func numberString(maxFractionDigits: Int = 0, minFractionDigits: Int = 0) -> String {
        formatted(.number.precision(.fractionLength(minFractionDigits...maxFractionDigits)))
    }
}

#if canImport(UIKit)
func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
#else
func dismissKeyboard() { }
#endif
