//
//  GhError.swift
//  Github API
//
//  Created by Andrew Betancourt on 6/15/24.
//

import Foundation
enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidRepo
}
