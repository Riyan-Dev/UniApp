//
//  UniversityDetails.swift
//  CS IA
//
//  Created by Muhammad Riyan on 16/06/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct UniversityDetails: View {
    @State var appliedUniversities: addUniversity
    //@ObservedObject var applications: Applications
    
    @State private var showUpdateUniversity = false
    
    let colors: [String: Color] = ["Accepted": .green, "To be Submitted": .orange, "Rejected": .red, "Submitted": .green]

    var body: some View {
        GeometryReader{ geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.appliedUniversities.university.image)
                    .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                        .padding(.leading)
                        .padding(.trailing)
                    .scaledToFit()
                        .frame(maxWidth: geometry.size.width)
                    Image(self.appliedUniversities.university.logo)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.3)
                        .shadow(radius: 10)
                        .offset(x: 0, y: -70)
                    
                    VStack {
                        HStack {
                            Text("SAT Requirement:")
                                .font(.headline)
                            Spacer()
                            Text("\(self.appliedUniversities.university.SATReq)")
                                .font(.headline)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top)
                        
                        HStack {
                            Text("Tuition")
                            .font(.headline)
                            Spacer()
                            Text(self.appliedUniversities.university.tuition)
                                .font(.headline)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        HStack {
                            Text("Click on")
                                .font(.headline)
                                .padding(.leading)

                            
                            if #available(iOS 14.0, *) {
                                Link("Website", destination:URL(string: self.appliedUniversities.university.website)!
                                )
                                .font(.headline)
                            } else {
                                Button("Website") {
                                    UIApplication.shared.open(URL(string: self.appliedUniversities.university.website)!)
                                }
                            }
                                
                                
                            
                            Text("for more details")
                                .font(.headline)
                                .padding(.trailing)
                        }
                        .padding(.bottom)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                    .padding(.leading)
                    .padding(.trailing)
                    .offset(x: 0, y: -70)
                    HStack {
                        Text("Status:")
                            .font(.system(size: 20))
                            .font(.title)
                            .bold()
                        Text("\(appliedUniversities.status)")
                            .font(.system(size: 20))
                            .font(.title)
                            .bold()
                            .foregroundColor(colors[appliedUniversities.status, default: .primary])
                        Spacer()
                        
                        NavigationLink(destination: ChecklistView(applications: Applications(), appliedUniversity: self.appliedUniversities)) {
                            Text("CheckList")
                                .font(.system(size: 20))
                                .font(.title)
                                .bold()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top, 2)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .offset(x: 0, y: -70)
                    
                    HStack{
                        if #available(iOS 14.0, *) {
                            Text(dateFormatter(self.appliedUniversities.submissionDate))
                                .font(.title2)
                                .bold()
                            
                        } else {
                            Text(dateFormatter(self.appliedUniversities.submissionDate))
                                .font(.title)
                                .bold()
                        }
                        Spacer()
                        VStack{
                            HStack {
                                Image(systemName: "calendar")
                                Text("Submission")
                                
                            }
                            .padding(.top)
                            HStack {
                                Image(systemName: "clock.fill")
                                Text("Days left:")
                                Text("\(timeleft(self.appliedUniversities.submissionDate))")
                                    .foregroundColor(timeleft(self.appliedUniversities.submissionDate) < 10 ? Color.red: Color.primary)
                            }
                            .padding(.bottom)
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 2)
                    .offset(x: 0, y: -70)
                    
                    HStack{
                        if #available(iOS 14.0, *) {
                            Text(dateFormatter(self.appliedUniversities.decisionDate))
                                .font(.title2)
                                .bold()
                        } else {
                            Text(dateFormatter(self.appliedUniversities.decisionDate))
                                .font(.title)
                                .bold()
                        }
                        Spacer()
                        VStack{
                            HStack {
                                Image(systemName: "calendar")
                                Text("Decision")
                                
                            }
                            .padding(.top)
                            HStack {
                                Image(systemName: "clock.fill")
                                Text("Days left:")
                                Text("\(timeleft(self.appliedUniversities.decisionDate))")
                                    .foregroundColor(timeleft(self.appliedUniversities.decisionDate) < 10 ? Color.red: Color.primary)
                            }
                            .padding(.bottom)
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 2))
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 2)
                    .offset(x: 0, y: -70)
                   
                    HStack{
                        Text("Reminder")
                        if appliedUniversities.reminder {
                            Image(systemName: "checkmark.rectangle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "rectangle")
                        }
                        Spacer()
                        Text("Priotity:")
                        Text("\(appliedUniversities.priority + 1)")
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 2)
                    .offset(x: 0, y: -70)
                    
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(appliedUniversities.universityName)
        .navigationBarItems(trailing: Button(action: {
            self.showUpdateUniversity = true
        }) {
            Text("Update")
        })
        .sheet(isPresented: $showUpdateUniversity) {
                UpdateUniversity(applications: Applications(),  universityApplied: $appliedUniversities)
           
        }
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
    
    func dateFormatter(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
    

}


struct UniversityDetails_Previews: PreviewProvider {
    
    
    static var previews: some View {
    
        let AppliedUniversities = addUniversity(universityName: "Mit", submissionDate: Date(), decisionDate: Date(), priority: 0, reminder: true, status: "Accepted", university: University(id: 0, universityName: "Mit", SATReq: 1500, tuition: "6000 pound", website: "Riyan.com"))
        
        
        UniversityDetails(/*applications: Applications(),*/ appliedUniversities: AppliedUniversities )
            
        
    }
}
