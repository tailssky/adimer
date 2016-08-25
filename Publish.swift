//
//  Publish.swift
//  Adam
//
//  Created by 周岩峰 on 7/11/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import Foundation
import AVOSCloud
import CoreLocation
import MapKit
import Contacts

class Publish: NSObject {
    
    
    
    var publisher: AVUser!
    
    var restaurantName: String
    var rstLocation: CLLocation
    
    var dishName: String
    var dishPhoto: UIImage
    var reviewContent: String
    var reviewDishRate: Int
    var reviewPriceRate: Int
    var reviewCleannessRate: Int
    var othersRate: Int
    
    var publishContentBelikedNum: Int
    var publishContentBeReadedNum: Int
    
    var isAD: Bool
    
    var publishID: String!
    
    var publishedToClubs: [Club]!
    
    var publishTime: NSDate?
    var publisherName: String?
    
    var addressDictionary: [String: AnyObject] {
        return [CNPostalAddressStreetKey: restaurantName]
    }
    
//    var comment = []
    
    init(publisher: AVUser) {
        self.publisher = publisher
        restaurantName = ""
        rstLocation = CLLocation()
        
        dishName = ""
        dishPhoto = UIImage(named: "defaultDishPhoto")!
        reviewContent = ""
        reviewDishRate = 2
        reviewPriceRate = 2
        reviewCleannessRate = 2
        othersRate = 2
        
        publishContentBelikedNum = 0
        publishContentBeReadedNum = 0
        
        isAD = false
        
        publishedToClubs = [Club]()
    }
    
     class func avPublishToPublishWithOutClub (avPublish: AVObject) -> Publish? {
        if avPublish.fetch() {
            
            let publishOwner = avPublish["publisher"] as! AVUser
            let publish = Publish(publisher: publishOwner)
            publish.restaurantName = avPublish["restaurantName"] as! String
            
            let avGeoPoint = avPublish["rstLocation"] as! AVGeoPoint
            
            let s = avGeoPoint.latitude
            let e = avGeoPoint.longitude
            
            publish.rstLocation = CLLocation(latitude: s, longitude: e)
            
            publish.dishName = avPublish["dishName"] as! String
            
            let avFile = avPublish["defaultDishPhoto"] as! AVFile
            let avUrl = avFile.getThumbnailURLWithScaleToFit(true, width: 80, height: 60)
            let url = NSURL(string: avUrl)
            let nsData = NSData(contentsOfURL: url!)
            publish.dishPhoto = UIImage(data: nsData!)!
            
            publish.reviewContent = avPublish["reviewContent"] as! String
            publish.reviewDishRate = avPublish["reviewDishRate"] as! Int
            publish.reviewPriceRate = avPublish["reviewPriceRate"] as! Int
            publish.reviewCleannessRate = avPublish["reviewCleannessRate"] as! Int
            publish.othersRate = avPublish["othersRate"] as! Int
            
            publish.publishContentBelikedNum = avPublish["publishContentBelikedNum"] as! Int
            publish.publishContentBeReadedNum = avPublish["publishContentBeReadedNum"] as! Int
            
            publish.isAD = avPublish["isAD"] as! Bool
            publish.publishTime = avPublish.createdAt
            publish.publisherName = avPublish["publisherName"] as? String
            
            publish.publishID = avPublish.objectId
            
            let avPublishedClubs = avPublish["publishedToClubs"] as! [AVObject]
            for avClub in avPublishedClubs {
                let newclub = Club.avClubToClubWithoutImage(avClub)
                if let newclub = newclub {
                publish.publishedToClubs.append(newclub)
                }
            }
            
            return publish
        } else {
            return nil
        }
    }
    
