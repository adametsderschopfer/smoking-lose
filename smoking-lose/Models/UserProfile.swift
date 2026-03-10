//
//  UserProfile.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import Foundation
import SwiftData

enum SmokingProductType: String, CaseIterable, Identifiable, Codable {
    case cigarettes
    case sticks

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cigarettes:
            return L10n.text("Сигареты", "Cigarettes")
        case .sticks:
            return L10n.text("Стики", "Heat sticks")
        }
    }

    var accessoryTitle: String { title }
}

@Model
final class UserProfile {
    var quitDate: Date
    var smokingYears: Int
    var cigarettesPerDay: Int
    var pricePerPack: Double
    var cigarettesPerPack: Int
    var investmentRate: Double
    var investmentYears: Double
    var productTypeRaw: String
    var createdAt: Date

    init(
        quitDate: Date,
        smokingYears: Int,
        cigarettesPerDay: Int,
        pricePerPack: Double,
        cigarettesPerPack: Int,
        investmentRate: Double,
        investmentYears: Double,
        productType: SmokingProductType,
        createdAt: Date = .now
    ) {
        self.quitDate = quitDate
        self.smokingYears = smokingYears
        self.cigarettesPerDay = cigarettesPerDay
        self.pricePerPack = pricePerPack
        self.cigarettesPerPack = cigarettesPerPack
        self.investmentRate = investmentRate
        self.investmentYears = investmentYears
        self.productTypeRaw = productType.rawValue
        self.createdAt = createdAt
    }

    var productType: SmokingProductType {
        get { SmokingProductType(rawValue: productTypeRaw) ?? .cigarettes }
        set { productTypeRaw = newValue.rawValue }
    }
}

struct ProfileDraft {
    var quitDate: Date
    var smokingYearsText: String
    var cigarettesPerDayText: String
    var pricePerPackText: String
    var cigarettesPerPackText: String
    var investmentRateText: String
    var investmentYearsText: String
    var productType: SmokingProductType

    init(profile: UserProfile? = nil) {
        self.quitDate = profile?.quitDate ?? .now
        self.smokingYearsText = profile.map { String($0.smokingYears) } ?? ""
        self.cigarettesPerDayText = profile.map { String($0.cigarettesPerDay) } ?? ""
        self.pricePerPackText = profile.map { Self.format($0.pricePerPack) } ?? ""
        self.cigarettesPerPackText = profile.map { String($0.cigarettesPerPack) } ?? ""
        self.investmentRateText = profile.map { Self.format($0.investmentRate) } ?? "13"
        self.investmentYearsText = profile.map { Self.format($0.investmentYears) } ?? "10"
        self.productType = profile?.productType ?? .cigarettes
    }

    var validationMessage: String? {
        if quitDate > .now {
            return L10n.text(
                "Дата отказа не может быть в будущем.",
                "The quit date cannot be in the future."
            )
        }

        if cigarettesPerDay == nil {
            return L10n.text(
                "Укажите количество в день.",
                "Enter daily consumption."
            )
        }

        if cigarettesPerDay ?? 0 <= 0 {
            return L10n.text(
                "Укажите количество в день больше нуля.",
                "Daily consumption must be greater than zero."
            )
        }

        if cigarettesPerDay ?? 0 > 150 {
            return L10n.text(
                "Количество в день не может быть больше 150.",
                "Daily consumption cannot exceed 150."
            )
        }

        if pricePerPack == nil {
            return L10n.text(
                "Укажите цену пачки.",
                "Enter the pack price."
            )
        }

        if pricePerPack ?? 0 <= 0 {
            return L10n.text(
                "Цена пачки должна быть больше нуля.",
                "Pack price must be greater than zero."
            )
        }

        if cigarettesPerPack == nil {
            return L10n.text(
                "Укажите количество в пачке.",
                "Enter items per pack."
            )
        }

        if cigarettesPerPack ?? 0 <= 0 {
            return L10n.text(
                "Количество в пачке должно быть больше нуля.",
                "Items per pack must be greater than zero."
            )
        }

        if smokingYears == nil {
            return L10n.text(
                "Укажите стаж курения.",
                "Enter smoking history."
            )
        }

        if smokingYears ?? 0 <= 0 {
            return L10n.text(
                "Стаж курения должен быть больше нуля.",
                "Smoking history must be greater than zero."
            )
        }

        if smokingYears ?? 0 > 85 {
            return L10n.text(
                "Стаж курения не может быть больше 85 лет.",
                "Smoking history cannot exceed 85 years."
            )
        }

        if investmentRate == nil {
            return L10n.text(
                "Укажите ставку инвестирования.",
                "Enter the investment rate."
            )
        }

        if investmentRate ?? 0 <= 0 {
            return L10n.text(
                "Ставка инвестирования должна быть больше нуля.",
                "Investment rate must be greater than zero."
            )
        }

        if investmentYears == nil {
            return L10n.text(
                "Укажите горизонт прогноза.",
                "Enter the projection years."
            )
        }

        if investmentYears ?? 0 <= 0 {
            return L10n.text(
                "Горизонт прогноза должен быть больше нуля.",
                "Projection years must be greater than zero."
            )
        }

        return nil
    }

    var isValid: Bool { validationMessage == nil }

    var smokingYears: Int? { Self.parseInt(smokingYearsText) }
    var cigarettesPerDay: Int? { Self.parseInt(cigarettesPerDayText) }
    var cigarettesPerPack: Int? { Self.parseInt(cigarettesPerPackText) }
    var pricePerPack: Double? { Self.parseDouble(pricePerPackText) }
    var investmentRate: Double? { Self.parseDouble(investmentRateText) }
    var investmentYears: Double? { Self.parseDouble(investmentYearsText) }

    func makeProfile() -> UserProfile {
        UserProfile(
            quitDate: quitDate,
            smokingYears: smokingYears ?? 1,
            cigarettesPerDay: cigarettesPerDay ?? 1,
            pricePerPack: pricePerPack ?? 1,
            cigarettesPerPack: cigarettesPerPack ?? 1,
            investmentRate: investmentRate ?? 13,
            investmentYears: investmentYears ?? 10,
            productType: productType
        )
    }

    func apply(to profile: UserProfile) {
        profile.quitDate = quitDate
        profile.smokingYears = smokingYears ?? profile.smokingYears
        profile.cigarettesPerDay = cigarettesPerDay ?? profile.cigarettesPerDay
        profile.pricePerPack = pricePerPack ?? profile.pricePerPack
        profile.cigarettesPerPack = cigarettesPerPack ?? profile.cigarettesPerPack
        profile.investmentRate = investmentRate ?? profile.investmentRate
        profile.investmentYears = investmentYears ?? profile.investmentYears
        profile.productType = productType
    }

    private static func parseInt(_ value: String) -> Int? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Int(trimmed)
    }

    private static func parseDouble(_ value: String) -> Double? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        return Double(trimmed.replacingOccurrences(of: ",", with: "."))
    }

    private static func format(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }

        return value.formatted(.number.precision(.fractionLength(0...2)))
    }
}
