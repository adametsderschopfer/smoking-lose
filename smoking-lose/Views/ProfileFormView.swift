//
//  ProfileFormView.swift
//  smoking-lose
//
//  Created by Codex on 28.02.2026.
//

import SwiftData
import SwiftUI

struct ProfileFormView: View {
    enum Mode: Equatable {
        case onboarding
        case edit

        var title: String {
            switch self {
            case .onboarding:
                return L10n.text("Бросаю курить", "Quit Smoking")
            case .edit:
                return L10n.text("Профиль", "Profile")
            }
        }

        var subtitle: String {
            switch self {
            case .onboarding:
                return L10n.text(
                    "Заполните базовые данные, и приложение сразу покажет экономию денежных средств и ближайшие рубежи и цели.",
                    "Enter the basics and the app will immediately show savings and the next milestones and goals."
                )
            case .edit:
                return L10n.text(
                    "Обновите данные, если изменились вводные или вы хотите скорректировать расчеты.",
                    "Update your data if your situation changed or you want to adjust the calculations."
                )
            }
        }

        var actionTitle: String {
            switch self {
            case .onboarding:
                return L10n.text("Начать", "Start")
            case .edit:
                return L10n.text("Сохранить", "Save")
            }
        }
    }

    private enum Field: Hashable {
        case cigarettesPerDay
        case cigarettesPerPack
        case smokingYears
        case pricePerPack
        case investmentRate
        case investmentYears
    }

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: Field?

    private let mode: Mode
    private let profile: UserProfile?

    @State private var draft: ProfileDraft
    @State private var hasAttemptedSubmit = false
    @State private var touchedFields: Set<Field> = []

    private let notificationManager = RecoveryNotificationManager()

