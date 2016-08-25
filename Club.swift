//
//  Club.swift
//  Adam
//
//  Created by 周岩峰 on 7/11/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import Foundation
import AVOSCloud

class Club {
    
    var name: String
    var clubImage = UIImage(named: "defaultClubPhoto")
    var creater: AVUser
    var joiners: [AVUser]
    var tag = 0
    var clubID: String!
    var publishs = [Publish]()
    
    init(clubCeater avuser: AVUser, clubName: String, clubImage: UIImage) {
        name = clubName
        creater = avuser
        joiners = [AVUser]()
        self.clubImage = clubImage
    }
    
//    class func getClubFromSeverUseClubName (clubName: String) -> Club? {
//        
//    }
    
    
    class func creatNewClubToSever(newClub: Club) -> Bool {
        let newAVClub = AVObject(className: "Club")
        
        //save club info to serve createred
        
        let avCreater = newClub.creater
        
        newAVClub.setObject(newClub.name, forKey: "name")
        newAVClub.setObject(newClub.creater, forKey: "creater")
        
        newAVClub.addObject(newClub.creater, forKey: "joiner")
        
        let image1 = newClub.clubImage
        let image = image1!.imageByScalingToSize(CGSize(width: 100, height: 100))
        let imageNSdata = UIImagePNGRepresentation(image)
        
        let avfile = AVFile(name: "photo.png", data: imageNSdata)
        newAVClub.setObject(avfile, forKey: "clubImage")
        let avpublishs = [AVObject]()
        newAVClub.setObject(avpublishs, forKey: "publishs")
        
       let succeed = newAVClub.save()
//        WithBlock({succeed, error in
            if succeed {
                print("new club saved")
                
//                let user = User(avuser: avCreater)
//                if let user = user {
////                avCreater.fetch()
////                    avCreater.incrementKey("clubCreatedNum", byAmount: 1)
//                    avCreater.setObject(user.clubJoinedNum + 1, forKey: "clubCreatedNum")

                    let query = AVQuery(className: "_User")
                    let avUser = query.getObjectWithId(avCreater.objectId)
                        if let avUser = avUser {
                        let avUserData = avUser["userData"] as! AVObject
                        avUserData.incrementKey("clubsCreatedNum", byAmount: 1)
                        avUserData.incrementKey("clubsJoinedNum", byAmount: 1)
                        avUserData.addObject(newAVClub, forKey: "clubsCreated")
//                        avUserData.addObject(newAVClub, forKey: "clubsJoined")
                        
                            avUserData.saveEventually({succeed, error in
                                if succeed {
                                print("succeed saved user's club")
                                        }else{
                                    print("\(error)")
                                    }})
                        
                }
//                            saveInBackgroundWithBlock({succeed, error in
//                            if succeed {
//                                print("succeed saved user's club")
//                            }else{
//                                print("\(error)")
//                            }})
//                        }
//                        })
//                    save clubsCreated
//                    query.includeKey("clubsCreated")
//                    var objects = query.findObjects()
//                    if var objects = objects {
//                        objects.append(newAVClub)
//                    } else {
//                        objects = [newAVClub]
//                    }
//                    
//                    avCreater.addObject(newAVClub, forKey: "clubsCreated")
//                    
//                    //save clubsJoined
////                    query.includeKey("clubsJoined")
////                    objects = query.findObjects()
////                    if var objects = objects {
////                        objects.append(newAVClub)
////                    } else {
////                        objects = [newAVClub]
////                    }
//                    avCreater.addObject(newAVClub, forKey: "clubsJoined")
                    
                    
                    
//                }
//                else {
//                    print("get user info error")
//                    return false
//                }
            }else{
                return false
        }
    //})
        return true
    }
    
    class func avClubToClub(avClub: AVObject) -> Club? {
        
        if avClub.fetch() {
            let clubCreater = avClub["creater"] as! AVUser
            let clubName = avClub["name"] as! String
            let club = Club(clubCeater: clubCreater, clubName: clubName, clubImage: UIImage())
            
            let avFile = avClub["clubImage"] as! AVFile
//            club.clubImage = UIImage(named: "defaultViewPhoto")
            let avUrl = avFile.getThumbnailURLWithScaleToFit(true, width: 55, height: 55)
            let url = NSURL(string: avUrl)
            let nsData = NSData(contentsOfURL: url!)
            club.clubImage = UIImage(data: nsData!)
            
            club.clubID = avClub.objectId
            
            let joiners = avClub["joiner"] as! [AVUser]
            
            for avjoiner in joiners {
                    club.joiners.append(avjoiner)
                }
            
            return club
        } else {
            return nil
        }
    }
    
    class func avClubToClubWithoutImage(avClub: AVObject) -> Club? {
        
        if avClub.fetch() {
            let clubCreater = avClub["creater"] as! AVUser
            let clubName = avClub["name"] as! String
            let club = Club(clubCeater: clubCreater, clubName: clubName, clubImage: UIImage())
            
            club.clubImage = nil
            
            club.clubID = avClub.objectId
            
            let joiners = avClub["joiner"] as! [AVUser]
            
            for avjoiner in joiners {
                club.joiners.append(avjoiner)
            }
            
            return club
        } else {
            return nil
        }
    }
    
    class func quitFromClubOnServe (fromClub: Club, leaver: AVUser) {
        let avClub = AVObject(className: "Club", objectId: fromClub.clubID)
        //remove from user
        let userDataQuery = AVQuery(className: "UserData")
        userDataQuery.whereKey("owner", equalTo: leaver)
        let userData = userDataQuery.getFirstObject()
        userData.removeObject(avClub, forKey: "clubsJoined")
        userData.saveInBackground()
        
        userData.incrementKey("clubsJoinedNum", byAmount: -1)
        //leaver.saveInBackground()
        
        //remove from club
        
        avClub.removeObject(leaver, forKey: "joiner")
        avClub.saveInBackground()
    }
}