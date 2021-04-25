//
//  NewsDetailViewController.swift
//  KotuKo_Demo
//
//  Created by Ali on 24/04/2021.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var categoryLabel : UILabel!
    @IBOutlet weak var contentWebView : WKWebView!
    
    //MARK:- Data Members
    var news : News!
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        populateData()
    }
    
    //MARK:- Data Binder
    func populateData() {
        self.categoryLabel.text = news.categoria?.joined(separator: ", ") ?? Constants.emptyLabel
        if let date = news.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.viewDateFormat
            self.dateLabel.text = dateFormatter.string(from: date)
        }
        else {
            self.dateLabel.text = Constants.emptyLabel
        }
        self.titleLabel.text = news.title ?? Constants.emptyLabel
        self.contentWebView.loadHTMLString(news.content ?? "", baseURL: nil)
    }

}
