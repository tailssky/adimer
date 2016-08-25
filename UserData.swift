//
//  UserData.swift
//  Adam
//
//  Created by 周岩峰 on 7/23/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import Foundation
import AVOSCloud

class UserData {
    
    var owner: AVUser
    var publishContents = [Publish]()
    var clubsCreated = [Club]()
    var clubsJoined = [Club]()
    var clubsCreatedNum = 0
    var clubsJoinedNum = 0
    
    init() {
        owner = AVUser()
    }
    
    init(owner: AVUser){
        self.owner = owner
        }
    
    func creatNewUserDataToServe () -> String? {
        let newUserData = AVObject(className: "UserData")
        newUserData.setObject(self.owner, forKey: "owner")
        let array = [AVObject]()
        newUserData.setObject(array, forKey: "clubsCreated")
        newUserData.setObject(array, forKey: "clubsJoined")
        newUserData.setObject(array, forKey: "publishContents")
        newUserData.setObject(0, forKey: "clubsCreatedNum")
        newUserData.setObject(0, forKey: "clubsJoinedNum")
        if newUserData.save() {
            return newUserData.objectId
        } else {
            return nil
        }
    }
    
    class func getDataFromServe (dataOwner: AVUser) -> UserData? {
        let userData = UserData(owner: dataOwner)
        if dataOwner.fetch() {
            userData.owner = dataOwner
            let avUserData = dataOwner["userData"] as! AVObject
            if  avUserData.fetch() {
//                userData.clubsCreatedNum = avUserData["clubsCreatedNum"] as! Int
//                userData.clubsJoinedNum = avUserData["clubsJoinedNum"] as! Int
                let createdClubs = avUserData["clubsCreated"] as! [AVObject]
                for createdClub in createdClubs {
                    let newclub = Club.avClubToClub(createdClub)
                    if let newclub = newclub {
                    userData.clubsCreated.append(newclub)
                    }
                }
                
                let joinedClubs = avUserData["clubsJoined"] as! [AVObject]
            //    if joinedClubs != nil {
                for joinedClub in joinedClubs {
                    let newclub = Club.avClubToClub(joinedClub)
                    userData.clubsJoined.append(newclub!)
                    }
                
                userData.clubsCreatedNum = createdClubs.count
                userData.clubsJoinedNum = joinedClubs.count
            //    }
//                let publishs = avUserData["publishContents"] as! [AVObject]
//                for publish in publishs {
//                    let newpublish = Publish.avPublishToPublishWithOutClub(publish)!
//                    userData.publishContents.append(newpublish)
//                        }
                return userData
            } else {
                return nil
            }
        } else {
            return nil
            }
        }
    
    class func getDataFromServeInThreads (dataOwner: AVUser) -> UserData? {
        let userData = UserData(owner: dataOwner)
        if dataOwner.fetch() {
            userData.owner = dataOwner
            let avUserData = dataOwner["userData"] as! AVObject
            if  avUserData.fetch() {
                userData.clubsCreatedNum = avUserData["clubsCreatedNum"] as! Int
                userData.clubsJoinedNum = avUserData["clubsJoinedNum"] as! Int
                let createdClubs = avUserData["clubsCreated"] as! [AVObject]
                let group1 = dispatch_group_create()
                let q_concurrent2 = dispatch_queue_create("my_concurrent_queue2", DISPATCH_QUEUE_CONCURRENT)
                
                for createdClub in createdClubs {
                    dispatch_group_async(group1, q_concurrent2) {
                        let newclub = Club.avClubToClub(createdClub)!
                        userData.clubsCreated.append(newclub)
                    }
                }
                let q_concurrent3 = dispatch_queue_create("my_concurrent_queue3", DISPATCH_QUEUE_CONCURRENT)
                
                let joinedClubs = avUserData["clubsJoined"] as! [AVObject]
                //    if joinedClubs != nil {
                for joinedClub in joinedClubs {
                    dispatch_group_async(group1, q_concurrent2) {
                        
                        let newclub = Club.avClubToClub(joinedClub)!
                        userData.clubsJoined.append(newclub)
                    }
                    
                }
                var done = false
                
                dispatch_group_notify(group1, dispatch_get_main_queue()){
                    print("data All done!!!")
                    done = true
                    
                }
//                var i = 0
//                for i = 0; i <= 10000; i += 1 {
//                    if done {
//                        return userData
//                    }
//                    afterDelay(0.1, closure: {})
//                }
                
                 
                return userData
                //    }
                //                let publishs = avUserData["publishContents"] as! [AVObject]
                //                for publish in publishs {
                //                    let newpublish = Publish.avPublishToPublishWithOutClub(publish)!
                //                    userData.publishContents.append(newpublish)
                //                        }
                
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
