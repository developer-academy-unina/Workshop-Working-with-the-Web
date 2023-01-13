//
//  ContentView.swift
//  Classroom-Starter
//
//  Created by Gianluca Orpello on 12/01/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject
    var learnerVM = LearnerViewModel()
    
    var body: some View {
        NavigationStack {
         
            VStack(alignment: .leading) {
                
                if let learner = learnerVM.learner {
                    Text("Learner: ")
                        .font(.headline)
                    
                    Text("Name: \(learner.name)")
                    Text("Code: \(learner.code)")
                    Text("ApiToken: \(learner.apiToken)")
                    
                } else {
                    Text("No Learner yet...")
                }
                
                Spacer()
                
                Button {
                    Task {
                        await learnerVM.getLearner()
                    }
                    
                } label: {
                    buttonLabel(with: "Perform GET Request",
                                and: .accentColor)
                }
                
                Button {
                    Task{
                        await learnerVM.postLearner()
                    }
                    
                } label: {
                    buttonLabel(with: "Perform POST Request",
                                and: .green)
                }
            }
            .padding()
            .navigationTitle("Classroom")
        }
    }
    
    @ViewBuilder
    func buttonLabel(with text: String, and color: Color) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 55)
                .foregroundColor(color)
            Text(text)
                .foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
