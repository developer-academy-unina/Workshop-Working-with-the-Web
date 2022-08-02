import Foundation

struct Learner: Codable {
    var email: String
    var id: String
    var surname: String
    var name: String
    var authID: String
    var completed: Bool
}

var urlComponents = URLComponents(string: "https://mc3-ws-http.herokuapp.com")!

var decoder = JSONDecoder()
var encoder = JSONEncoder()

urlComponents.path = "/learner"

urlComponents.queryItems = [
    "email": "DEMO_KEY",
].map { URLQueryItem(name: $0.key, value: $0.value) }

func getLearner(_ url: URL) async throws -> Learner? {
    let (data, response) = try await URLSession.shared.data(from: url)
    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode == 200,
       let learner = try? decoder.decode(Learner.self, from: data){
        return learner
    } else { return nil }
}

func update(_ learner: Learner) async throws -> Learner? {
    
    urlComponents.path = "/learner/\(learner.id)"
    
    var updateRequest = URLRequest(url: urlComponents.url!)
    
    updateRequest.httpMethod = "PUT"
    updateRequest.setValue("Bearer \(learner.authID)", forHTTPHeaderField: "Authorization")
    
    updateRequest.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
    updateRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format

    updateRequest.httpBody = try encoder.encode(learner)
    
    let (data, _) = try await URLSession.shared.data(for: updateRequest)
    return try? decoder.decode(Learner.self, from: data)
}

Task {
    do {
        let learner = try await getLearner(urlComponents.url!)
        guard var learner = learner else { return }
        
        print(learner)
        
        learner.completed = true
        
        let updateLearner = try await update(learner)
        
        print(updateLearner)
        
    } catch {
        print(error)
    }
    
    
}

