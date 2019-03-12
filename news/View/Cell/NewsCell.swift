//
//  NewsCell.swift
//  almajalNews
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.

import UIKit
import Haneke
class NewsCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var newsImgview: UIImageView!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsDescLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var newsObj_: SingleNewsObject? {
        didSet {
            guard let newsObj = newsObj_ else { return }
            
   
            self.newsImgview.image = nil
            self.newsDescLbl.text = ""
            self.newsTitleLbl.text = ""
            self.authorNameLbl.text = ""
            
            if let mainImg = newsObj.urlToImage {
                if let mainImageURL = URL(string: mainImg){
                self.newsImgview.hnk_setImageFromURL(mainImageURL)
                }
      
            }
            if let desc = newsObj.newsDescription {
                self.newsDescLbl.text = desc
            }
            
            if let desc = newsObj.newsTitle {
                self.newsTitleLbl.text = desc
            }
            if let author = newsObj.author {
                self.authorNameLbl.text = author
            }
        }
    }
    
    
    
}
