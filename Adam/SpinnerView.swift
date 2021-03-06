//
//  SpinnerView.swift
//  Adam
//
//  Created by 周岩峰 on 8/14/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//



//
//  HudView.swift
//  Adam
//
//  Created by 周岩峰 on 6/5/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import Foundation
import UIKit

class SpinnerView: UIView {
    var text = ""
    
    class func spinnerInView(view: UIView, animated: Bool) -> SpinnerView {
        let hudView = SpinnerView(frame: view.bounds)
        hudView.opaque = false
        
        view.addSubview(hudView)
        view.userInteractionEnabled = false
        
        // hudView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        hudView.showAnimated(animated)
        return hudView
    }
    
    
    
    
    override func drawRect(rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect (x: round((bounds.size.width - boxWidth)/2),
                              y: round((bounds.size.height - boxHeight)/2), width: boxWidth, height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        //        if let image = UIImage(named: "Checkmark") {
        //            let imagePoint = CGPoint(x: center.x - round(image.size.width / 2), y: center.y - round(image.size.height / 2) - boxHeight / 8)
        //            image.drawAtPoint(imagePoint)
        //        }
        
        
        let attribs = [NSFontAttributeName: UIFont.systemFontOfSize(16),
                       NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let textSize = text.sizeWithAttributes(attribs)
        
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2), y: center.y - round(textSize.height / 2) + boxHeight / 4)
        
        text.drawAtPoint(textPoint, withAttributes: attribs)
        
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .WhiteLarge
        spinner.center = CGPoint(x: self.center.x, y: self.center.y - round(textSize.height/2))
        spinner.hidesWhenStopped = true
        self.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func showAnimated(animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransformMakeScale(1.3, 1.3)
            //            UIView.animateWithDuration(0.3, animations: {
            //            self.alpha = 1
            //            self.transform = CGAffineTransformIdentity})
            //        }
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                self.alpha = 1
                self.transform = CGAffineTransformIdentity}, completion: nil)}
    }
}

