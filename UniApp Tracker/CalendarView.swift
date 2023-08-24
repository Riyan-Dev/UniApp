//
//  CalendarView.swift
//  CS IA
//
//  Created by Muhammad Riyan on 08/02/2021.
//  Copyright © 2021 Muhammad Riyan. All rights reserved.
//

import SwiftUI

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    static var monthandyear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates (startingAfter: interval.start, matching: components, matchingPolicy: .nextTime) {date, _ , stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    let content: (Date) -> DateView
    
    init (week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else {
            return []
        }
        return calendar.generateDates(inside: weekInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    var body: some View {
        HStack {
            ForEach(days, id: (\.self)) {date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    @State private var month: Date
    let content: (Date) -> DateView
    
    init (month: Date, @ViewBuilder content: @escaping (Date) -> DateView ) {
        self._month = State(initialValue: month)
        self.content = content
    }
    
    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        return calendar.generateDates(inside: monthInterval, matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday))
    }
    
    func changeMonth (_ months: Int) {
        if let date = Calendar.current.date(byAdding: .month, value: months, to: month) {
            self.month = date
        }
    }
    
    private var header: some View {
        let formatter = DateFormatter.monthandyear
        
        return HStack {
            Text(formatter.string(from: month))
                .font(.title)
                .padding(.horizontal)
            Spacer()
            HStack{
                Button (action: {changeMonth(-1)}) {
                    Image(systemName: "chevron.left.square")
                        
                }
                Button (action: {self.month = Date()}){
                    Image(systemName: "dot.square")
                        
                }
                Button(action: {changeMonth(1)}) {
                    Image(systemName: "chevron.right.square")
                        
                }
            }
            .padding(.trailing)
            .foregroundColor(Color.blue)
            .frame(width: 50, height: 50)
        }
        .padding(.trailing, 20)
    }
    let weekDays = Calendar.current.shortWeekdaySymbols
    var body: some View {
        VStack {
            header
            HStack{
                ForEach (0..<7) { index in
                    Text("30")
                        .hidden()
                        .padding(8)
                        .clipShape(Circle())
                        .padding(.horizontal, 4)
                        .overlay(
                            Text(weekDays[index].uppercased()))
                }
            }
            ForEach(weeks, id:\.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}

struct CalendarView<DateView>: View where DateView: View{
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let content: (Date) -> DateView

    init (interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        ForEach(months, id:\.self) {month in
            MonthView(month: month, content: self.content)
        }
    }
}

struct CalendarView_Previews: PreviewProvider { 
    static var previews: some View {
        EmptyView()
    }
}
