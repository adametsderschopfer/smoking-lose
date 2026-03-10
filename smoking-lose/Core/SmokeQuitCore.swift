//
//  SmokeQuitCore.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import Foundation

public struct SmokeFreeDuration: Equatable, Sendable {
    public let totalDays: Double
    public let days: Int
    public let hours: Int
    public let minutes: Int

    public init(totalDays: Double, days: Int, hours: Int, minutes: Int) {
        self.totalDays = totalDays
        self.days = days
        self.hours = hours
        self.minutes = minutes
    }
}

public struct HealthMilestone: Identifiable, Hashable, Sendable {
    public let key: String
    public let minutesSinceQuit: Int
    public let labelRU: String
    public let labelEN: String
    public let titleRU: String
    public let titleEN: String
    public let descriptionRU: String
    public let descriptionEN: String

    public var id: String { key }

    public init(
        key: String,
        minutesSinceQuit: Int,
        labelRU: String,
        labelEN: String,
        titleRU: String,
        titleEN: String,
        descriptionRU: String,
        descriptionEN: String
    ) {
        self.key = key
        self.minutesSinceQuit = minutesSinceQuit
        self.labelRU = labelRU
        self.labelEN = labelEN
        self.titleRU = titleRU
        self.titleEN = titleEN
        self.descriptionRU = descriptionRU
        self.descriptionEN = descriptionEN
    }
}

