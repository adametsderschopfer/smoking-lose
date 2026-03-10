import XCTest
@testable import SmokeQuitCore

final class SmokeQuitCoreTests: XCTestCase {
    func testDailyCostAndSavedMoney() {
        let calculator = SmokeQuitCalculator()
        let quitDate = Date(timeIntervalSince1970: 0)
        let elapsedSeconds = (2 * 86_400) + (13 * 3_600) + (42 * 60)
        let now = Date(timeIntervalSince1970: TimeInterval(elapsedSeconds))

        let dailyCost = calculator.dailyCost(
            pricePerPack: 240,
            cigarettesPerPack: 20,
            cigarettesPerDay: 10
        )
        let savedMoney = calculator.calculateSavedMoney(
            pricePerPack: 240,
            cigarettesPerPack: 20,
            cigarettesPerDay: 10,
            quitDate: quitDate,
            now: now
        )

        XCTAssertEqual(dailyCost, 120, accuracy: 0.001)
        XCTAssertEqual(savedMoney, 308.5, accuracy: 0.001)
        XCTAssertEqual(calculator.calculateDaysSinceQuit(from: quitDate, now: now).minutes, 42)
    }

    func testFutureValueUsesCompoundGrowthFormula() {
        let calculator = SmokeQuitCalculator()
        let futureValue = calculator.calculateFutureValue(saved: 1_240, annualRatePercent: 13)

        XCTAssertEqual(futureValue, 4_209.26, accuracy: 0.01)
    }

    func testCurrentAndNextMilestones() {
        let calculator = SmokeQuitCalculator()
        let quitDate = Date(timeIntervalSinceNow: -(15 * 86_400))

        XCTAssertEqual(calculator.currentMilestone(quitDate: quitDate)?.minutesSinceQuit, 14 * 24 * 60)
        XCTAssertEqual(calculator.nextMilestone(quitDate: quitDate)?.minutesSinceQuit, 30 * 24 * 60)
    }

    func testLungDarknessCapsAtOne() {
        let calculator = SmokeQuitCalculator()

        XCTAssertEqual(calculator.lungDarkness(smokingYears: 5), 0.25, accuracy: 0.0001)
        XCTAssertEqual(calculator.lungDarkness(smokingYears: 30), 1.0, accuracy: 0.0001)
        XCTAssertTrue(calculator.shouldShowRedSpeckles(smokingYears: 10))
        XCTAssertFalse(calculator.shouldShowRedSpeckles(smokingYears: 9))
    }
}
