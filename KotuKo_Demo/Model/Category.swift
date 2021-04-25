//
//  Category.swift
//  KotuKo_Demo
//
//  Created by Ali on 24/04/2021.
//

import Foundation

struct Category : Codable {
    
    let id : Int?
    let count : Int?
    let link : String?
    let name : String?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case count = "count"
        case link = "link"
        case name = "name"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(count, forKey: .count)
        try container.encode(link, forKey: .link)
        try container.encode(name, forKey: .name)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}
