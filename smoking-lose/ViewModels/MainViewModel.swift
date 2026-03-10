//
//  MainViewModel.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import Combine
import Foundation

enum DashboardSection: String, CaseIterable, Identifiable {
    case progress
    case finances

    var id: String { rawValue }

    var title: String {
        switch self {
        case .progress:
            return L10n.text("Здоровье", "Health")
        case .finances:
            return L10n.text("Экономия", "Savings")
        }
    }
}

struct CheckInPrompt: Identifiable {
    let id = UUID()
    let reason: CheckInReason

    enum CheckInReason {
        case cadence
        case inactivity

        var subtitle: String {
            switch self {
            case .cadence:
                return L10n.text(
                    "Небольшая проверка раз в несколько дней помогает не терять фокус.",
                    "A gentle check-in every few days helps you stay focused."
                )
            case .inactivity:
                return L10n.text(
                    "Вы давно не открывали приложение, поэтому мы просто хотим поддержать вас.",
                    "You have not opened the app for a while, so this is just a gentle support check."
                )
            }
        }
    }
}

@MainActor
final class MainViewModel: ObservableObject {
    @Published var selectedSection: DashboardSection = .progress
    @Published var isProfileEditorPresented = false
    @Published var activeCheckInPrompt: CheckInPrompt?
    @Published var isResetConfirmationPresented = false

    private let calculator: SmokeQuitCalculator
    private let defaults: UserDefaults
    private let notificationManager = RecoveryNotificationManager()
    private let lastCheckInKey = "smokingLose.lastCheckInPromptDate"
    private let lastAppOpenKey = "smokingLose.lastAppOpenDate"

    init(calculator: SmokeQuitCalculator? = nil, defaults: UserDefaults = .standard) {
        self.calculator = calculator ?? SmokeQuitCalculator()
        self.defaults = defaults
    }

    func calculateDaysSinceQuit(profile: UserProfile, now: Date = .now) -> SmokeFreeDuration {
        calculator.calculateDaysSinceQuit(from: profile.quitDate, now: now)
    }

    func calculateSavedMoney(profile: UserProfile, now: Date = .now) -> Double {
        calculator.calculateSavedMoney(
            pricePerPack: profile.pricePerPack,
            cigarettesPerPack: profile.cigarettesPerPack,
            cigarettesPerDay: profile.cigarettesPerDay,
            quitDate: profile.quitDate,
            now: now
        )
    }

    func calculateFutureValue(profile: UserProfile, now: Date = .now) -> Double {
        let saved = calculateSavedMoney(profile: profile, now: now)
        return calculator.calculateFutureValue(
            saved: saved,
            annualRatePercent: profile.investmentRate,
            years: profile.investmentYears
        )
    }

    func currentMilestone(profile: UserProfile, now: Date = .now) -> HealthMilestone? {
        calculator.currentMilestone(quitDate: profile.quitDate, now: now)
    }

    func nextMilestone(profile: UserProfile, now: Date = .now) -> HealthMilestone? {
        calculator.nextMilestone(quitDate: profile.quitDate, now: now)
    }

    func lungDarkness(profile: UserProfile) -> Double {
        calculator.lungDarkness(smokingYears: profile.smokingYears)
    }

    func shouldShowRedSpeckles(profile: UserProfile) -> Bool {
        calculator.shouldShowRedSpeckles(smokingYears: profile.smokingYears)
    }

    func statusLine(profile: UserProfile, now: Date = .now) -> String {
        currentMilestone(profile: profile, now: now)?.title ?? L10n.text(
            "Организм уже начал восстановление.",
            "Your body has already started recovering."
        )
    }

    func milestoneCountdown(profile: UserProfile, now: Date = .now) -> String {
        calculator.milestoneDistanceText(quitDate: profile.quitDate, now: now)
    }

    func encouragement(profile: UserProfile, now: Date = .now) -> String {
        let days = calculateDaysSinceQuit(profile: profile, now: now).days

        switch days {
        case 0..<3:
            return L10n.text(
                "Самые острые дни уже идут. Берегите ритм и не требуйте от себя идеальности.",
                "The sharpest days are happening now. Protect your rhythm and do not expect perfection."
            )
        case 3..<30:
            return L10n.text(
                "Уже видно движение вперед. Каждые сутки без никотина работают на вас.",
                "Progress is already visible. Every smoke-free day keeps working in your favor."
            )
        case 30..<365:
            return L10n.text(
                "Вы строите новую норму. Это уже не случайный успех, а устойчивая привычка.",
                "You are building a new normal. This is no longer luck, it is a sustained habit."
            )
        default:
            return L10n.text(
                "Длинная дистанция меняет риски и самочувствие. Продолжайте держать курс.",
                "Long-term consistency changes both risks and wellbeing. Keep the course."
            )
        }
    }

