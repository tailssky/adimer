//
//  User.swift
//  Adam
//
//  Created by 周岩峰 on 7/4/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import Foundation
import AVOSCloud

class User: NSObject {
    
    //requisite property
    var userName: String!
    let password: String!
    var email: String!
    let sessionToken: String?
    var userID: String
    var phoneNumber: String?
    var mobilePhoneVerified: Bool
    
    //optional property
    
    var nickname: String
    var userPortraitImage: UIImage!
    var sex: Int
    
    var userEXP: Int
    var userLevel: Int
    dynamic var clubCreatedNum: Int
    dynamic var clubJoinedNum: Int
    
    //optinoal property about club and publish
    
//    var publishContents = [Publish]()
//    var clubsCreated = [Club]()
//    var clubsJoined = [Club]()
    var avuser: AVUser?
    var userData: UserData!
    
    override init () {
        self.userName = ""
        self.password = ""
        self.email = ""
        self.phoneNumber = ""
        self.mobilePhoneVerified = false
        self.sessionToken = ""
        
        self.userID = ""
        self.nickname = ""
        self.userEXP = 0
        self.userLevel = 0
        self.sex = 0
        self.clubCreatedNum = 0
        self.clubJoinedNum = 0
        
        
        
        self.userPortraitImage = nil
        
        self.userData = nil
    }
    
    init? (avuser: AVUser) {
        if avuser.fetch() {
            self.avuser = avuser
            
            self.userName = avuser.username
            self.password = avuser.password
            self.email = avuser.email
            self.phoneNumber = avuser.mobilePhoneNumber
            self.mobilePhoneVerified = avuser.mobilePhoneVerified
            if let sessionToken1 = avuser.sessionToken{
            self.sessionToken = sessionToken1
            } else {
                self.sessionToken = nil
            }
            
            self.userID = avuser.objectId
            self.nickname = avuser["nickName"] as! String
            self.userEXP = avuser["userEXP"] as! Int
            self.userLevel = avuser["userLevel"] as! Int
            self.sex = avuser["sex"] as! Int
            self.clubCreatedNum = avuser["clubCreatedNum"] as! Int
            self.clubJoinedNum = avuser["clubJoinedNum"] as! Int
            
            
            let avFile = avuser["userPortraitImage"] as! AVFile
            let avUrl = avFile.getThumbnailURLWithScaleToFit(true, width: 100, height: 100)
            let url = NSURL(string: avUrl)
            let nsData = NSData(contentsOfURL: url!)
            userPortraitImage = UIImage(data: nsData!)
            
            self.userData = UserData(owner: avuser)
//            let avClubsCreateds = avuser["clubsCreated"] as! [AVObject]
//            var createdClubs = [Club]()
//            for avClubsCreated in avClubsCreateds {
//                
//                avClubsCreated.fetch()
//                
//                let clubname = avClubsCreated["name"] as! String
//                let clubCreater = avClubsCreated["creater"] as! AVUser
//                let clubJoiners = avClubsCreated["joiner"] as! [AVUser]
//                let newClub = Club(clubCeater: clubCreater, clubName: clubname)
//                newClub.joiner = clubJoiners
//                createdClubs.append(newClub)
//            }
//            
//            self.clubsCreated = createdClubs
            
        } else {
            return nil
        }
    }
    
    //func getCLubSCreatedFromServe (avuser)
    
    
//    init(userName: String, password: String, email: String) {
//        self.userName = userName
//        self.password = password
//        self.email = email
//        
//        self.phoneNumber = ""
//        self.sessionToken = ""
//        self.mobilePhoneVerified = false
//        self.nickname = ""
//        self.sex = 2
//        self.userEXP = 0
//        self.userLevel = 0
//        self.userPortraitImage = UIImage(named: "defaultPortraitImage")
//        self.userID = ""
//
//        self.clubCreatedNum = 0
//        self.clubJoinedNum = 0
//        self.user = nil
//        
//    }
    class func changerAVUserToUserNoAuthority(avuser: AVUser) -> User? {
        if avuser.fetch() {
            let user = User()
            user.userName = avuser.username
//            user.password = avuser.password
            user.email = avuser.email
            user.phoneNumber = avuser.mobilePhoneNumber
            user.mobilePhoneVerified = avuser.mobilePhoneVerified
//            user.sessionToken = avuser.sessionToken
            
            user.userID = avuser.objectId
            user.nickname = avuser["nickName"] as! String
            user.userEXP = avuser["userEXP"] as! Int
            user.userLevel = avuser["userLevel"] as! Int
            user.sex = avuser["sex"] as! Int
            user.clubCreatedNum = avuser["clubCreatedNum"] as! Int
            user.clubJoinedNum = avuser["clubJoinedNum"] as! Int
            
            
            let avFile = avuser["userPortraitImage"] as! AVFile
            let avUrl = avFile.getThumbnailURLWithScaleToFit(true, width: 50, height: 50)
            let url = NSURL(string: avUrl)
            let nsData = NSData(contentsOfURL: url!)
            user.userPortraitImage = UIImage(data: nsData!)
            
//            user.userData = UserData(owner: avuser)
            return user
        } else {
            return nil
        }
    
    }
    
    class func changeUserToAVuserForSever(user: User) -> AVUser {
        let avuser = AVUser(className: "_User", objectId: user.userID)
//        avuser.sessionToken = user.sessionToken
        avuser.objectId = user.userID
        avuser.username = user.userName
//        avuser.password = user.password
        avuser.email = user.email
        avuser.mobilePhoneNumber = user.phoneNumber
         
        return avuser
    }
    
    
    class func dataUserToAVuser (newUserDate: User) -> AVUser {
        let avuser = AVUser()
        avuser.objectId = newUserDate.userID
        avuser.username = newUserDate.userName
        avuser.password = newUserDate.password
        avuser.email = newUserDate.email
        avuser.mobilePhoneNumber = newUserDate.phoneNumber
        avuser.sessionToken = newUserDate.sessionToken
        
    
        var image1 = newUserDate.userPortraitImage
        let image = image1.imageByScalingToSize(CGSize(width: 500, height: 500))
        let imageNSdata = UIImagePNGRepresentation(image)
        let avfile = AVFile(name: "photo.png", data: imageNSdata)
        avuser.setObject(avfile, forKey: "userPortraitImage")
        
        avuser.setObject(newUserDate.userEXP, forKey: "userEXP")
        avuser.setObject(newUserDate.userLevel, forKey: "userLevel")
        avuser.setObject(newUserDate.nickname, forKey: "nickName")
        avuser.setObject(newUserDate.clubCreatedNum, forKey: "clubCreatedNum")
        avuser.setObject(newUserDate.sex, forKey: "sex")
        
        
        return avuser
        
    }
}