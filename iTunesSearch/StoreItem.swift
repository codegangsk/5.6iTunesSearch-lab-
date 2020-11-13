//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Sophie Kim on 2020/11/12.
//  Copyright © 2020 Caleb Hicks. All rights reserved.
//

import Foundation

struct StoreItem: Codable {
    var kind: String
    var artist: String
    var name: String
    var trackViewUrl: String
    var artworkUrl: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case artist = "artistName"
        case name = "trackName"
        case trackViewUrl = "trackViewUrl"
        case artworkUrl
        case description
    }

    enum AdditionalKeys: String, CodingKey {
        case longDescription
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        trackViewUrl = try values.decode(String.self, forKey: CodingKeys.trackViewUrl)
        artworkUrl = try values.decode(String.self, forKey: CodingKeys.artworkUrl)
        
        if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
           description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
       }
    }
}

struct StoreItems: Codable{
    let results: [StoreItem]
}
