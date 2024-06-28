//
//  Github User.swift
//  Github API
//
//  Created by Andrew Betancourt on 6/15/24.
//

import Foundation
struct GithubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
    let followers: Int
    let following: Int
    let publicRepos: Int
    let publicGists: Int
    var repos: [Repository]?
}
