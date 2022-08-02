//
//  NetworkManager.swift
//  Classroom
//
//  Created by Gianluca Orpello for the Developer Academy on 18/01/22.
//
//


import Foundation

enum HTTPMethods: String {
    case post = "POST"
    case get = "GET"
}

class NetworkManager {
    
    static var urlComponents = URLComponents(string: "https://mc3-ws-http.herokuapp.com/")!
    
    static let jsonDecoder = JSONDecoder()
    static let jsonEncoder = JSONEncoder()
    
    private func getRequest(url: URL, method: HTTPMethods = HTTPMethods.get) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    
    static func getAllLearners() async throws -> [Learner] {
        
        NetworkManager.urlComponents.path = "/classroom"
        
        let (data, response) = try await URLSession.shared.data(from: NetworkManager.urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw LearnerInfoError.creationFailed
              }
        
        let learners = try NetworkManager.jsonDecoder.decode([Learner].self, from: data)
        return learners
        
    }
    
    static func create(_ learner: Learner) async throws -> Learner {
        NetworkManager.urlComponents.path = "/classroom"
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(learner) else {
            print("Error: Trying to convert model to JSON data")
            throw LearnerInfoError.creationFailed
        }
        
        var request = URLRequest(url: NetworkManager.urlComponents.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200,
              let newLearner = try? NetworkManager.jsonDecoder.decode(Learner.self, from: data)
        else {
            throw LearnerInfoError.creationFailed
        }
        
        return newLearner
    }
    
    static func remove(with id: UUID) async throws{
        NetworkManager.urlComponents.path = "/classroom/\(id)"

        var request = URLRequest(url: NetworkManager.urlComponents.url!)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw LearnerInfoError.creationFailed
        }
        
    }
}
