//
//  Repository.swift
//  Github API
//
//  Created by Andrew Betancourt on 6/17/24.
//

import Foundation
struct Repository: Codable, Identifiable, Hashable {
    let name: String
    let id: Int
}
