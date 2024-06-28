//
//  GithubModel.swift
//  Github API
//
//  Created by Andrew Betancourt on 6/16/24.
//

import Foundation

class GithubModel: ObservableObject {
    
    private var page = 0
    private let pageLimit = 30
    
    func reset() {
        page = 0
    }
    
    func getUser(username: String) async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/\(username)"
        guard let url = URL(string: endpoint) else {throw GHError.invalidURL}
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            var gitUser = try decoder.decode(GithubUser.self, from: data)
            gitUser.repos = try await getRepo(username: username)
            
            return gitUser
            
        } catch{
            throw GHError.invalidData
        }
    }

    func getRepo(username: String) async throws -> [Repository] {
        page += 1
        let endpoint = "https://api.github.com/users/\(username)/repos?per_page=\(pageLimit)&page=\(page)"
        guard let url = URL(string: endpoint) else {throw GHError.invalidURL}
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
    
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Repository].self, from: data)
        } catch{
            throw GHError.invalidRepo
        }
    }
}
