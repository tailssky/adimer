//
//  PublishContentCell.swift
//  Adam
//
//  Created by 周岩峰 on 5/24/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit

class PublishContentCell: UITableViewCell {
    
    @IBOutlet weak var userPortrait: UIImageView!
    @IBOutlet weak var userID: UIButton!
    @IBOutlet weak var publishPhoto: UIImageView!
    @IBOutlet weak var publishContentText: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var dishRate: UILabel!
    @IBOutlet weak var cleanessRate: UILabel!
    @IBOutlet weak var priceRate: UILabel!
    @IBOutlet weak var otherRate: UILabel!
    @IBOutlet weak var publisher: UILabel!
    
    @IBOutlet var dishRateImages: UIImageView!
    @IBOutlet var priceRateImages: UIImageView!
    @IBOutlet var cleanRateImages: UIImageView!
    @IBOutlet var otherRateImages: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 175/255, green: 0/255, blue: 33/255, alpha: 1)
        selectedBackgroundView = selectedView
        
        publishPhoto.layer.cornerRadius = 8
        publishPhoto.clipsToBounds = true
        separatorInset = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 0)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForPublishContent (publishContent: Publish) {
        
//        userID.setTitle(String(publishContent.dishName), forState: .Normal)
//        userPortrait.image = UIImage(named: "defaultPortraitImage")
        publishPhoto.image = publishContent.dishPhoto

        
        
        if publishContent.reviewDishRate == 1 {
            dishRateImages.image = UIImage(named: "death")
        } else {
            dishRateImages.image = UIImage(named: "dish20*20")
        }
        if publishContent.reviewCleannessRate == 1 {
            cleanRateImages.image = UIImage(named: "death")
        } else {
            cleanRateImages.image = UIImage(named: "clean20*20")
        }
        if publishContent.reviewPriceRate == 1 {
            priceRateImages.image = UIImage(named: "death")
        } else {
            priceRateImages.image = UIImage(named: "money20*20")
        }
        if publishContent.othersRate == 1 {
            otherRateImages.image = UIImage(named: "death")
        } else {
            otherRateImages.image = UIImage(named: "other20*20")
        }
        
        dishRate.text =
            NSLocalizedString("Dish rate:", comment: "美味：") + "\(publishContent.reviewDishRate)"
        cleanessRate.text = NSLocalizedString("Cleanness rate:", comment: "卫生：") + "\(publishContent.reviewCleannessRate)"
        priceRate.text = NSLocalizedString("Price rate:", comment: "性价比：") + "\(publishContent.reviewPriceRate)"
        otherRate.text = NSLocalizedString("Serves rate:", comment: "服务：") + "\(publishContent.othersRate)"
//        publisher.text = NSLocalizedString("\(publishContent.publisherName!) published", comment: "发表")
        
        publishContentText.text = publishContent.reviewContent
        restaurantName.text = NSLocalizedString("Restaurant name: ", comment: "店名") + "\(publishContent.restaurantName)"
        
        
    }
    
    

}
