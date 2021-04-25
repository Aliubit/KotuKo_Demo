//
//  AFManager.swift
//  KotuKo_Demo
//
//  Created by Ali on 23/04/2021.
//

import Foundation
import Alamofire

// All the endpoints to be used in the app will be here
enum Endpoints : String {
    case getNews = "https://www.policlinicogemelli.it/wp-json/api/news/?page={PAGE}&per_page={PER_PAGE}&categoria={CATEGORY_ID}"
    case getCategories = "https://www.policlinicogemelli.it/wp-json/wp/v2/categorie/"
}

enum ApiParamsValue : String {
    case Page = "{PAGE}"
    case PerPage = "{PER_PAGE}"
    case CategoryId = "{CATEGORY_ID}"
}

// This class is responsible for all network requests
class AFManager {
    
    // Used for fetching news from server
    static func getNews(page : Int , perPage : Int = Constants.defaultBatchSize, filterID : Int? = nil, completion : @escaping ([News]?) -> Void) {
        
        var urlString = Endpoints.getNews.rawValue.replacingOccurrences(of: ApiParamsValue.Page.rawValue, with: "\(page)").replacingOccurrences(of: ApiParamsValue.PerPage.rawValue, with: "\(perPage)")
        if filterID == nil {
            urlString = urlString.replacingOccurrences(of: "&categoria=\(ApiParamsValue.CategoryId.rawValue)", with: "")
        }
        else {
            urlString = urlString.replacingOccurrences(of: ApiParamsValue.CategoryId.rawValue, with: "\(filterID!)")
        }
        AF.request(urlString,method: .get).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let newsList = try decoder.decode([News].self, from: data)
                completion(newsList)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
    
    // Used to fetch categories
    static func getCategories(completion : @escaping ([Category]?) -> Void) {
        let urlString = Endpoints.getCategories.rawValue
        AF.request(urlString,method: .get).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let categoryList = try decoder.decode([Category].self, from: data)
                completion(categoryList)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
    
}