    init(mode: Mode, profile: UserProfile? = nil) {
        self.mode = mode
        self.profile = profile
        _draft = State(initialValue: ProfileDraft(profile: profile))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        header
                        basicsCard
                        smokingCard
                        financeCard
                        disclaimerCard
                        supportButton
                    }
                    .frame(maxWidth: 760)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .padding(.bottom, focusedField == nil ? 120 : 24)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
                dismissKeyboard()
            }
            .onChange(of: focusedField) { previous, _ in
                if let previous {
                    touchedFields.insert(previous)
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if mode == .edit {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(L10n.text("Закрыть", "Close")) {
                            dismiss()
                        }
                    }
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L10n.text("Готово", "Done")) {
                        focusedField = nil
                        dismissKeyboard()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if focusedField == nil {
                    floatingActionBar
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(mode.title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            Text(mode.subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if hasAttemptedSubmit, let validationMessage = draft.validationMessage {
                Label(validationMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppPalette.warning)
            }
        }
    }

    private var basicsCard: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(
                    title: L10n.text("Старт", "Start"),
                    subtitle: L10n.text("Дата отказа и формат курения.", "Quit date and smoking format."),
                    icon: "calendar.badge.clock"
                )

                VStack(spacing: 14) {
                    fieldRow(title: L10n.text("Дата отказа", "Quit date")) {
                        DatePicker(
                            "",
                            selection: $draft.quitDate,
                            in: ...Date(),
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                    }

                    selectionBlock(
                        title: L10n.text("Тип", "Type"),
                        selection: $draft.productType,
                        items: SmokingProductType.allCases
                    ) { $0.accessoryTitle }
                }
            }
        }
    }

    private var smokingCard: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(
                    title: L10n.text("Привычка", "Habit"),
                    subtitle: L10n.text("Данные для расчета интенсивности, легких и экономии.", "Inputs for intensity, lungs, and savings calculations."),
                    icon: "lungs.fill"
                )

                VStack(spacing: 14) {
                    intField(
                        title: L10n.text("Количество в день", "Per day"),
                        text: $draft.cigarettesPerDayText,
                        placeholder: "1...150",
                        field: .cigarettesPerDay
                    )

                    intField(
                        title: L10n.text("Количество в пачке", "Per pack"),
                        text: $draft.cigarettesPerPackText,
                        placeholder: "20",
                        field: .cigarettesPerPack
                    )

                    intField(
                        title: L10n.text("Стаж курения (лет)", "Smoking years"),
                        text: $draft.smokingYearsText,
                        placeholder: "1...85",
                        field: .smokingYears
                    )
                }
            }
        }
    }

    private var financeCard: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(
                    title: L10n.text("Траты и экономия", "Spending and savings"),
                    subtitle: mode == .onboarding
                        ? L10n.text(
                            "На старте нужен только расход на пачку.",
                            "At the start, only your pack cost is needed."
                        )
                        : L10n.text(
                            "Тут можно поправить стоимость и параметры прогноза.",
                            "You can adjust cost and projection settings here."
                        ),
                    icon: "creditcard.fill"
                )

                VStack(spacing: 14) {
                    doubleField(
                        title: L10n.text("Цена пачки", "Pack price"),
                        text: $draft.pricePerPackText,
                        placeholder: "0.00",
                        field: .pricePerPack
                    )

                    if mode == .edit {
                        doubleField(
                            title: L10n.text("Ставка инвестирования (%)", "Investment rate (%)"),
                            text: $draft.investmentRateText,
                            placeholder: "13",
                            field: .investmentRate
                        )

                        doubleField(
                            title: L10n.text("Горизонт прогноза (лет)", "Projection years"),
                            text: $draft.investmentYearsText,
                            placeholder: "10",
                            field: .investmentYears
                        )
                    }
                }
            }
        }
    }

    private var disclaimerCard: some View {
        SurfaceCard {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: "cross.case.fill")
                    .font(.title3)
                    .foregroundStyle(AppPalette.warning)

                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.text("Важно", "Important"))
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(
                        L10n.text(
                            "Данные в приложении носят информационный характер и не заменяют консультацию врача.",
                            "The information in the app is educational and does not replace medical advice."
                        )
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var supportButton: some View {
        Link(destination: URL(string: "https://pressf.com/dalekye/donate")!) {
            Label(
                L10n.text("Поддержать разработчика", "Support the developer"),
                systemImage: "heart.fill"
            )
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppPalette.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .foregroundStyle(AppPalette.accent)
        }
    }

    private var floatingActionBar: some View {
        SurfaceCard {
            actionButton
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var actionButton: some View {
        Button(action: saveProfile) {
            Text(mode.actionTitle)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [AppPalette.accent, AppPalette.accentSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
        .opacity(draft.isValid ? 1 : 0.82)
    }

    private func saveProfile() {
        guard draft.isValid else {
            hasAttemptedSubmit = true
            return
        }

        let savedProfile: UserProfile
        if let profile {
            draft.apply(to: profile)
            savedProfile = profile
        } else {
            let newProfile = draft.makeProfile()
            modelContext.insert(newProfile)
            savedProfile = newProfile
        }

        try? modelContext.save()
        notificationManager.refreshNotifications(for: savedProfile)
        focusedField = nil
        dismissKeyboard()

        if mode == .edit {
            dismiss()
        }
    }

    private func sectionHeader(title: String, subtitle: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppPalette.accent)
                .frame(width: 32, height: 32)
                .background(AppPalette.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func fieldRow<ValueView: View>(title: String, @ViewBuilder valueView: () -> ValueView) -> some View {
        fieldRow(title: title, errorMessage: nil, valueView: valueView)
    }

    private func fieldRow<ValueView: View>(
        title: String,
        errorMessage: String?,
        @ViewBuilder valueView: () -> ValueView
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 12)

                    valueView()
                        .labelsHidden()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        Spacer(minLength: 0)
                        valueView()
                            .labelsHidden()
                    }
                }
            }
            .padding(14)
            .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(errorMessage == nil ? .clear : AppPalette.warning, lineWidth: 1.5)
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(AppPalette.warning)
                    .padding(.horizontal, 4)
            }
        }
    }

    private func intField(title: String, text: Binding<String>, placeholder: String, field: Field) -> some View {
        fieldRow(title: title, errorMessage: errorMessage(for: field)) {
            TextField(placeholder, text: text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .frame(minWidth: 90)
                .foregroundStyle(.primary)
                .focused($focusedField, equals: field)
                .onChange(of: text.wrappedValue) { _, _ in
                    touchedFields.insert(field)
                }
        }
    }

    private func doubleField(title: String, text: Binding<String>, placeholder: String, field: Field) -> some View {
        fieldRow(title: title, errorMessage: errorMessage(for: field)) {
            TextField(placeholder, text: text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(minWidth: 110)
                .foregroundStyle(.primary)
                .focused($focusedField, equals: field)
                .onChange(of: text.wrappedValue) { _, _ in
                    touchedFields.insert(field)
                }
        }
    }

    private func selectionBlock<Item: Identifiable & Hashable>(
        title: String,
        selection: Binding<Item>,
        items: [Item],
        titleProvider: @escaping (Item) -> String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Picker("", selection: selection) {
                ForEach(items) { item in
                    Text(titleProvider(item)).tag(item)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private func errorMessage(for field: Field) -> String? {
        let shouldShowValidation = hasAttemptedSubmit || touchedFields.contains(field)
        guard shouldShowValidation else { return nil }

        switch field {
        case .cigarettesPerDay:
            if draft.cigarettesPerDay == nil {
                return L10n.text("Обязательное поле", "Required field")
            }
            if draft.cigarettesPerDay ?? 0 <= 0 {
                return L10n.text("Нужно число больше 0", "Must be greater than 0")
            }
            if draft.cigarettesPerDay ?? 0 > 150 {
                return L10n.text("Максимум 150 в день", "Maximum 150 per day")
            }
        case .cigarettesPerPack:
            if draft.cigarettesPerPack == nil {
                return L10n.text("Обязательное поле", "Required field")
            }
            if draft.cigarettesPerPack ?? 0 <= 0 {
                return L10n.text("Нужно число больше 0", "Must be greater than 0")
            }
        case .smokingYears:
            if draft.smokingYears == nil {
                return L10n.text("Обязательное поле", "Required field")
            }
            if draft.smokingYears ?? 0 <= 0 {
                return L10n.text("Нужно число больше 0", "Must be greater than 0")
            }
            if draft.smokingYears ?? 0 > 85 {
                return L10n.text("Максимум 85 лет", "Maximum 85 years")
            }
        case .pricePerPack:
            if draft.pricePerPack == nil {
                return L10n.text("Обязательное поле", "Required field")
            }
            if draft.pricePerPack ?? 0 <= 0 {
                return L10n.text("Нужно число больше 0", "Must be greater than 0")
            }
        case .investmentRate:
            if draft.investmentRate == nil {
                return L10n.text("Обязательное поле", "Required field")
            }
            if draft.investmentRate ?? 0 <= 0 {
                return L10n.text("Нужно число больше 0", "Must be greater than 0")
            }
        case .investmentYears:
            if draft.investmentYears == nil {
                return L10n.text("Обязательное поле", "Required field")
            }
            if draft.investmentYears ?? 0 <= 0 {
                return L10n.text("Нужно число больше 0", "Must be greater than 0")
            }
        }

        return nil
    }
}
