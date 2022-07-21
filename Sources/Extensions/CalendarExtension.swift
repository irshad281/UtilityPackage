//
//  CalendarExtension.swift
//  
//
//  Created by Irshad Ahmad on 11/05/22.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
