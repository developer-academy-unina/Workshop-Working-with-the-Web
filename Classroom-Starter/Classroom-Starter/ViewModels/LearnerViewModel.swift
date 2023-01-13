//
//  LearnerViewModel.swift
//  Classroom-Starter
//
//  Created by Gianluca Orpello on 12/01/23.
//

import SwiftUI

@MainActor
class LearnerViewModel: ObservableObject {
    
    @Published var learner: Learner?
    
    let decoder = JSONDecoder()
    
    var urlComponents = URLComponents(string: "http://[Add address here!]")
    
    func getLearner() async {
        
    }
    
    func postLearner() async {
        
    }
    
}
