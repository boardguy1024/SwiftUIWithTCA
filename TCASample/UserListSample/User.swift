//
//  User.swift
//  TCASample
//
//  Created by パク on 2023/04/16.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
}
