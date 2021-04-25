//
//  Constants.swift
//  KotuKo_Demo
//
//  Created by Ali on 23/04/2021.
//

import Foundation

struct Constants {
    static var defaultBatchSize = 50
    static var dateFormat = "yyyy-MM-dd HH:mm:ss"
    static var viewDateFormat = "HH:mm dd-MM-yy"
    static var emptyLabel = "-"
    static var filterString = "FILTER"
    static var placeholdernews = "icons8-news-50"
}

enum CellsIdentifier : String {
    case NewsListCell = "NewsTableViewCell"
}

enum Segues : String {
    case NewsDetail = "NewsDetail"
}
