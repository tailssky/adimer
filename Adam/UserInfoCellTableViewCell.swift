//
//  UserInfoCellTableViewCell.swift
//  Adam
//
//  Created by 周岩峰 on 7/29/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit

class UserInfoCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var mainName: UILabel!
    @IBOutlet weak var subName: UILabel!

    override func awakeFromNib() {
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 175/255, green: 0/255, blue: 33/255, alpha: 1)
        selectedBackgroundView = selectedView
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
