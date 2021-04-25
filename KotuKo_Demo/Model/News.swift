//
//  News.swift
//  KotuKo_Demo
//
//  Created by Ali on 23/04/2021.
//

import Foundation
import SwiftSoup // used for parsing html tag

struct News : Codable {
    let id : Int?
    let title : String?
    let content : String?
    let excerpt : String?
    let url : String?
    let categoria : [String]?
    var date : Date?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case title = "title"
        case content = "content"
        case excerpt = "excerpt"
        case url = "url"
        case categoria = "categoria"
        case date = "date"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(excerpt, forKey: .excerpt)
        try container.encode(url, forKey: .url)
        try container.encode(categoria, forKey: .categoria)
        try container.encode(date, forKey: .date)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        excerpt = try values.decodeIfPresent(String.self, forKey: .excerpt)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        categoria = try values.decodeIfPresent([String].self, forKey: .categoria)
        date = nil
        // Fetching date string and converting to Swift date object
        if let publishedAt = try values.decodeIfPresent(String.self, forKey: .date) {
            let dateFormatter = DateFormatter()
            // date format as per the service response
            dateFormatter.dateFormat = Constants.dateFormat
            date = dateFormatter.date(from:publishedAt)
        }
    }
    
    // helper function to get the image url from html content
    func imageURL() ->  String?{
        do {
            let content : Document = try SwiftSoup.parse(self.content ?? "")
            //return try doc.
            if let imgElement : Element = try content.select("img").first()  {
                let url : String = try imgElement.attr("src")
                return url
            }
            else {
                return nil
            }
        }catch {
            print("error")
            return nil
        }
    }

}

