//
//  NotificationTableViewCell.swift
//  Adam
//
//  Created by 周岩峰 on 8/12/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showMessage: UILabel!
    @IBOutlet weak var showSourceInfo: UILabel!
    @IBOutlet weak var dealButton: UIButton!
    
    weak var delegate: NotificationCellDelegate?
    
    var cellType: Int! //0 = dealed 1 = clubInvatation
    var row: Int!
    var isBtnTapped = false

    override func awakeFromNib() {
        
        dealButton.sizeToFit()
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    @IBAction func dealedBtnTapped() {
      
        cellType = 0
 
        delegate?.notificationCellBtnTapped(self, row: self.row)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

protocol NotificationCellDelegate: class {
    func notificationCellBtnTapped(controller: NotificationTableViewCell, row: Int)
}
