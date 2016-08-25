//
//  Functions.swift
//  Adam
//
//  Created by 周岩峰 on 6/5/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import Foundation
import Dispatch
import UIKit
import AVOSCloud



func afterDelay (seconds: Double, closure: () -> ()) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), closure)
}

func creatNormalAlert (alertMessage: String) -> UIAlertController {
    let alert = UIAlertController(title: NSLocalizedString("WARNING", comment: "normal alert title"), message: alertMessage, preferredStyle: .Alert)
    let alertActionOK = UIAlertAction(title: NSLocalizedString("OK", comment: "normal alert button OK"), style: .Cancel, handler: nil)
    alert.addAction(alertActionOK)
    
    return alert
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil).first as? UIView
    }
}

extension UIImage {
    func resizedImageWithBounds(bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        let ratio = min(horizontalRatio,verticalRatio)
        let newSzie = CGSize(width: size.width*ratio, height: size.height*ratio)
        UIGraphicsBeginImageContextWithOptions(newSzie, true, 0)
        drawInRect(CGRect(origin: CGPoint.zero, size: newSzie))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
}

extension Array where Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}



func ==(lhs: AVObject, rhs: AVObject) -> Bool {
    if lhs.objectId == rhs.objectId {
        return true
    } else {
        return false
    }
}

extension Array where Element: Equatable {
    var orderedSetValue: Array  {
        return reduce([]){ $0.contains($1) ? $0 : $0 + [$1] }
    }
}




