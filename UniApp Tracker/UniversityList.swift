//
//  UniversityList.swift
//  CS IA
//
//  Created by Muhammad Riyan on 16/06/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

class Input: ObservableObject {
    @Published var sortInput = 0
}

struct UniversityList: View {
    
    @ObservedObject var applications: Applications
    @ObservedObject var input = Input()
    
    let sortedUniversityApplied: [addUniversity]
    let sortInputs = ["All","Priority", "To Submit", "Submitted", "Rejected","Accepted", "Country"]
    @State private var showingSortInputSheet = false
    

    var body: some View {
            List{
                if input.sortInput != 1 {
                    ForEach(applications.entries, id: \.universityName) {appliedUniversity in
                        if input.sortInput == 0 {
                            NavigationLink (destination: UniversityDetails(appliedUniversities: appliedUniversity)){
                                HStack {
                                    Image(appliedUniversity.university.logo)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text(verbatim: appliedUniversity.universityName)
                                }
                            }
                        }
                        else if input.sortInput == 2 && appliedUniversity.status == "To be Submitted" {
                            NavigationLink (destination: UniversityDetails(appliedUniversities: appliedUniversity)){
                                HStack {
                                    Image(appliedUniversity.university.logo)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text(verbatim: appliedUniversity.universityName)
                                }
                            }
                        }
                        else if input.sortInput == 3 && appliedUniversity.status == "Submitted" {
                            NavigationLink (destination: UniversityDetails(appliedUniversities: appliedUniversity)){
                                HStack {
                                    Image(appliedUniversity.university.logo)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text(verbatim: appliedUniversity.universityName)
                                }
                            }
                        }
                        else if input.sortInput == 4 && appliedUniversity.status == "Rejected" {
                            NavigationLink (destination: UniversityDetails(appliedUniversities: appliedUniversity)){
                                HStack {
                                    Image(appliedUniversity.university.logo)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text(verbatim: appliedUniversity.universityName)
                                }
                            }
                        }
                        else if input.sortInput == 5 && appliedUniversity.status == "Accepted" {
                            NavigationLink (destination: UniversityDetails(appliedUniversities: appliedUniversity)){
                                HStack {
                                    Image(appliedUniversity.university.logo)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Text(verbatim: appliedUniversity.universityName)
                                }
                            }
                        }
                         
                    }
 
                    .onDelete(perform: removeUniversity)
                }
            
                else{
                    ForEach(sortedUniversityApplied, id: \.universityName) { sortedAppliedUniversity in
                        NavigationLink (destination: UniversityDetails(appliedUniversities: sortedAppliedUniversity)){
                            HStack {
                                Image(sortedAppliedUniversity.university.logo)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text(verbatim: sortedAppliedUniversity.universityName)
                            }
                        }
                    }
                    .onDelete(perform: removeUniversity)
 
                }

            }
            .navigationBarTitle("Universities")
            .navigationBarItems(trailing: Button (action: {
                self.showingSortInputSheet = true
            }) {
                Text("Sort")
            })
            .sheet(isPresented: $showingSortInputSheet) {
                SortInputSheet(input: input)
            }
        
    }
    
    func removeUniversity (at Offset: IndexSet) {
   
        
        if let index = Offset.first {
            print( index)
            let universityName = applications.entries[index].universityName
            print (universityName)
            let centre = UNUserNotificationCenter.current()
            centre.getPendingNotificationRequests{ (notificationRequests) in
                var identifiers: [String] = []
                for I in 1 ..< 15 {
                   let submissionIdentifier = "\(universityName)s\(I)"
                    identifiers.append(submissionIdentifier)
                   let decisionIdentifier = "\(universityName)d\(I)"
                    identifiers.append(decisionIdentifier)
                }
                centre.removePendingNotificationRequests(withIdentifiers: identifiers)
            }
            
        }
        applications.entries.remove(atOffsets: Offset)
        
    }
    
    init (applications: Applications, universities: [University] ) {
        self.applications = applications

        var universities = applications.entries
        
        if universities.count > 1 {
            for x in 0 ..< universities.count - 1 {
                for y in 0 ..< universities.count - 1 - x {
                    if  universities[y].priority < universities[y + 1].priority {
                        let tempName = universities[y].universityName
                        universities[y].universityName =  universities[y+1].universityName
                        universities[y + 1].universityName = tempName
                        let tempSubmissionDate =  universities[y].submissionDate
                        universities[y].submissionDate =  universities[y+1].submissionDate
                        universities[y + 1].submissionDate = tempSubmissionDate
                        let tempDecisionDate = universities[y].decisionDate
                        universities[y].decisionDate =  universities[y+1].decisionDate
                        universities[y + 1].decisionDate = tempDecisionDate
                        let tempPriority = universities[y].priority
                        universities[y].priority =  universities[y+1].priority
                        universities[y + 1].priority = tempPriority
                        let tempReminder = universities[y].reminder
                        universities[y].reminder =  universities[y+1].reminder
                        universities[y + 1].reminder = tempReminder
                        let tempStatus = universities[y].status
                        universities[y].status =  universities[y+1].status
                        universities[y + 1].status = tempStatus
                        let tempUniversity = universities[y].university
                        universities[y].university =  universities[y+1].university
                        universities[y + 1].university = tempUniversity
                    }
                }
            }
        }
        self.sortedUniversityApplied = universities
    }
    
}



struct UniversityList_Previews: PreviewProvider {
    static let universities: [University] = Bundle.main.decode("Universities.json")
    

    
    static var previews: some View {
        UniversityList(applications: Applications(), universities: universities)
    }
}
