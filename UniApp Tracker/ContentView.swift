//
//  ContentView.swift
//  CS IA
//
//  Created by Muhammad Riyan on 16/06/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI



struct addUniversity: Codable, Identifiable, Hashable {
    var id = UUID()
    var universityName: String
    var submissionDate: Date
    var decisionDate: Date
    var priority: Int
    var reminder: Bool
    var status: String
    var university: University
}
struct Checklist: Codable, Identifiable, Hashable{
    var id = UUID()
    let item: String
    var status: Bool
    let universityName: String
}

class Applications: ObservableObject {
    @Published var entries = [addUniversity]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(entries) {
                UserDefaults.standard.set(encoded, forKey: "universities")
            }
        }
    }
    @Published var checklists = [Checklist]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(checklists) {
                UserDefaults.standard.set(encoded, forKey: "checklists")
            }
        }
    }
    init() {
        if let universities = UserDefaults.standard.data(forKey: "universities"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([addUniversity].self, from: universities) {
                self.entries = decoded
            }
        } else { self.entries = [] }
        if let checkLists = UserDefaults.standard.data(forKey: "checklists"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Checklist].self, from: checkLists) {
                self.checklists = decoded
                return
            }
        } else { self.checklists = [] }

    }
}


struct ContentView: View {
    @ObservedObject var applications = Applications()
    @State private var showingAddUniversity = false
    @State private var showingUniversityList = false
    let universities: [University] = Bundle.main.decode("Universities.json")
    
    
   
   
    @Environment(\.calendar) var calendar
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    
    func dateMatching (_ date: Date) -> Bool {
        var importantDates: [Date] = []
        var matched = false
        
        for entry in applications.entries {
             importantDates.append(entry.decisionDate)
             importantDates.append(entry.submissionDate)
          }
        for importantDate in importantDates {
            if dateFormatter(importantDate) == dateFormatter(date) {
                matched = true
            }
        }
        
        return matched
    }
    
  
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {

                       CalendarView(interval: self.year) { date in
                                Text("30")
                                    .hidden()
                                    .padding(8)
                                    .background(dateMatching(date) ? Color.red : Color.blue)
                                    .clipShape(Rectangle())
                                    .cornerRadius(4)
                                    .padding(4)
                                    .overlay(
                                        Text(String(self.calendar.component(.day, from: date)))
                                            .foregroundColor(Color.black)
                                            
                                    )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary, lineWidth: 2))
                        .padding(4)
                
                    Text("Upcoming Deadlines")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 2)

                    ForEach (applications.entries, id: \.universityName) {appliedUniversity in
                     
                        if timeleft(appliedUniversity.decisionDate) < 30 {
                            NavigationLink(destination:  UniversityDetails(appliedUniversities: appliedUniversity)) {
                                VStack {
                                    HStack{
                                        if #available(iOS 14.0, *) {
                                            Text(appliedUniversity.universityName)
                                                .font(.title2)
                                                .bold()
                                        } else {
                                            Text(appliedUniversity.universityName)
                                                .font(.title)
                                                .bold()
                                        }
                                        Spacer()
                                        Image(systemName: "calendar")
                                        Text("Decision Date")
                                    }
                                    
                                    HStack{
                                        Text(dateFormatter(appliedUniversity.decisionDate))
                                        Spacer()
                                        Image(systemName: "clock.fill")
                                
                                        Text("Days left:")
                                        Text("\(timeleft(appliedUniversity.decisionDate))")
                                            .foregroundColor(timeleft(appliedUniversity.decisionDate) < 10 ? Color.red: Color.primary)
                                    }
                                }
                                .foregroundColor(Color.primary)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary, lineWidth: 2))
                                .padding(4)
                            }
                        }
                
                        if timeleft(appliedUniversity.submissionDate) < 30 && appliedUniversity.status == "To be Submitted"{
                            NavigationLink (destination:  UniversityDetails(appliedUniversities: appliedUniversity) ) {
                                VStack {
                                
                                    HStack{
                                        
                                        if #available(iOS 14.0, *) {
                                            Text(appliedUniversity.universityName)
                                                .font(.title2)
                                                .bold()
                                        } else {
                                            Text(appliedUniversity.universityName)
                                                .font(.title)
                                                .bold()
                                        }
                                        Spacer()
                                        Image(systemName: "calendar")
                                        Text("Submission Date")
                                    }
                                    
                                    HStack{
                                        Text(dateFormatter(appliedUniversity.submissionDate))
                                        Spacer()
                                        Image(systemName: "clock.fill")
                                
                                        Text("Days left:")
                                        Text ("\(timeleft(appliedUniversity.submissionDate))")
                                            .foregroundColor(timeleft(appliedUniversity.submissionDate) < 10 ? Color.red: Color.primary)
                                    }

                                }
                                .foregroundColor(Color.primary)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary, lineWidth: 2))
                                .padding(4)
                            }
                        }
                    }
                   
                        Spacer()
                }
 
            }
            .navigationBarTitle("Application Tracker")
            .navigationBarItems(leading: NavigationLink ( destination:   UniversityList(applications: self.applications, universities: self.universities) ) {
               Text ("Universities")
                },
            trailing: Button (action: {
                self.showingAddUniversity = true
            }) {
                Image(systemName: "plus")
            }
            )
                .sheet(isPresented: $showingAddUniversity) {
                    AddUniversity(applications: self.applications, universities: self.universities)
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
    func timeleft(_ checkUP: Date)-> Int {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: checkUP)
        let month = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
        let year = (components.year ?? 0) * 365
        let months = (components.month ?? 0)
        let day = components.day ?? 0
        let componentsNow = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let yearNow = (componentsNow.year ?? 0) * 365
        let monthsNow = (componentsNow.month ?? 0)
        let dayNow = componentsNow.day ?? 0
        
        let time = (day - dayNow) + (month[months-1] - month[monthsNow-1]) + (year - yearNow)
        
        return time
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        ContentView()
    }
}
 
