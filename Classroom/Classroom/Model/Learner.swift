//
//  Student.swift
//  Classroom
//
//  Created by Stefania Zinno
//

import Foundation
import SwiftUI

struct Learner: Identifiable, Codable {
    var id: UUID
    var name: String
    var surname: String
    var imageName: String
    var shortBio: String
}


enum LearnerInfoError: Error, LocalizedError {
    case itemNotFound, creationFailed, serverError
}
