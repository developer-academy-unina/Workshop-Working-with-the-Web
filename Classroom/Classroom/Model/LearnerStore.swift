//
//  StudentsViewModel.swift
//  Classroom
//
//  Created by Stefania Zinno
//

import Foundation
import SwiftUI

class LearnerStore: ObservableObject {
    
    @Published var fetching: Bool = false
    @Published var learners: [Learner] = []
    
    func getAllLearners() async {
        self.fetching = true
        defer { self.fetching = false }
        Task {
            let learners = try? await NetworkManager.getAllLearners()
            DispatchQueue.main.async {
                self.learners = learners != nil ? learners! : []
            }
        }
    }
    
    func create(learner: Learner) async {
        self.fetching = true
        defer { self.fetching = false }
        
        Task {
            let newLearner = try? await NetworkManager.create(learner)
            guard let newLearner = newLearner else {
                throw LearnerInfoError.creationFailed
            }
            
            DispatchQueue.main.async {
                self.learners.append(newLearner)
            }
        }
        
    }
    
    func remove(with id: UUID) async {
        DispatchQueue.main.async {
            self.fetching = true
        }
        defer {  DispatchQueue.main.async { self.fetching = false } }
        
                
        Task {
            try await NetworkManager.remove(with: id)
            DispatchQueue.main.async {
                self.learners.removeAll { $0.id == id }
            }
        }
    }
    
}
