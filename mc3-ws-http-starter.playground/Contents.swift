import Foundation
import SwiftUI

struct Learner {
    var email: String
    var id: String
    var surname: String
    var name: String
    var authID: String
    var completed: Bool
}

var urlComponents = URLComponents(string: "https://mc3-ws-http.herokuapp.com")!

urlComponents.path = "/classroom"

urlComponents.queryItems = [
    "email": "DEMO_KEY",
].map { URLQueryItem(name: $0.key, value: $0.value) }

Task {
    do {
        
    } catch {
        print(error)
    }
    
}



func getLearner(_ url: URL) async throws -> Learner? {
    
    return nil
}

