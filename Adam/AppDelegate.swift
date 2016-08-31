//
//  AppDelegate.swift
//  Adam
//
//  Created by 周岩峰 on 5/24/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import CoreData
import AVOSCloud
import AVOSCloudIM
import AudioToolbox


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var userInfo: User?
    var notifications: [Notification]?
    var needRefreshData: Bool! = true {
        didSet{
            
        }
    }
    var comparePublishs = [Publish]()
    
    var soundID = kSystemSoundID_Vibrate
    
    var userIsLogOut: Bool!
    
    var numOfgetdata = 5
    
// var tabbarcontroller: UITabBarController {
//        return window!.rootViewController as! tabBarViewController}
    
    func customizeAppearance() {
        let barTintColor = UIColor(red: 175/255, green: 0/255, blue: 33/255, alpha: 1)
        UISearchBar.appearance().barTintColor = barTintColor
        
        UINavigationBar.appearance().barTintColor = barTintColor
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
//        UINavigationBar.appearance().colo
        
        if let barFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22.0)
        {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:barFont]
        }
        
//        UIApplication.sharedApplication().setStatusBarStyle
//        UITabBar.appearance().barTintColor = barTintColor
//        UIButton.appearance().tintColor = barTintColor
        
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
//        UIToolbar.appearance().barTintColor = UIColor(red: 237.0/255.0, green: 240.0/255.0, blue: 243.0/255.0, alpha: 0.5)
        
        
        UITabBar.appearance().tintColor = barTintColor
           UITabBar.appearance().barTintColor = UIColor.blackColor()
        
//        window!.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        AVOSCloud.setApplicationId("akbvIchJFE68y4fsl1LjgkP0-gzGzoHsz", clientKey: "0uNvFNWxqe1Gg5qQxgioUoGb")
        customizeAppearance()
        
        if AVUser.currentUser() == nil {
            userIsLogOut = true
        } else {
            userIsLogOut = false
        }
//        getAndInjectUserData()
//        getAndInjectNotification()
//        getAndInjectPublishs()
//        
//        let tabbarcontroller = window!.rootViewController as! UITabBarController
//        
//        if let viewControllers = tabbarcontroller.viewControllers {
//            let navigationViewController = viewControllers[0] as! UINavigationController
//            let mainViewController = navigationViewController.viewControllers[0] as! MainTableViewController
//            mainViewController.managedObjectContext = managedObjectContext
//            
//            
//        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        if !userIsLogOut! {
                let  tabbarcontroller = window?.rootViewController as! tabBarViewController
                if let viewControllers = tabbarcontroller.viewControllers {
                    let navigationViewController = viewControllers[0] as! UINavigationController
                    let mainViewController = navigationViewController.viewControllers[0] as! MainTableViewController
                    mainViewController.showNavSpinner()
                    getPublishInMultipleThreads()
                    getAndInjectNotification()
                    
                }
        }
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        
//        let  tabbarcontroller = window?.rootViewController as! tabBarViewController
//        if let viewControllers = tabbarcontroller.viewControllers {
//            var navigationViewController = viewControllers[0] as! UINavigationController
//            let mainViewController = navigationViewController.viewControllers[0] as! MainTableViewController
//            mainViewController.showNavSpinner()
//            getPublishInMultipleThreads()
//            
//        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - get data from sever
    
