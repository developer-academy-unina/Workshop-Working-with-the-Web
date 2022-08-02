//
//  StudentDetail.swift
//  Classroom
//
//  Created by Stefania Zinno
//

import SwiftUI


struct PresentMeView: View {
    
    var learner: Learner
    var learnerStore: LearnerStore
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 16.0) {
                // Horizontally Centered Image
                HStack {
                    Spacer()
                    Image(learner.imageName)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 8)
                                .foregroundColor(.gray)
                        )
                        .shadow(radius: 10)
                        .padding()
                    Spacer()
                }
                // Name and Surname (Title)
                Text("\(learner.name) \(learner.surname)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                // Description (Body)
                Text(learner.shortBio)
                    .padding(.bottom)
                
                Button(role: .destructive) {
                    delete(with: learner.id)
                } label: {
                    Text("Delete Learner")
                }
            }
            .padding()
        }
        
    }
    
    func delete(with id: UUID) {
        Task{
            await learnerStore.remove(with: id)
        }
    }
}



