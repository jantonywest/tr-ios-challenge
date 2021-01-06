//
//  MovieDetails.swift
//  TradeDev
//
//  Created by Jinto Antony on 2021-01-05.
//  Copyright © 2021 JA. All rights reserved.
//

import Foundation

struct MovieDetails: Decodable {
    
//    let id : String?
    let name: String?
    let description: String?
    let notes: String?
//    let rating: String?
    let picture: String?
    let releaseDate: Int?
    enum CodingKeys: String, CodingKey {
//        case id = "id"
        case name = "name"
        case description = "Description"
        case notes = "Notes"
//        case rating = "Rating"
        case picture = "picture"
        case releaseDate = "releaseDate"
    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
////        id = try container.decode(String.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        description = try container.decode(String.self, forKey: .description)
//        notes = try container.decode(String.self, forKey: .notes)
////        rating = try container.decode(String.self, forKey: .rating)
//        picture = try container.decode(String.self, forKey: .picture)
//        releaseDate = try container.decode(Int.self, forKey: .releaseDate)
//    }
    
}