//    func getUserInfo () {
//        let avCurrentUser = AVUser.currentUser()
//        if let avCurrentUser = avCurrentUser {
//        //get userInfo
//            userInfo = User.init(avuser: avCurrentUser)
////            let userData = UserData.getDataFromServeInThreads(avCurrentUser)
//            
//            let dataOwner = avCurrentUser
//            let userData = UserData(owner: dataOwner)
//            if dataOwner.fetch() {
//                userData.owner = dataOwner
//                let avUserData = dataOwner["userData"] as! AVObject
//                if  avUserData.fetch() {
//                    userData.clubsCreatedNum = avUserData["clubsCreatedNum"] as! Int
//                    userData.clubsJoinedNum = avUserData["clubsJoinedNum"] as! Int
//                    let createdClubs = avUserData["clubsCreated"] as! [AVObject]
//                    let group1 = dispatch_group_create()
//                    let q_concurrent2 = dispatch_queue_create("my_concurrent_queue2", DISPATCH_QUEUE_CONCURRENT)
//                    
//                    for createdClub in createdClubs {
//                        dispatch_group_async(group1, q_concurrent2) {
//                            let newclub = Club.avClubToClub(createdClub)!
//                            userData.clubsCreated.append(newclub)
//                        }
//                    }
//                    
//                    let joinedClubs = avUserData["clubsJoined"] as! [AVObject]
//                    //    if joinedClubs != nil {
//                    for joinedClub in joinedClubs {
//                        dispatch_group_async(group1, q_concurrent2) {
//                            
//                            let newclub = Club.avClubToClub(joinedClub)!
//                            userData.clubsJoined.append(newclub)
//                        }
//                        
//                    }
//                    
//                    
//                    dispatch_group_notify(group1, dispatch_get_main_queue()){
//                        print("data All done!!!")
//                        
//                        self.userInfo?.userData = userData
//                        self.getAndInjectUserData()
//                    }
//                }
//            
//                }
////               guard userData != nil else {
////                getUserInfo()
////                return
////            }
//            
//        }
//    }
    
    func getUserInfo () {
        let avCurrentUser = AVUser.currentUser()
        if let avCurrentUser = avCurrentUser {
            //get userInfo
            userInfo = User.init(avuser: avCurrentUser)
            let userData = UserData.getDataFromServe(avCurrentUser)
            self.userInfo?.userData = userData
            
                        
            
            guard self.userInfo?.userData != nil else {
            numOfgetdata -= 1
            afterDelay(0.5,closure: {})
                if numOfgetdata == 0 {
                  numOfgetdata == 5
                    
                    let alterMessage = NSLocalizedString("Couldn't get data,please check your network.", comment: "alert")
                    let alert = creatNormalAlert(alterMessage)
                    let  tabbarcontroller = window?.rootViewController as! tabBarViewController
                    if let viewControllers = tabbarcontroller.viewControllers {
                        let navigationViewController = viewControllers[0] as! UINavigationController
                        let mainViewController = navigationViewController.viewControllers[0] as! MainTableViewController
                        mainViewController.presentViewController(alert, animated: true, completion: nil)}
                    return
                }
            getUserInfo()
            return
            }
            
            
            self.getAndInjectUserData()

        }
    }
    
    func getAndInjectUserData () {
        if userInfo == nil {
            getUserInfo()
            if AVUser.currentUser() == nil {
                return
            }
        }
        let  tabbarcontroller = window?.rootViewController as! tabBarViewController
            //inject userInfo
        if userInfo != nil && userInfo?.userData != nil {
            if let viewControllers = tabbarcontroller.viewControllers {
                var navigationViewController = viewControllers[0] as! UINavigationController
                let mainViewController = navigationViewController.viewControllers[0] as! MainTableViewController
                mainViewController.userInfo = userInfo
                mainViewController.userIsLogout = userIsLogOut

                navigationViewController = viewControllers[1] as! UINavigationController
                let mapViewController = navigationViewController.viewControllers[0] as! MapViewController
                mapViewController.currentUser = userInfo
                mapViewController.joinedClub = userInfo!.userData.clubsJoined + userInfo!.userData.clubsCreated
                if mapViewController.needfresh != nil {
                    mapViewController.needfresh = !mapViewController.needfresh}
                
                navigationViewController = viewControllers[2] as! UINavigationController
                let userInfoViewController = navigationViewController.viewControllers[0] as! UserInfoTableViewController
                userInfoViewController.userInfo = userInfo
                userInfoViewController.needRefresh = !userInfoViewController.needRefresh
                userInfoViewController.userIsLogOut = userIsLogOut
                userInfoViewController.tableView.reloadData()
        }
    }
    }
    
