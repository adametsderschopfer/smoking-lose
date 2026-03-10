//
//  MainDashboardView.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import Combine
import SwiftUI

struct MainDashboardView: View {
    let profile: UserProfile
    @ObservedObject var viewModel: MainViewModel

    @State private var selectedMilestone: HealthMilestone?
    @State private var currentTime = Date()

    private let liveTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        heroSection
                        segmentedSection

                        switch viewModel.selectedSection {
                        case .progress:
                            progressSection
                        case .finances:
                            financeSection
                        }

                        disclaimerSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle(L10n.text("Бросаю курить", "Quit Smoking"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isProfileEditorPresented = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isProfileEditorPresented) {
            ProfileFormView(mode: .edit, profile: profile)
        }
        .sheet(item: $viewModel.activeCheckInPrompt) { prompt in
            CheckInSheet(
                prompt: prompt,
                onRelapse: viewModel.reportRelapse,
                onStayStrong: viewModel.completeCheckIn
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedMilestone) { milestone in
            MilestoneDetailSheet(milestone: milestone)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .alert(
            L10n.text("Ничего страшного. Попробуйте снова. У вас получится.", "That is okay. Try again. You can do this."),
            isPresented: $viewModel.isResetConfirmationPresented
        ) {
            Button(L10n.text("Сбросить статистику", "Reset statistics"), role: .destructive) {
                viewModel.resetStatistics(for: profile)
            }
            Button(L10n.text("Оставить как есть", "Keep current stats"), role: .cancel) {
                viewModel.keepStatisticsAfterRelapse()
            }
        } message: {
            Text(L10n.text("Сбросить дату отказа?", "Reset the quit date?"))
        }
        .onReceive(liveTimer) { now in
            currentTime = now
        }
    }

    private var heroSection: some View {
        let elapsed = viewModel.calculateDaysSinceQuit(profile: profile, now: currentTime)
        let motivations = viewModel.dailyMotivations(profile: profile, now: currentTime)

        return VStack(alignment: .leading, spacing: 18) {
            SurfaceCard {
                VStack(alignment: .leading, spacing: 18) {
                    Text(L10n.text("Сегодняшний статус", "Today's status"))
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text(L10n.smokeFreeDuration(days: elapsed.days, hours: elapsed.hours, minutes: elapsed.minutes))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.primary)

                    Text(viewModel.encouragement(profile: profile, now: currentTime))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(motivations, id: \.self) { motivation in
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(AppPalette.success)
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 6)

                                Text(motivation)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    LungsRecoveryCard(
                        smokingYears: profile.smokingYears,
                        recoveryDays: elapsed.totalDays
                    )
                    .frame(maxWidth: .infinity)
                }
            }

            SurfaceCard {
                VStack(alignment: .leading, spacing: 18) {
                    statusRow(
                        title: L10n.text("Текущая стадия", "Current stage"),
                        value: viewModel.statusLine(profile: profile, now: currentTime),
                        color: AppPalette.success
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)

                    Divider()
                        .overlay(.secondary.opacity(0.16))

                    statusRow(
                        title: L10n.text("Ближайший рубеж и цель", "Next milestone and goal"),
                        value: viewModel.milestoneCountdown(profile: profile, now: currentTime),
                        color: AppPalette.warning
                    )
                }
            }
        }
    }

    private var segmentedSection: some View {
        Picker("", selection: $viewModel.selectedSection) {
            ForEach(DashboardSection.allCases) { section in
                Text(section.title).tag(section)
            }
        }
        .pickerStyle(.segmented)
    }

    private var progressSection: some View {
        let elapsedDays = viewModel.calculateDaysSinceQuit(profile: profile, now: currentTime).totalDays

        return SurfaceCard {
            VStack(alignment: .leading, spacing: 18) {
                Text(L10n.text("Шаги восстановления", "Recovery steps"))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(AppPalette.success)

                Text(L10n.text("Нажмите на этап, чтобы открыть подробности.", "Tap a stage to open more details."))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(HealthMilestone.timeline) { milestone in
                    Button {
                        selectedMilestone = milestone
                    } label: {
                        MilestoneRow(
                            milestone: milestone,
                            elapsedDays: elapsedDays
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var financeSection: some View {
        let elapsed = viewModel.calculateDaysSinceQuit(profile: profile, now: currentTime)
        let savedMoney = viewModel.calculateSavedMoney(profile: profile, now: currentTime)
        let futureValue = viewModel.calculateFutureValue(profile: profile, now: currentTime)
        let dailyCost = SmokeQuitCalculator().dailyCost(
            pricePerPack: profile.pricePerPack,
            cigarettesPerPack: profile.cigarettesPerPack,
            cigarettesPerDay: profile.cigarettesPerDay
        )

        return VStack(spacing: 18) {
            SurfaceCard {
                VStack(alignment: .leading, spacing: 14) {
                    Text(L10n.text("Траты и экономия", "Spending and savings"))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)

                    Text(L10n.smokeFreeDuration(days: elapsed.days, hours: elapsed.hours, minutes: elapsed.minutes))
                        .font(.headline)
                        .foregroundStyle(.primary)

                    amountBlock(
                        title: L10n.text("Сэкономлено", "Saved"),
                        amount: savedMoney,
                        accent: AppPalette.success
                    )

                    Divider()
                        .overlay(.secondary.opacity(0.14))

                    amountBlock(
                        title: L10n.text("Раньше уходило в день", "Used to spend per day"),
                        amount: dailyCost,
                        accent: AppPalette.warning
                    )
                }
            }

            SurfaceCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text(L10n.text("Прогноз", "Projection"))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)

                    Text(
                        L10n.text(
                            "Если инвестировать текущую сэкономленную сумму под \(profile.investmentRate.numberString(maxFractionDigits: 1, minFractionDigits: 1))% годовых, через \(Int(profile.investmentYears)) лет получится:",
                            "If you invest the currently saved amount at \(profile.investmentRate.numberString(maxFractionDigits: 1, minFractionDigits: 1))% annually, in \(Int(profile.investmentYears)) years it becomes:"
                        )
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                    amountBlock(
                        title: L10n.text("Будущая сумма", "Future value"),
                        amount: futureValue,
                        accent: AppPalette.accent
                    )

                    VStack(alignment: .leading, spacing: 14) {
                        settingRow(
                            title: L10n.text("Ставка", "Rate"),
                            trailing: "\(profile.investmentRate.numberString(maxFractionDigits: 1, minFractionDigits: 1))%"
                        )

                        Stepper(value: investmentRateBinding, in: 0...25, step: 0.5) {
                            EmptyView()
                        }
                        .labelsHidden()
                        .tint(AppPalette.accent)

                        settingRow(
                            title: L10n.text("Горизонт", "Years"),
                            trailing: L10n.count(Int(profile.investmentYears), ruOne: "год", ruFew: "года", ruMany: "лет", enOne: "year", enMany: "years")
                        )

                        Slider(value: investmentYearsBinding, in: 1...30, step: 1)
                            .tint(AppPalette.success)
                    }
                }
            }
        }
    }

    private var disclaimerSection: some View {
        SurfaceCard {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundStyle(AppPalette.warning)

                Text(
                    L10n.text(
                        "Все медицинские данные носят информационный характер и не являются медицинской консультацией. При симптомах и вопросах лучше обсудить состояние с врачом.",
                        "All health data is informational and not medical advice. If you have symptoms or concerns, speak with a doctor."
                    )
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func statusRow(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                    .padding(.top, 6)

                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func amountBlock(title: String, amount: Double, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(amount.currencyString(fractionDigits: 2))
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(accent)
                .monospacedDigit()
        }
    }

    private func settingRow(title: String, trailing: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
            Text(trailing)
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.primary)
        }
    }

    private var investmentRateBinding: Binding<Double> {
        Binding(
            get: { profile.investmentRate },
            set: { profile.investmentRate = $0 }
        )
    }

    private var investmentYearsBinding: Binding<Double> {
        Binding(
            get: { profile.investmentYears },
            set: { profile.investmentYears = $0 }
        )
    }
}

private struct CheckInSheet: View {
    let prompt: CheckInPrompt
    let onRelapse: () -> Void
    let onStayStrong: () -> Void

    var body: some View {
        ZStack {
            AppBackground()

            VStack(alignment: .leading, spacing: 18) {
                Text(L10n.text("Вы ведь не сдались?", "You have not given up, right?"))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(prompt.reason.subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    Button(action: onRelapse) {
                        Text(L10n.text("Да, я закурил", "Yes, I smoked"))
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppPalette.warning.opacity(0.18), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)

                    Button(action: onStayStrong) {
                        Text(L10n.text("Нет, держусь", "No, I am holding on"))
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [AppPalette.accent, AppPalette.accentSecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                            )
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(24)
        }
    }
}

private struct MilestoneDetailSheet: View {
    let milestone: HealthMilestone

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    Text(milestone.timelineLabel)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppPalette.success.opacity(0.16), in: Capsule())
                        .foregroundStyle(AppPalette.success)

                    Text(milestone.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)

                    Text(milestone.articleSummary)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(L10n.text("Что происходит", "What is happening"))
                            .font(.headline)
                            .foregroundStyle(AppPalette.success)

                        ForEach(milestone.articlePoints, id: \.self) { point in
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(AppPalette.accent)
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 7)

                                Text(point)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    SurfaceCard {
                        Text(milestone.sourceCaption)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(24)
            }
        }
    }
}

private struct LungsRecoveryCard: View {
    let smokingYears: Int
    let recoveryDays: Double

    private var visual: LungVisualState {
        LungVisualState(smokingYears: smokingYears, recoveryDays: recoveryDays)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            visual.glowColor.opacity(0.20),
                            visual.glowColor.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(visual.glowColor.opacity(0.16))
                .frame(width: 220, height: 220)
                .blur(radius: 26)

            VStack(spacing: 16) {
                ZStack {
                    Capsule()
                        .fill(AppPalette.accent.opacity(0.32))
                        .frame(width: 18, height: 86)
                        .offset(y: -54)

                    HStack(spacing: 16) {
                        lungView(mirrored: false, cracks: leftCrackSegments)
                        lungView(mirrored: true, cracks: rightCrackSegments)
                    }
                }

                VStack(spacing: 8) {
                    Text(L10n.text("Степень повреждения", "Damage severity"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)

                    Text(visual.label)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(visual.fill)

                    Text(visual.caption)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(24)
        }
        .frame(height: 430)
    }

    private func lungView(mirrored: Bool, cracks: [CrackSegment]) -> some View {
        LungShape(mirrored: mirrored)
            .fill(visual.fill.gradient)
            .overlay(
                LungShape(mirrored: mirrored)
                    .stroke(visual.stroke, lineWidth: 2)
            )
            .overlay {
                if visual.hasCracks {
                    ZStack {
                        ForEach(cracks, id: \.self) { segment in
                            Path { path in
                                path.move(to: segment.start)
                                path.addLine(to: segment.end)
                            }
                            .stroke(
                                AppPalette.danger.opacity(0.78),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                        }
                    }
                    .clipShape(LungShape(mirrored: mirrored))
                }
            }
            .frame(width: 108, height: 190)
    }

    private var leftCrackSegments: [CrackSegment] {
        [
            CrackSegment(start: CGPoint(x: 60, y: 40), end: CGPoint(x: 48, y: 80)),
            CrackSegment(start: CGPoint(x: 48, y: 80), end: CGPoint(x: 34, y: 110)),
            CrackSegment(start: CGPoint(x: 50, y: 96), end: CGPoint(x: 66, y: 122)),
            CrackSegment(start: CGPoint(x: 40, y: 124), end: CGPoint(x: 54, y: 156)),
        ]
    }

    private var rightCrackSegments: [CrackSegment] {
        [
            CrackSegment(start: CGPoint(x: 48, y: 42), end: CGPoint(x: 60, y: 82)),
            CrackSegment(start: CGPoint(x: 60, y: 82), end: CGPoint(x: 72, y: 110)),
            CrackSegment(start: CGPoint(x: 58, y: 98), end: CGPoint(x: 42, y: 126)),
            CrackSegment(start: CGPoint(x: 66, y: 124), end: CGPoint(x: 54, y: 156)),
        ]
    }
}

private struct LungShape: Shape {
    let mirrored: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let direction: CGFloat = mirrored ? -1 : 1
        let xStart = mirrored ? width : 0

        path.move(to: CGPoint(x: xStart, y: 0))
        path.addCurve(
            to: CGPoint(x: xStart + direction * width * 0.88, y: height * 0.34),
            control1: CGPoint(x: xStart + direction * width * 0.48, y: height * 0.04),
            control2: CGPoint(x: xStart + direction * width * 0.98, y: height * 0.12)
        )
        path.addCurve(
            to: CGPoint(x: xStart + direction * width * 0.48, y: height),
            control1: CGPoint(x: xStart + direction * width * 0.90, y: height * 0.74),
            control2: CGPoint(x: xStart + direction * width * 0.64, y: height * 0.98)
        )
        path.addCurve(
            to: CGPoint(x: xStart + direction * width * 0.10, y: height * 0.64),
            control1: CGPoint(x: xStart + direction * width * 0.30, y: height * 0.96),
            control2: CGPoint(x: xStart + direction * width * 0.02, y: height * 0.84)
        )
        path.addCurve(
            to: CGPoint(x: xStart, y: 0),
            control1: CGPoint(x: xStart + direction * width * 0.16, y: height * 0.34),
            control2: CGPoint(x: xStart + direction * width * 0.04, y: height * 0.10)
        )

        return path
    }
}

private struct MilestoneRow: View {
    let milestone: HealthMilestone
    let elapsedDays: Double

    private var state: MilestoneState {
        let elapsedMinutes = Int(floor(elapsedDays * 1_440))

        if milestone.minutesSinceQuit <= elapsedMinutes {
            return .completed
        }

        let nextMinutes = HealthMilestone.timeline.first(where: { $0.minutesSinceQuit > elapsedMinutes })?.minutesSinceQuit
        if milestone.minutesSinceQuit == nextMinutes {
            return .next
        }

        return .locked
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Circle()
                    .fill(state.color)
                    .frame(width: 14, height: 14)

                Rectangle()
                    .fill(state.lineColor)
                    .frame(width: 2, height: 58)
                    .padding(.top, 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(milestone.timelineLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(state.color)

                Text(milestone.title)
                    .font(.headline)
                    .foregroundStyle(state == .locked ? .secondary : AppPalette.success)

                Text(milestone.description)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(state == .locked ? .secondary : .primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Image(systemName: state.accessory)
                .foregroundStyle(state.color)
                .padding(.top, 4)
        }
        .padding(16)
        .background(AppPalette.track.opacity(0.72), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

private struct LungVisualState {
    let smokingYears: Int
    let recoveryDays: Double

    private var baseScore: Double {
        switch smokingYears {
        case ..<3: return 0.8
        case ..<5: return 1.2
        case ..<7: return 1.7
        case ..<10: return 2.3
        case ..<13: return 3.0
        case ..<17: return 3.8
        case ..<20: return 4.5
        default: return 5.0
        }
    }

    private var recoveryBonus: Double {
        switch recoveryDays {
        case ..<30: return 0.0
        case ..<90: return 0.25
        case ..<365: return 0.55
        case ..<1_825: return 0.95
        case ..<3_650: return 1.35
        default: return 1.80
        }
    }

    private var score: Double {
        min(max(baseScore - recoveryBonus, 0.4), 5.0)
    }

    var fill: Color {
        switch score {
        case ..<1.0: return Color(red: 0.97, green: 0.70, blue: 0.72)
        case ..<1.8: return Color(red: 0.95, green: 0.53, blue: 0.50)
        case ..<2.8: return Color(red: 0.90, green: 0.36, blue: 0.32)
        case ..<3.8: return Color(red: 0.73, green: 0.16, blue: 0.20)
        case ..<4.6: return Color(red: 0.46, green: 0.08, blue: 0.10)
        default: return Color(red: 0.12, green: 0.04, blue: 0.05)
        }
    }

    var stroke: Color {
        fill.opacity(0.85)
    }

    var glowColor: Color {
        switch score {
        case ..<1.8: return AppPalette.success
        case ..<3.8: return AppPalette.warning
        default: return AppPalette.danger
        }
    }

    var hasCracks: Bool {
        score >= 4.5
    }

    var label: String {
        switch score {
        case ..<1.0: return L10n.text("Минимальная", "Minimal")
        case ..<1.8: return L10n.text("Легкая", "Light")
        case ..<2.8: return L10n.text("Умеренная", "Moderate")
        case ..<3.8: return L10n.text("Выраженная", "Marked")
        case ..<4.6: return L10n.text("Тяжелая", "Severe")
        default: return L10n.text("Очень тяжелая", "Very severe")
        }
    }

    var caption: String {
        switch score {
        case ..<1.0:
            return L10n.text("Небольшой стаж и период восстановления держат визуальную нагрузку низкой.", "Lower smoking history and time in recovery keep the visual damage low.")
        case ..<1.8:
            return L10n.text("Следы воздействия есть, но легкие уже выглядят заметно легче тяжелых стадий.", "There are visible effects, but the lungs are still far lighter than severe stages.")
        case ..<2.8:
            return L10n.text("Стаж уже влияет на цвет, но восстановление постепенно смягчает картину.", "Smoking history already affects the color, while recovery slowly softens the picture.")
        case ..<3.8:
            return L10n.text("Длительное курение дает выраженный урон, хотя отказ уже начинает визуально осветлять легкие.", "Longer smoking history leads to marked damage, although quitting already starts visually lightening the lungs.")
        case ..<4.6:
            return L10n.text("Высокий стаж связан с тяжелым повреждением, поэтому легкие остаются темно-красными.", "Higher smoking history is associated with severe damage, so the lungs remain dark red.")
        default:
            return L10n.text("Очень долгий стаж дает самую тяжелую визуальную стадию: почти черный тон и красные трещины.", "Very long smoking history gives the heaviest visual stage: near-black tone with red cracks.")
        }
    }
}

private struct CrackSegment: Hashable {
    let start: CGPoint
    let end: CGPoint
}

private enum MilestoneState: Equatable {
    case completed
    case next
    case locked

    var color: Color {
        switch self {
        case .completed:
            return AppPalette.success
        case .next:
            return AppPalette.accent
        case .locked:
            return .secondary.opacity(0.45)
        }
    }

    var lineColor: Color {
        switch self {
        case .completed:
            return AppPalette.success.opacity(0.35)
        case .next:
            return AppPalette.accent.opacity(0.28)
        case .locked:
            return .secondary.opacity(0.18)
        }
    }

    var accessory: String {
        switch self {
        case .completed:
            return "checkmark.circle.fill"
        case .next:
            return "arrow.right.circle.fill"
        case .locked:
            return "chevron.right.circle.fill"
        }
    }
}