public extension HealthMilestone {
    static let timeline: [HealthMilestone] = [
        HealthMilestone(
            key: "heart-rate-drop",
            minutesSinceQuit: 20,
            labelRU: "20 минут",
            labelEN: "20 minutes",
            titleRU: "Пульс и давление начинают снижаться",
            titleEN: "Heart rate and blood pressure begin to drop",
            descriptionRU: "Самые ранние изменения запускаются почти сразу после последней сигареты.",
            descriptionEN: "The earliest recovery changes begin almost immediately after the last cigarette."
        ),
        HealthMilestone(
            key: "toxins-clearing",
            minutesSinceQuit: 60,
            labelRU: "1 час",
            labelEN: "1 hour",
            titleRU: "Организм начинает очищаться от табачных токсинов",
            titleEN: "The body starts clearing tobacco toxins",
            descriptionRU: "Уже в первый час запускается раннее выведение продуктов табачного дыма.",
            descriptionEN: "Within the first hour, the body begins its earliest clearing of tobacco-related toxins."
        ),
        HealthMilestone(
            key: "oxygen-recovery",
            minutesSinceQuit: 8 * 60,
            labelRU: "8 часов",
            labelEN: "8 hours",
            titleRU: "Кислорода становится больше",
            titleEN: "Oxygen levels start recovering",
            descriptionRU: "Уровень угарного газа заметно падает, тканям легче получать кислород.",
            descriptionEN: "Carbon monoxide falls and tissues can receive oxygen more effectively."
        ),
        HealthMilestone(
            key: "carbon-monoxide-normal",
            minutesSinceQuit: 12 * 60,
            labelRU: "12 часов",
            labelEN: "12 hours",
            titleRU: "Угарный газ приходит к норме",
            titleEN: "Carbon monoxide returns to normal",
            descriptionRU: "Кровь переносит кислород эффективнее, нагрузка на сердце снижается.",
            descriptionEN: "Blood carries oxygen more efficiently and the heart works under less strain."
        ),
        HealthMilestone(
            key: "nicotine-clears",
            minutesSinceQuit: 24 * 60,
            labelRU: "1 день",
            labelEN: "1 day",
            titleRU: "Никотин выходит из крови",
            titleEN: "Nicotine clears from the bloodstream",
            descriptionRU: "Организм перестает получать новую дозу никотина и начинает адаптацию без него.",
            descriptionEN: "The body stops receiving new nicotine and begins adapting without it."
        ),
        HealthMilestone(
            key: "heart-attack-risk-begins-to-drop",
            minutesSinceQuit: 24 * 60,
            labelRU: "1 день",
            labelEN: "1 day",
            titleRU: "Риск сердечного приступа начинает снижаться",
            titleEN: "Heart attack risk begins to decrease",
            descriptionRU: "После первых суток без курения сердечно-сосудистая нагрузка уже начинает смещаться в лучшую сторону.",
            descriptionEN: "After the first smoke-free day, cardiovascular strain has already started shifting in a better direction."
        ),
        HealthMilestone(
            key: "taste-smell-return",
            minutesSinceQuit: 48 * 60,
            labelRU: "2 дня",
            labelEN: "2 days",
            titleRU: "Вкус и запах начинают возвращаться",
            titleEN: "Taste and smell begin to return",
            descriptionRU: "Легкие начинают очищаться от слизи и продуктов дыма.",
            descriptionEN: "The lungs begin clearing mucus and smoke-related residue."
        ),
        HealthMilestone(
            key: "breathing-eases",
            minutesSinceQuit: 72 * 60,
            labelRU: "3 дня",
            labelEN: "3 days",
            titleRU: "Дышать может стать легче",
            titleEN: "Breathing may start feeling easier",
            descriptionRU: "Бронхи начинают расслабляться, а энергия постепенно прибавляется.",
            descriptionEN: "The bronchial tubes begin to relax and energy can start improving."
        ),
        HealthMilestone(
            key: "circulation-improves",
            minutesSinceQuit: 14 * 24 * 60,
            labelRU: "2 недели",
            labelEN: "2 weeks",
            titleRU: "Кровообращение улучшается",
            titleEN: "Circulation improves",
            descriptionRU: "Ходить и переносить повседневную активность обычно становится проще.",
            descriptionEN: "Walking and daily physical activity generally become easier."
        ),
        HealthMilestone(
            key: "nicotine-receptors-normalize",
            minutesSinceQuit: 30 * 24 * 60,
            labelRU: "1 месяц",
            labelEN: "1 month",
            titleRU: "Никотиновые рецепторы постепенно возвращаются к норме",
            titleEN: "Nicotine receptors move back toward normal",
            descriptionRU: "Примерно к концу первого месяца мозг уже меньше живет в режиме постоянной никотиновой стимуляции.",
            descriptionEN: "By about the end of the first month, the brain is less locked into constant nicotine stimulation."
        ),
        HealthMilestone(
            key: "cough-begins-to-ease",
            minutesSinceQuit: 30 * 24 * 60,
            labelRU: "1 месяц",
            labelEN: "1 month",
            titleRU: "Кашель и одышка начинают уменьшаться",
            titleEN: "Cough and shortness of breath begin to ease",
            descriptionRU: "Легкие продолжают очищаться, а восстановление становится заметнее.",
            descriptionEN: "The lungs keep clearing and recovery becomes more noticeable."
        ),
        HealthMilestone(
            key: "circulation-window-upper-bound",
            minutesSinceQuit: 12 * 7 * 24 * 60,
            labelRU: "12 недель",
            labelEN: "12 weeks",
            titleRU: "Окно раннего улучшения кровообращения и функции легких завершается",
            titleEN: "The early circulation and lung improvement window reaches its upper bound",
            descriptionRU: "Это верхняя граница официального интервала 2-12 недель, в который обычно улучшаются кровообращение и работа легких.",
            descriptionEN: "This is the upper bound of the official 2 to 12 week window in which circulation and lung function commonly improve."
        ),
        HealthMilestone(
            key: "lung-function-improving",
            minutesSinceQuit: 90 * 24 * 60,
            labelRU: "3 месяца",
            labelEN: "3 months",
            titleRU: "Функция легких продолжает расти",
            titleEN: "Lung function keeps improving",
            descriptionRU: "Дыхание, выносливость и переносимость нагрузки часто улучшаются.",
            descriptionEN: "Breathing, stamina, and tolerance to activity often improve further."
        ),
        HealthMilestone(
            key: "lungs-clear-better",
            minutesSinceQuit: 180 * 24 * 60,
            labelRU: "6 месяцев",
            labelEN: "6 months",
            titleRU: "Легким проще очищаться",
            titleEN: "The lungs clear more effectively",
            descriptionRU: "Слизь выводится лучше, а кашель и ощущение нехватки воздуха часто снижаются.",
            descriptionEN: "Mucus clearance improves and cough or breathlessness often decrease."
        ),
        HealthMilestone(
            key: "cough-sob-window-upper-bound",
            minutesSinceQuit: 9 * 30 * 24 * 60,
            labelRU: "9 месяцев",
            labelEN: "9 months",
            titleRU: "Кашель, свист и одышка заметно уменьшаются",
            titleEN: "Cough, wheeze, and shortness of breath decrease further",
            descriptionRU: "Это верхняя граница официального окна 3-9 месяцев, когда дыхательные симптомы часто становятся слабее.",
            descriptionEN: "This is the upper bound of the official 3 to 9 month window in which breathing symptoms often ease further."
        ),
        HealthMilestone(
            key: "chd-risk-half",
            minutesSinceQuit: 365 * 24 * 60,
            labelRU: "1 год",
            labelEN: "1 year",
            titleRU: "Риск ИБС падает примерно вдвое",
            titleEN: "Coronary heart disease risk drops by about half",
            descriptionRU: "Сердечно-сосудистая система уже работает без постоянной табачной нагрузки.",
            descriptionEN: "The cardiovascular system is no longer under constant tobacco strain."
        ),
        HealthMilestone(
            key: "heart-attack-risk-drops-sharply",
            minutesSinceQuit: 2 * 365 * 24 * 60,
            labelRU: "2 года",
            labelEN: "2 years",
            titleRU: "Риск инфаркта заметно снижается",
            titleEN: "Heart attack risk drops sharply",
            descriptionRU: "Польза для сердца становится значительнее с каждым следующим годом.",
            descriptionEN: "The benefit for the heart becomes more substantial with each passing year."
        ),
        HealthMilestone(
            key: "stroke-risk-declines",
            minutesSinceQuit: 5 * 365 * 24 * 60,
            labelRU: "5 лет",
            labelEN: "5 years",
            titleRU: "Сосудистые риски продолжают снижаться",
            titleEN: "Vascular risks continue to decline",
            descriptionRU: "Риск инсульта уменьшается, а лишний коронарный риск уже заметно ниже.",
            descriptionEN: "Stroke risk decreases and extra coronary risk is already much lower."
        ),
        HealthMilestone(
            key: "coronary-risk-half-window",
            minutesSinceQuit: 6 * 365 * 24 * 60,
            labelRU: "6 лет",
            labelEN: "6 years",
            titleRU: "Добавочный риск ишемической болезни сердца снижается примерно вдвое",
            titleEN: "Added coronary heart disease risk drops by about half",
            descriptionRU: "Эта точка отражает верхнюю границу официального окна 3-6 лет, в котором добавочный риск ИБС заметно уменьшается.",
            descriptionEN: "This point reflects the upper bound of the official 3 to 6 year window in which added coronary heart disease risk falls substantially."
        ),
        HealthMilestone(
            key: "lung-cancer-risk-half",
            minutesSinceQuit: 10 * 365 * 24 * 60,
            labelRU: "10 лет",
            labelEN: "10 years",
            titleRU: "Риск рака легких снижается примерно вдвое",
            titleEN: "Lung cancer risk drops by about half",
            descriptionRU: "Также снижается риск ряда других связанных с курением видов рака.",
            descriptionEN: "The risk of several other smoking-related cancers also decreases."
        ),
        HealthMilestone(
            key: "other-cancer-risks-drop",
            minutesSinceQuit: 10 * 365 * 24 * 60,
            labelRU: "10 лет",
            labelEN: "10 years",
            titleRU: "Снижаются риски ряда других связанных с курением видов рака",
            titleEN: "Several other smoking-related cancer risks continue to fall",
            descriptionRU: "К этому сроку официальные источники также отмечают снижение риска рака гортани, пищевода, мочевого пузыря, почки и поджелудочной железы.",
            descriptionEN: "By this point, official sources also note lower risks for laryngeal, esophageal, bladder, kidney, and pancreatic cancers."
        ),
        HealthMilestone(
            key: "chd-near-nonsmoker",
            minutesSinceQuit: 15 * 365 * 24 * 60,
            labelRU: "15 лет",
            labelEN: "15 years",
            titleRU: "Риск ИБС приближается к уровню некурящего",
            titleEN: "Coronary heart disease risk nears that of a non-smoker",
            descriptionRU: "Долгий отказ от курения меняет сердечно-сосудистый прогноз очень заметно.",
            descriptionEN: "Long-term cessation makes a major difference to cardiovascular outlook."
        ),
        HealthMilestone(
            key: "some-cancer-risks-near-nonsmoker",
            minutesSinceQuit: 20 * 365 * 24 * 60,
            labelRU: "20 лет",
            labelEN: "20 years",
            titleRU: "Часть онкорисков приближается к уровню некурящего",
            titleEN: "Some cancer risks approach those of a non-smoker",
            descriptionRU: "Для ряда опухолей долгосрочный риск становится близок к риску людей, которые не курят.",
            descriptionEN: "For some cancers, long-term risk becomes close to the risk seen in non-smokers."
        ),
    ]
}

