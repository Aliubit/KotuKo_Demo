//
//  NewsTableViewCell.swift
//  KotuKo_Demo
//
//  Created by Ali on 24/04/2021.
//

import UIKit
import Kingfisher // Used for displaying image from url

class NewsTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var imgContainer : UIView!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var categoryLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var titleLbl : UILabel!
    
    //MARK:- Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- Data Binder
    func updateCell(news : News) {
        
        self.categoryLabel.text = news.categoria?.joined(separator: ", ") ?? Constants.emptyLabel
        if let date = news.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.viewDateFormat
            self.dateLabel.text = dateFormatter.string(from: date)
        }
        else {
            self.dateLabel.text = Constants.emptyLabel
        }
        self.titleLbl.text = news.title ?? Constants.emptyLabel
        
        self.imgContainer.isHidden = true
        // Check if image exists
        if let imageUrl = news.imageURL() {
            self.imgContainer.isHidden = false
            // Kingfisher code to fetch image from url
            let url = URL(string: imageUrl)
            let processor = DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
                         |> RoundCornerImageProcessor(cornerRadius: 0)
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(
                with: url,
                placeholder: UIImage(named: Constants.placeholdernews),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
            }
        }
        else { // Incase of no image hide the image view
            self.imgContainer.isHidden = true
        }
    }

}
