//
//  ChecklistView.swift
//  CS IA
//
//  Created by Muhammad Riyan on 15/02/2021.
//  Copyright © 2021 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct ChecklistView: View {
    @ObservedObject var applications: Applications
    let appliedUniversity: addUniversity
    
    
    struct UniCheckList: Codable, Identifiable, Hashable {
        let id: UUID
        let item: String
        var status: Bool
        let universityName: String
    }
    
    var uniChecklist: [UniCheckList]
    
    @State private var item = ""
    @State private var showingAddChecklist = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            TextField("Enter New Reminder", text: $item, onCommit: appendingReminder)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            

            List {
                ForEach(uniChecklist, id:\.self) { checklist in
                    HStack {
                        Button (action: {
                            for x in 0 ..< applications.checklists.count {
                                let checklists = applications.checklists
                                if checklists[x].universityName == checklist.universityName && checklists[x].id == checklist.id{
                                    applications.checklists[x].status.toggle()
                                }
                            }
                        }) {
                            
                            
                            if status(checklist) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.trailing)
                        Text("\(checklist.item)")
                    }
                }.onDelete(perform: removeItem )
            }

        }.navigationBarTitle("Checklist")
        
    }
    func status(_ checklist: UniCheckList) -> Bool{
        var status = false
        for x in 0 ..< applications.checklists.count {
            let checklists = applications.checklists
            if checklists[x].universityName == checklist.universityName && checklists[x].id == checklist.id {
                status = checklists[x].status
            }
        }
        return status
    }
    
    
    func removeItem(at offSet: IndexSet) {
        applications.checklists.remove(atOffsets: offSet)
    }

    init(applications: Applications, appliedUniversity: addUniversity) {
        self.applications = applications
        self.appliedUniversity = appliedUniversity
        
        var matches = [UniCheckList]()
        
        for checklist in applications.checklists {
            if checklist.universityName == appliedUniversity.universityName {
                matches.append(UniCheckList(id: checklist.id, item: checklist.item, status: checklist.status, universityName: checklist.universityName))
            }
        }
        self.uniChecklist = matches
    }
    func appendingReminder() {
        guard missingInfo(item: item) else {
            Error(title: "Reminder Empty", message: "Please Enter something", Show: true)
            return
        }
        let reminder = Checklist(item: self.item, status: false, universityName: appliedUniversity.universityName)
        self.applications.checklists.append(reminder)
        
    }
    func missingInfo (item: String) -> Bool {
        if item == ""  {
            return false
        }
        return true
    }
    func Error(title: String, message: String, Show: Bool) {
            alertTitle = title
            alertMessage = message
            showAlert = true
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        let AppliedUniversities = addUniversity(universityName: "Mit", submissionDate: Date(), decisionDate: Date(), priority: 0, reminder: true, status: "Accepted", university: University(id: 0, universityName: "Mit", SATReq: 1500, tuition: "6000 pound", website: "Riyan.com"))
        
        ChecklistView(applications: Applications(), appliedUniversity: AppliedUniversities)
    }
}