public struct SmokeQuitCalculator: Sendable {
    public let milestones: [HealthMilestone]
    public let calendar: Calendar

    public init(
        milestones: [HealthMilestone] = HealthMilestone.timeline,
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) {
        self.milestones = milestones
        self.calendar = calendar
    }

    public func calculateDaysSinceQuit(from quitDate: Date, now: Date = .now) -> SmokeFreeDuration {
        let clampedNow = max(now.timeIntervalSince1970, quitDate.timeIntervalSince1970)
        let effectiveNow = Date(timeIntervalSince1970: clampedNow)
        let interval = max(effectiveNow.timeIntervalSince(quitDate), 0)
        let components = calendar.dateComponents([.day, .hour, .minute], from: quitDate, to: effectiveNow)

        return SmokeFreeDuration(
            totalDays: interval / 86_400,
            days: max(components.day ?? 0, 0),
            hours: max(components.hour ?? 0, 0),
            minutes: max(components.minute ?? 0, 0)
        )
    }

    public func dailyCost(pricePerPack: Double, cigarettesPerPack: Int, cigarettesPerDay: Int) -> Double {
        guard pricePerPack > 0, cigarettesPerPack > 0, cigarettesPerDay > 0 else {
            return 0
        }

        return (pricePerPack / Double(cigarettesPerPack)) * Double(cigarettesPerDay)
    }

