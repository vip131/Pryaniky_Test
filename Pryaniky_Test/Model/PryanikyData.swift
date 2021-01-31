//
//  PryanikyData.swift
//  Pryaniky_Test
//
//  Created by Admin on 29.01.2021.
//  Copyright © 2021 DmitryChaschin. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct PryanikyData: Codable {
    let data: [Datum]
    let view: [String]
}

// MARK: - Datum
struct Datum: Codable {
    let name: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let text: String?
    let url: String?
    let selectedID: Int?
    let variants: [Variant]?

    enum CodingKeys: String, CodingKey {
        case text, url
        case selectedID = "selectedId"
        case variants
    }
}

// MARK: - Variant
struct Variant: Codable {
    let id: Int
    let text: String
}