//    func getAndInjectNotification () {
//        let avCurrentUser = AVUser.currentUser()
//        if avCurrentUser != nil {
////        self.notifications = Notification.getNotification(avCurrentUser)
//            let currentUser = avCurrentUser
//            let avNotificationQuery = AVQuery(className: "MyNotification")
//            var results = [Notification]()
//            avNotificationQuery.whereKey("receiver", equalTo: currentUser)
//            avNotificationQuery.whereKey("hasDealed", equalTo: false)
//            let avMyNotifications = avNotificationQuery.findObjects()
//            let group2 = dispatch_group_create()
//            let q_concurrent3 = dispatch_queue_create("my_concurrent_queue3", DISPATCH_QUEUE_CONCURRENT)
//            
//            if let avMyNotifications = avMyNotifications {
//                for avMyNotification in avMyNotifications {
//                    dispatch_group_async(group2, q_concurrent3) {
//                    if avMyNotification.fetch() {
//                        let result = Notification()
//                        result.creater = avMyNotification["creater"] as? AVUser
//                        result.receiver = avMyNotification["receiver"] as? AVUser
//                        result.detailMessage = avMyNotification["detailMessage"] as! String
//                        result.hasDealed = avMyNotification["hasDealed"] as! Bool
//                        result.notificationType = avMyNotification["notificationType"] as! Int
//                        
//                        let avClub = avMyNotification["club"] as! AVObject
//                        result.avClub = avClub
//                        
//                        result.clubName = avMyNotification["clubName"] as? String
//                        
//                        results.append(result)
//                        print("get notification")
//                        }
//                    }
//                }
//            }
// 
//            
//            dispatch_group_notify(group2, dispatch_get_main_queue()){
//                print("notification All done!!!")
//                let tabbarcontroller = self.window!.rootViewController as! tabBarViewController
//                tabbarcontroller.notificationNum = self.notifications?.count
//                tabbarcontroller.viewDidLoad()
//                
//                if let viewControllers = tabbarcontroller.viewControllers {
//                    var navigationViewController = viewControllers[0] as! UINavigationController
//                    let mainViewController = navigationViewController.viewControllers[0] as! MainTableViewController
//                    //            mainViewController.userInfo = userInfo
//                    
//                    navigationViewController = viewControllers[2] as! UINavigationController
//                    let userInfoViewController = navigationViewController.viewControllers[0] as! UserInfoTableViewController
//                    userInfoViewController.myNotifications = self.notifications
//                    userInfoViewController.needRefresh = !userInfoViewController.needRefresh
//                    
//                }
//            }
//
//                
//            }
//            
//            }
    
    func getAndInjectNotification () {
        let avCurrentUser = AVUser.currentUser()
        if avCurrentUser != nil {
                    self.notifications = Notification.getNotification(avCurrentUser)
            
            
            let  tabbarcontroller = window?.rootViewController as! tabBarViewController
            
                tabbarcontroller.notificationNum = self.notifications?.count
                tabbarcontroller.viewDidLoad()
                
                if let viewControllers = tabbarcontroller.viewControllers {
                    var navigationViewController = viewControllers[0] as! UINavigationController
//                    let mainViewController = navigationViewController.viewControllers[0] as! MainTableViewController
                    //            mainViewController.userInfo = userInfo
                    
                    navigationViewController = viewControllers[2] as! UINavigationController
                    let userInfoViewController = navigationViewController.viewControllers[0] as! UserInfoTableViewController
                    userInfoViewController.myNotifications = self.notifications
                    userInfoViewController.needRefresh = !userInfoViewController.needRefresh
                    
                
            }
            
            
        }
        
    }
    
    func getPublishInMultipleThreads () {
        var publishs = [Publish]()
        if let userInfo = userInfo {
        let avPublishes = dealWithPublishs(userInfo)
        let group = dispatch_group_create()
        let q_concurrent = dispatch_queue_create("my_concurrent_queue1", DISPATCH_QUEUE_CONCURRENT)
//        let q_concurrent = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
            for avPublish in avPublishes {
            dispatch_group_async(group, q_concurrent) {
            let publish = Publish.avPublishToPublishWithOutClub(avPublish)
                           if let publish = publish {
                               publishs.append(publish)
                            print("-publish Get----")}
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()){
        print("All done!!!")
            
            if self.comparePublishs.count != publishs.count {
                self.play()}
            self.comparePublishs = publishs
         let  newpublishs = publishs.sort({(publish1: Publish, publish2: Publish) -> Bool in
               let result = publish1.publishTime!.compare(publish2.publishTime!)
                switch result {
                case .OrderedAscending:
                    return false
                case .OrderedDescending:
                    return true
                default :
                    return false
                }
            })
            
            publishs = newpublishs
            
            let  tabbarcontroller = self.window?.rootViewController as! tabBarViewController
            if let viewControllers = tabbarcontroller.viewControllers {
                var navigationViewController = viewControllers[0] as! UINavigationController
                let mainViewController = navigationViewController.viewControllers[0] as! MainTableViewController
                mainViewController.refreshControl?.endRefreshing()
                mainViewController.mainNavigationItem.titleView = nil
                mainViewController.publishsToShow = publishs
                mainViewController.tableView.reloadData()
                
                 navigationViewController = viewControllers[1] as! UINavigationController
                let mapViewController = navigationViewController.viewControllers[0] as! MapViewController
                mapViewController.currentUser = self.userInfo
                mapViewController.publishs = publishs
                mapViewController.joinedClub = self.userInfo!.userData.clubsCreated + self.userInfo!.userData.clubsJoined
            }}
//        for avPublish in avPbulishs {
//            dispatch_async(q_concurrent, {let publish = Publish.avPublishToPublishWithOutClub(avPublish)
//                if let publish = publish {
//                    publishs.append(publish)
//                print("-publish Get----")}})
//        }
        }
        
    }
    

    
    func getAndInjectPublishs() {
        var publishs = [Publish]()
        if let userInfo = userInfo {
        let avPbulishs = dealWithPublishs(userInfo)
        for avPublish in avPbulishs {
            let publish = Publish.avPublishToPublishInBackGround(avPublish)
            if let publish = publish {
            publishs.append(publish)
            }
        }
        
        let  tabbarcontroller = window?.rootViewController as! tabBarViewController
        
        if let viewControllers = tabbarcontroller.viewControllers {
            let navigationViewController = viewControllers[1] as! UINavigationController
            let mapViewController = navigationViewController.viewControllers[0] as! MapViewController
            mapViewController.currentUser = userInfo
            mapViewController.publishs = publishs
            mapViewController.joinedClub = userInfo.userData.clubsCreated + userInfo.userData.clubsJoined
        }
        }

    }
    
    func dealWithPublishs (user: User) -> [AVObject] {
        let clubs = user.userData.clubsCreated + user.userData.clubsJoined
        var tempAvPublishs = [AVObject]()
        var avPublishs = [AVObject]()
        for club in clubs {
            let avClub = AVObject(className: "Club", objectId: club.clubID)
            
           if  avClub.fetch() {
            let avPublishs = avClub["publishs"] as! [AVObject]
                tempAvPublishs += avPublishs
            }
        }
        
        avPublishs = tempAvPublishs.orderedSetValue
        
//        let avPss = avPublishs.split(5, allowEmptySlices: false, isSeparator: {_ in return false})
//        for i in 0..<avPss.count {
//            let avp = avPss[i] as! [AVObject]
//        }
        return avPublishs
        
    }
    
    func play () {
        AudioServicesPlaySystemSound(soundID)
    }
    
        //MARK: - Coredata
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")
            else { fatalError( "Could not find data model in app bundle")
        }
        print (modelURL)
        guard let model = NSManagedObjectModel(contentsOfURL: modelURL)
            else {
                fatalError("Error initializing model from: \(modelURL)")
        }
        let urls = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory, inDomains: .UserDomainMask)
        let documentsDirectory = urls[0]
        let storeURL = documentsDirectory.URLByAppendingPathComponent("DataStore.sqlite")
        do {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                                                       configuration: nil, URL: storeURL, options: nil)
            let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            print(storeURL)
            return context }
        catch {
            fatalError("Error adding persistent store at \(storeURL): \(error)") }
    }()
    
    
    


}