    public func calculateSavedMoney(
        pricePerPack: Double,
        cigarettesPerPack: Int,
        cigarettesPerDay: Int,
        quitDate: Date,
        now: Date = .now
    ) -> Double {
        let elapsed = calculateDaysSinceQuit(from: quitDate, now: now)
        return dailyCost(
            pricePerPack: pricePerPack,
            cigarettesPerPack: cigarettesPerPack,
            cigarettesPerDay: cigarettesPerDay
        ) * elapsed.totalDays
    }

    public func calculateFutureValue(saved: Double, annualRatePercent: Double, years: Double = 10) -> Double {
        let rate = annualRatePercent / 100
        return saved * pow(1 + rate, years)
    }

    public func lungDarkness(smokingYears: Int) -> Double {
        min(Double(smokingYears) / 20.0, 1.0)
    }

    public func shouldShowRedSpeckles(smokingYears: Int) -> Bool {
        smokingYears >= 10
    }

    public func currentMilestone(quitDate: Date, now: Date = .now) -> HealthMilestone? {
        let elapsedMinutes = Int(floor(calculateDaysSinceQuit(from: quitDate, now: now).totalDays * 1_440))
        return milestones.last(where: { $0.minutesSinceQuit <= elapsedMinutes })
    }

    public func nextMilestone(quitDate: Date, now: Date = .now) -> HealthMilestone? {
        let elapsedMinutes = Int(floor(calculateDaysSinceQuit(from: quitDate, now: now).totalDays * 1_440))
        return milestones.first(where: { $0.minutesSinceQuit > elapsedMinutes })
    }
}
