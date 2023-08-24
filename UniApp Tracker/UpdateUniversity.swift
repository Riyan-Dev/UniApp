//
//  UpdateUniversity.swift
//  CS IA
//
//  Created by Muhammad Riyan on 12/02/2021.
//  Copyright © 2021 Muhammad Riyan. All rights reserved.
//

import SwiftUI




struct UpdateUniversity: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var applications: Applications
    @Binding var universityApplied: addUniversity

    private let statusList = ["To be Submitted", "Submitted", "Rejected", "Accepted"]
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Prioirty: ").bold().foregroundColor(.primary)) {
                    Picker ("Priority", selection: $universityApplied.priority) {
                        ForEach (1..<6) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                }
                Section {
                    Toggle (isOn: $universityApplied.reminder) {
                        Text ("Reminder")
                    }
                    Picker ("Status", selection: $universityApplied.status) {
                        ForEach (statusList, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationBarTitle("\(universityApplied.universityName)")
            .navigationBarItems(trailing: Button("save") {
                self.updateUniversity()
            })
        }
    }
     func updateUniversity() {
       for index in 0 ..< applications.entries.count {
            if applications.entries[index].universityName == universityApplied.universityName {
                if applications.entries[index].priority != universityApplied.priority {
                    applications.entries[index].priority = universityApplied.priority
                }
                if applications.entries[index].reminder != universityApplied.reminder {
                    applications.entries[index].reminder = universityApplied.reminder
                    self.SchedulingNotification(reminder: universityApplied.reminder, date1:  universityApplied.submissionDate, title: "Hurry up! Time running up for \(universityApplied.universityName)", subtitle: "Submission Date:  \(dateFormatter(universityApplied.submissionDate))")
                    self.SchedulingNotification(reminder: universityApplied.reminder, date1: universityApplied.decisionDate, title: "Gear up for your decision for \(universityApplied.universityName)", subtitle: "Decsion Date: \(dateFormatter(universityApplied.decisionDate))")
                }
                if applications.entries[index].status != universityApplied.status {
                    applications.entries[index].status = universityApplied.status
                }
            }
       }
       
        self.presentationMode.wrappedValue.dismiss()
    }
    func SchedulingNotification(reminder: Bool, date1: Date, title: String, subtitle: String) {
        if reminder {
            for index in 1 ..< 15 {
                if let date = date1.adding(days: -index) {
                    var identifier = ""
                    if date1 == universityApplied.submissionDate {
                        identifier = "\(universityApplied.universityName)s\(index)"
                    } else {
                        identifier = "\(universityApplied.universityName)d\(index)"
                    }
                    Notification(withDate: date, title: title, subtitle: subtitle,identifier: identifier)
                }
            }
        } else {
            let centre = UNUserNotificationCenter.current()
            centre.getPendingNotificationRequests{ (notificationRequests) in
                var identifiers: [String] = []
                for I in 1 ..< 15 {
                    let submissionIdentifier = "\(universityApplied.universityName)s\(I)"
                    identifiers.append(submissionIdentifier)
                    let decisionIdentifier = "\(universityApplied.universityName)d\(I)"
                    identifiers.append(decisionIdentifier)
                }
                centre.removePendingNotificationRequests(withIdentifiers: identifiers)
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
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                addRequest()
                            } else {
                                print("D'oh")
                            }
                }
            }
        }
    }
    func dateFormatter(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }

}
struct UpdateUniversity_Previews: PreviewProvider {
   
    static var previews: some View {
        
        let AppliedUniversities = addUniversity(universityName: "Mit", submissionDate: Date(), decisionDate: Date(), priority: 0, reminder: true, status: "Accepted", university: University(id: 0, universityName: "Mit", SATReq: 1500, tuition: "6000 pound", website: "Riyan.com"))
        UpdateUniversity(applications: Applications(), universityApplied: .constant(AppliedUniversities))

    }
}
