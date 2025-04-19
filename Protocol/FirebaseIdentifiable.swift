//
//  FirebaseIdentifiable.swift
//  WellnexApp
//
//  Created by MacBook on 19.04.2025.
//

// Common feature of data models
protocol FirebaseIdentifiable: Hashable, Codable {
    var id: String { get set }
}
