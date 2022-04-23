//
//  CalendarExtension.swift
//  
//
//  Created by Irshad Ahmad on 11/05/22.
//

import Foundation

public extension Calendar {
    /// UtilityPackage: Returns days of current week including today.
    /// - Parameters:
    ///   - includeWeekend: Send true if need to include weekends days.
    /// - Returns: list of dates.
    func weekDaysTillToday(includeWeekend: Bool) -> [Date] {
        let today = self.startOfDay(for: Date())
        let dayOfWeek = self.component(.weekday, from: today)
        let days = self.range(of: .weekday, in: .weekOfYear, for: today)!
            .compactMap {
                self.date(byAdding: .day, value: $0 - dayOfWeek, to: today)
            }
        
        if includeWeekend {
            return days.filter {(
                self.compare($0, to: Date(), toGranularity: .day) == ComparisonResult.orderedSame ||
                self.compare($0, to: Date(), toGranularity: .day) == ComparisonResult.orderedAscending
            )}
        }
        
        return days.filter {
            (self.compare($0, to: Date(), toGranularity: .day) == ComparisonResult.orderedSame ||
             self.compare($0, to: Date(), toGranularity: .day) == ComparisonResult.orderedAscending) &&
            !self.isDateInWeekend($0)
        }
    }
}