    class func avPublishToPublishInBackGround (avPublish: AVObject) -> Publish? {
            var publish = Publish(publisher: AVUser())
         avPublish.fetchInBackgroundWithBlock({ avPublish, error in
            
            let publishOwner = avPublish["publisher"] as! AVUser
             publish = Publish(publisher: publishOwner)
            publish.restaurantName = avPublish["restaurantName"] as! String
            
            let avGeoPoint = avPublish["rstLocation"] as! AVGeoPoint
            
            let s = avGeoPoint.latitude
            let e = avGeoPoint.longitude
            
            publish.rstLocation = CLLocation(latitude: s, longitude: e)
            
            publish.dishName = avPublish["dishName"] as! String
            
            let avFile = avPublish["defaultDishPhoto"] as! AVFile
            let avUrl = avFile.getThumbnailURLWithScaleToFit(true, width: 240, height: 180)
            let url = NSURL(string: avUrl)
            let nsData = NSData(contentsOfURL: url!)
            publish.dishPhoto = UIImage(data: nsData!)!
            
            publish.reviewContent = avPublish["reviewContent"] as! String
            publish.reviewDishRate = avPublish["reviewDishRate"] as! Int
            publish.reviewPriceRate = avPublish["reviewPriceRate"] as! Int
            publish.reviewCleannessRate = avPublish["reviewCleannessRate"] as! Int
            publish.othersRate = avPublish["othersRate"] as! Int
            
            publish.publishContentBelikedNum = avPublish["publishContentBelikedNum"] as! Int
            publish.publishContentBeReadedNum = avPublish["publishContentBeReadedNum"] as! Int
            
            publish.isAD = avPublish["isAD"] as! Bool
            
            publish.publishID = avPublish.objectId
            
            publish.publishTime = avPublish.createdAt
            publish.publisherName = avPublish["publisherName"] as! String
            
            let avPublishedClubs = avPublish["publishedToClubs"] as! [AVObject]
            for avClub in avPublishedClubs {
                let newclub = Club.avClubToClubWithoutImage(avClub)
                if let newclub = newclub {
                    publish.publishedToClubs.append(newclub)
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue()){
                
            print("getPublishSucceed")}
            
        })
        return publish
//        return nil
    }
    
    func savePublishToServe (publisherName: String) {
        let avPublish = AVObject(className: "Publish")
        
        avPublish.setObject(publisher, forKey: "publisher")
        avPublish.setObject(restaurantName, forKey: "restaurantName")
        
//       let s = rstLocation.coordinate.latitude
        
//        let avGeoPoint = AVGeoPoint(latitude: rstLocation.coordinate.latitude, longitude: rstLocation.coordinate.longitude)
        let avGeoPoint = AVGeoPoint(location: rstLocation)
        avPublish.setObject(avGeoPoint, forKey: "rstLocation")
        
        avPublish.setObject(dishName, forKey: "dishName")
        
        var image1 = dishPhoto
        
        let image = image1.imageByScalingToSize(CGSize(width: 800, height: 600))
        let imageNSdata = UIImagePNGRepresentation(image)
        
        let avfile = AVFile(name: "photo.png", data: imageNSdata)
        avPublish.setObject(avfile, forKey: "defaultDishPhoto")
        
        avPublish.setObject(reviewContent, forKey: "reviewContent")
        avPublish.setObject(reviewDishRate, forKey: "reviewDishRate")
        avPublish.setObject(reviewPriceRate, forKey: "reviewPriceRate")
        avPublish.setObject(reviewCleannessRate, forKey: "reviewCleannessRate")
        avPublish.setObject(othersRate, forKey: "othersRate")
        avPublish.setObject(publishContentBelikedNum, forKey: "publishContentBelikedNum")
        avPublish.setObject(publishContentBeReadedNum, forKey: "publishContentBeReadedNum")
        
        avPublish.setObject(isAD, forKey: "isAD")
        avPublish.setObject(publisherName, forKey: "publisherName")
        
        var avClubs = [AVObject]()
        
        for club in publishedToClubs {
            let avClub = AVObject(className: "Club", objectId: club.clubID)
            avClubs.append(avClub)
        }
        
        avPublish.addObjectsFromArray(avClubs, forKey: "publishedToClubs")
        
//        avPublish.saveEventually({succeed, error in
//            if succeed {
//                print("Publish saved")
//                
//            }else {
//                print("\(error)")
//            }})
        
        if avPublish.save() {
            print("Publish saved")
            for club in self.publishedToClubs {
                let avClub = AVObject(className: "Club", objectId: club.clubID)
                avClub.addObject(avPublish, forKey: "publishs")
                avClub.saveInBackgroundWithBlock({_ , error in
                    if error != nil {
                        print("\(error)")
                    }else {
                        print("club's publishs saved")
                    }})
            }
        }
    }
}
