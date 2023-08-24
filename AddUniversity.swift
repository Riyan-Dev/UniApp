//
//  AddUniversity.swift
//  CS IA
//
//  Created by Muhammad Riyan on 16/06/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI
import UserNotifications

extension Date {
    func adding(days: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = days

        return NSCalendar.current.date(byAdding: dateComponents, to: self)
    }
}

struct AddUniversity: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var applications: Applications
    
    let universities: [University]
    
    var universityName: String {
        let university = universities[index]
        let name = university.universityName
        return name
    }
    
    @State private var index = 0
    @State private var submissionDate = Date()
    @State private var decisionDate = Date()
    @State private var priority = 2
    @State private var reminder = false
    @State private var status = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    static let statuses = ["To be Submitted", "Submitted", "Rejected", "Accepted"]
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker ("University", selection: $index) {
                        ForEach (universities) {
                            Text($0.universityName).tag($0.id)
                        }
                    }
                }
                Section(header: Text ("Submission Date") ) {
                    
                    DatePicker ("", selection: $submissionDate,
                                displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                }
                Section(header: Text ("Decision Date")) {
                    
                    DatePicker ("", selection: $decisionDate,
                                displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                }
                Section(header: Text("Priority for this university")) {
                    Picker ("Priority", selection: $priority) {
                        ForEach (1..<6) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                }
                Section {
                        Toggle (isOn: $reminder) {
                        Text ("Reminder")
                    }
                    Picker ("Status", selection: $status) {
                        ForEach (Self.statuses, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationBarTitle("New Application")
            .navigationBarItems(trailing: Button("save") {
                self.AppendingUniversity()
                
            })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    func AppendingUniversity () {
        guard repition(UniversityName: universityName) else {
            Error(title: "Repitition", message: "Application Already exists", Show: true)
            return
        }
        guard missingInfo(UniversityName: universityName, Status: status) else {
            Error(title: "Invalid Information", message: "You have entered insufficient information, Please review the form", Show: true)
            return
        }
        
        var matched: addUniversity
        
        
        if let match = universities.first(where:{$0.universityName == self.universityName}) {
                 matched = addUniversity(universityName: self.universityName, submissionDate: self.submissionDate, decisionDate: self.decisionDate, priority: self.priority, reminder: self.reminder, status: self.status, university: match)
                self.applications.entries.append(matched)
        } else { fatalError("University \(universityName) not found")}
        
        self.SchedulingNotification(reminder: self.reminder, date1: self.submissionDate, title: "Hurry up! Time running up for \(self.universityName)", subtitle: "Submission Date: \(dateFormatter(self.submissionDate))")
        self.SchedulingNotification(reminder: self.reminder, date1: self.decisionDate, title: "Gear up for your decision for \(self.universityName)", subtitle: "Decsion Date: \(dateFormatter(self.decisionDate))")
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func Error(title: String, message: String, Show: Bool) {
            alertTitle = title
            alertMessage = message
            showAlert = true
    }
    
    func repition(UniversityName: String) -> Bool {
        for index in 0 ..< applications.entries.count {
            if UniversityName == applications.entries[index].universityName {
                return false
            }
        }
         return true
    }
    
    func missingInfo (UniversityName: String, Status: String) -> Bool {
        if UniversityName == "" || Status == "" {
            return false
        }
        return true
    }
    func dateFormatter(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
    
    func SchedulingNotification(reminder: Bool, date1: Date, title: String, subtitle: String) {
        if reminder {
            for index in 1 ..< 15 {
                if let date = date1.adding(days: -index) {
                    var identifier = ""
                    if date1 == submissionDate {
                        identifier = "\(universityName)s\(index)"
                    } else {
                        identifier = "\(universityName)d\(index)"
                    }
                    Notification(withDate: date, title: title, subtitle: subtitle, identifier: identifier)
                }
            }
        }
        
    }

    func Notification (withDate date: Date, title: String, subtitle: String, identifier: String) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = (title)
            content.subtitle = (subtitle)
            content.sound = UNNotificationSound.default
            
         let dateComponents = Calendar.autoupdatingCurrent.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date)
            
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
        
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
            center.add(request)
        }
        
        center.getNotificationSettings {settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
                print("success2")
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                addRequest()
                                print("success")
                            } else {
                                print("D'oh")
                            }
                }
            }
        }
    }
    
    
}

struct AddUniversity_Previews: PreviewProvider {
    static let universities: [University] = Bundle.main.decode("Universities.json")
    
    static var previews: some View {
        AddUniversity(applications: Applications(), universities: universities)
    }
}
