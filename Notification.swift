//
//  Notification.swift
//  Adam
//
//  Created by 周岩峰 on 7/27/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//
/*notificationType: 0 邀请加入club
1 邀请好友
10 踢出club
11 删除好友
12 离开club
99 一般通知
 */

import Foundation
import AVOSCloud

class Notification {
    var creater: AVUser?
    var receiver: AVUser?
    var detailMessage: String
    var notificationType: Int
    var hasDealed: Bool
    
    var clubName: String?
    var avClub: AVObject?
    
    init (creater: AVUser, receiver: AVUser) {
        self.creater = creater
        self.receiver = receiver
        detailMessage = ""
        notificationType = 0
        hasDealed = false
    }
    
    init () {
        creater = nil
        receiver = nil
        detailMessage = ""
        notificationType = 99
        hasDealed = false
    }
    
    class func createNotificationToServe(club: Club?, carefulCreater creater: AVUser, receiver: User, message: String, notificationType: Int) {
        
        let notification = AVObject(className: "MyNotification")
        
        let avreceiver = AVUser(className: "_User", objectId: receiver.userID)
        notification.setObject(creater, forKey: "creater")
        notification.setObject(avreceiver, forKey: "receiver")
        
        notification.setObject(message, forKey: "detailMessage")
        notification.setObject(false, forKey: "hasDealed")
        
        if let club = club {
            let avClubqurey1 = AVQuery(className: "Club")
            
            avClubqurey1.whereKey("creater", equalTo: club.creater)
            avClubqurey1.whereKey("name", equalTo: club.name)
            
            let avClubs = avClubqurey1.findObjects()
            for avClub in avClubs {
                notification.setObject(avClub, forKey: "club")
            }
        }
        
        notification.setObject(club?.name, forKey: "clubName")
        notification.setObject(notificationType, forKey: "notificationType")
        
        notification.saveEventually({succeed, error in
            if succeed {
                print("Notification created")
            }else{
                print("\(error)")
            }})
    }
    
    class func createNotificationToServe(club: Club?, carefulCreater creater: AVUser, avReceiver: AVUser, message: String, notificationType: Int) {
        
        let notification = AVObject(className: "MyNotification")
        
        notification.setObject(creater, forKey: "creater")
        notification.setObject(avReceiver, forKey: "receiver")
        
        notification.setObject(message, forKey: "detailMessage")
        notification.setObject(false, forKey: "hasDealed")
        
        if let club = club {
            let avClubqurey1 = AVQuery(className: "Club")
            
            avClubqurey1.whereKey("creater", equalTo: club.creater)
            avClubqurey1.whereKey("name", equalTo: club.name)
            
            let avClubs = avClubqurey1.findObjects()
            for avClub in avClubs {
                notification.setObject(avClub, forKey: "club")
            }
        }
        
        notification.setObject(club?.name, forKey: "clubName")
        notification.setObject(notificationType, forKey: "notificationType")
        
        notification.saveEventually({succeed, error in
            if succeed {
                print("Notification created")
            }else{
                print("\(error)")
            }})
    }
    
    class func getNotification (currentUser: AVUser) -> [Notification] {
            //get notifications
            let avNotificationQuery = AVQuery(className: "MyNotification")
            var results = [Notification]()
            avNotificationQuery.whereKey("receiver", equalTo: currentUser)
            avNotificationQuery.whereKey("hasDealed", equalTo: false)
            let avMyNotifications = avNotificationQuery.findObjects()
        if let avMyNotifications = avMyNotifications {
            for avMyNotification in avMyNotifications {
                if avMyNotification.fetch() {
                    let result = Notification()
                    result.creater = avMyNotification["creater"] as? AVUser
                    result.receiver = avMyNotification["receiver"] as? AVUser
                    result.detailMessage = avMyNotification["detailMessage"] as! String
                    result.hasDealed = avMyNotification["hasDealed"] as! Bool
                    result.notificationType = avMyNotification["notificationType"] as! Int
                    
                    let avClub = avMyNotification["club"] as! AVObject
                    result.avClub = avClub
                    
                    result.clubName = avMyNotification["clubName"] as? String
                    
                    results.append(result)
                    print("get notification")
                    }
                }
            }
            return results
        }
   

}