    func dailyMotivations(profile: UserProfile, now: Date = .now) -> [String] {
        let messages = [
            L10n.text("Сегодня вы сохраняете дыхание, деньги и контроль в своих руках.", "Today you protect your breathing, your money, and your sense of control."),
            L10n.text("Даже один спокойный день без никотина уже работает на вас.", "Even one calm day without nicotine is already working in your favor."),
            L10n.text("Каждая несделанная затяжка усиливает новый ритм жизни.", "Every cigarette not smoked strengthens your new rhythm."),
            L10n.text("Тяга приходит волнами, а ваш результат остается с вами.", "Cravings come in waves, but your progress stays with you."),
            L10n.text("Вы уже не на старте. У вас есть реальная серия дней без курения.", "You are no longer at the start. You already have a real smoke-free streak."),
            L10n.text("Организм не просит идеальности, ему нужна последовательность.", "Your body does not need perfection, it needs consistency."),
            L10n.text("Дистанция строится из маленьких спокойных решений в течение дня.", "Long distance is built from small calm decisions throughout the day."),
            L10n.text("Каждый день без курения делает следующий день немного проще.", "Every smoke-free day makes the next day a bit easier."),
            L10n.text("То, что раньше уходило в дым, теперь остается вам.", "What used to go up in smoke now stays with you."),
            L10n.text("Вы уже двигаетесь к целям, а не просто избегаете сигарет.", "You are moving toward goals now, not just avoiding cigarettes.")
        ]

        let elapsedDays = calculateDaysSinceQuit(profile: profile, now: now).days
        let ordinal = Calendar.autoupdatingCurrent.ordinality(of: .day, in: .year, for: now) ?? 0
        let offset = (ordinal + elapsedDays) % messages.count
        let rotatingMessages = (0..<3).map { messages[(offset + $0) % messages.count] }

        if let resilienceMessage = relapseResilienceMessage(days: elapsedDays) {
            return [resilienceMessage] + Array(rotatingMessages.prefix(2))
        }

        return rotatingMessages
    }

    private func relapseResilienceMessage(days: Int) -> String? {
        switch days {
        case ..<1:
            return nil
        case 1..<7:
            return L10n.text(
                "Вы уже прошли дальше, чем примерно 48% попыток бросить: в проспективном исследовании почти половина попыток заканчивалась меньше чем за сутки.",
                "You have already gone farther than about 48% of quit attempts: in a prospective study, nearly half ended in less than one day."
            )
        case 7..<30:
            return L10n.text(
                "Вы уже пережили первую неделю. В наблюдательном исследовании около 31.3% срывов происходили уже к 7-му дню.",
                "You have already made it past the first week. In an observational study, about 31.3% of relapses happened by day 7."
            )
        case 30..<180:
            return L10n.text(
                "Вы уже далеко за пределами самого частого раннего окна срыва: среди тех, кто дошел хотя бы до первых суток без сигарет, 73.9% позже все же срывались, а медиана первой сигареты приходилась на 7-й день.",
                "You are already well past the most common early relapse window: among people who reached at least one smoke-free day, 73.9% later lapsed, and the median time to first cigarette was day 7."
            )
        case 180..<365:
            return L10n.text(
                "Вы уже прошли рубеж, на котором в одном американском опросе накапливалось около 79.3% всех срывов к 6-му месяцу. Это действительно сильная дистанция.",
                "You have already passed the point where one U.S. survey saw about 79.3% of all relapses accumulate by 6 months. That is a strong distance."
            )
        default:
            return L10n.text(
                "Вы держитесь дольше, чем многие длинные попытки: в одном годовом наблюдении около 32.3% тех, кто продержался 6 месяцев, все равно срывались в следующие полгода.",
                "You are holding on longer than many long attempts: in one year-long follow-up, about 32.3% of people who вmade it to 6 months still relapsed in the next 6 months."
            )
        }
    }

    func handleAppBecameActive() {
        let now = Date()
        let lastPrompt = defaults.object(forKey: lastCheckInKey) as? Date
        let lastOpen = defaults.object(forKey: lastAppOpenKey) as? Date

        let shouldPromptByCadence = lastPrompt.map { now.timeIntervalSince($0) >= 3 * 24 * 60 * 60 } ?? false
        let shouldPromptByInactivity = lastOpen.map { now.timeIntervalSince($0) >= 48 * 60 * 60 } ?? false

        if activeCheckInPrompt == nil {
            if shouldPromptByInactivity {
                activeCheckInPrompt = CheckInPrompt(reason: .inactivity)
            } else if shouldPromptByCadence {
                activeCheckInPrompt = CheckInPrompt(reason: .cadence)
            }
        }

        defaults.set(now, forKey: lastAppOpenKey)
    }

    func completeCheckIn() {
        defaults.set(Date(), forKey: lastCheckInKey)
        activeCheckInPrompt = nil
    }

    func reportRelapse() {
        activeCheckInPrompt = nil
        isResetConfirmationPresented = true
    }

    func keepStatisticsAfterRelapse() {
        defaults.set(Date(), forKey: lastCheckInKey)
        isResetConfirmationPresented = false
    }

    func resetStatistics(for profile: UserProfile) {
        profile.quitDate = .now
        notificationManager.refreshNotifications(for: profile)
        defaults.set(Date(), forKey: lastCheckInKey)
        defaults.set(Date(), forKey: lastAppOpenKey)
        isResetConfirmationPresented = false
    }
}
