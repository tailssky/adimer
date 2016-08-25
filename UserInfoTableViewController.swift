//
//  UserInfoTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 7/12/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class UserInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var userPortrait: UIImageView!   
    @IBOutlet weak var userAccountName: UILabel!
    @IBOutlet weak var userNickName: UILabel!

    @IBOutlet weak var createdClubName: UILabel!
    @IBOutlet weak var createdClub1Image: UIImageView!
    @IBOutlet weak var createdClub1Name: UILabel!
    @IBOutlet weak var createdClub2Image: UIImageView!
    @IBOutlet weak var createdClub2Name: UILabel!
    @IBOutlet weak var createdClub3Image: UIImageView!
    @IBOutlet weak var createdClub3Name: UILabel!
    
    @IBOutlet weak var joinedClub1Image: UIImageView!
    @IBOutlet weak var joinedClub1Name: UILabel!
    @IBOutlet weak var joinedClub2Image: UIImageView!
    @IBOutlet weak var joinedClub2Name: UILabel!
    
    @IBOutlet weak var notificationBadge: UIImageView!
    
    @IBOutlet weak var testBtn: UIButton!
    
    var userIsLogOut = false
    
//    @IBOutlet weak var userCreatedClub1Label: UILabel!
 //   @IBOutlet weak var toCreatClub1Btn: UIButton!
//    @IBOutlet weak var 
    
    var userInfo: User? {
        didSet{
            
        }
    }
    
    var needRefresh: Bool! = true{
        didSet {
           print("#######view has refreshed######")
//            self.tableView.reloadData()
        }
    }
    
    var createdNewClub: Club?
    var myNotifications: [Notification]?{
        didSet{
            showUserBasicInfo()
        }
    }
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = User()
        userInfo?.userData = UserData()
        
        testBtn.hidden = true
       
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoTableViewController.reloadDataAndreflesh), name: "needRefresh", object: nil)

        showUserBasicInfo()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if userIsLogOut {
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appdelegate.userIsLogOut = userIsLogOut
            if let signInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInView") as? SignInViewController  {
                self.tabBarController?.presentViewController(signInViewController, animated: true, completion: nil)
            }
        }
//        showUserBasicInfo()
    }
    


    @IBAction func temp2() {
//        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let userdata = appdelegate.userData
  //      print("\(userdata?.email)")
//        if userInfo != nil {
//            creatNewClubForThisAccount("testClub")
//        }
//        self.userInfo?.clubCreatedNum += 1
//        let avuser = userInfo!.changeUserToAVuserForSever()
//        let newUserData = UserData(owner: avuser)
//        let s = newUserData.creatNewUserDataToServe()
//        let avuser = AVUser(className: "_User", objectId: "5794a9df0a2b580061bbb2c1")
//        avuser.fetchWithKeys(["sex","das"])
//        let c = avuser["sex"] as! Int
//        let b = avuser["userEXP"] as! Int
        
//       let test =  getMyNotification(userInfo!)
//        print("\(test.count)")
 //       creatNewClubForThisAccount("testClub2")
        
//        tableView.reloadData()
//        let  avUser = AVUser.currentUser()
//        avUser.incrementKey("clubCreatedNum", byAmount: 1)
//        avUser.save()
        
//        let s = User.changeUserToAVuserForSever(userInfo!)
//        if let _ = s as? Equatable {
//            let i = true
//        } else {
//            let i = false
//        }
        
//        let s = AVObject(className: "Club", objectId: "123") as AVObject
//        let s1 = AVObject(className: "Club", objectId: "123") as AVObject
//        let s2 = AVObject(className: "Club1", objectId: "123") as AVObject
//        let s3 = AVObject(className: "Club", objectId: "122") as AVObject
//        let s4 = AVObject(className: "Club", objectId: "123") as AVObject
//        var ss = [s,s1,s2,s3,s4]
////        var ss = [AVObject]()
//        
//        ss = ss.orderedSetValue
//        
        tableView.reloadData()
        
    }

    
    func showUserBasicInfo() {
        
        if let userT = userInfo {
            userPortrait.image = userT.userPortraitImage
            userAccountName.text = NSLocalizedString("User name:", comment: "")+userT.userName
            if userT.nickname == "" {
                userNickName.text = NSLocalizedString("Nickname:", comment: "")+NSLocalizedString("Not set", comment: "未设置")
            } else {
                userNickName.text = NSLocalizedString("Nickname:", comment: "")+userT.nickname
            }
            
            if let mynotifications = myNotifications {
                if mynotifications.count >= 1 {
                
                notificationBadge.showBadgeWithStyle(.Number, value: mynotifications.count, animationType: .Scale)
                notificationBadge.badgeBgColor = UIColor(red: 175/255, green: 0/255, blue: 33/255, alpha: 1)
                                //
                } else {
                    notificationBadge.clearBadge()
                }
            }
            
            
            if userT.userData.clubsCreatedNum >= 3 {
                
                createdClubName.text = NSLocalizedString("My created club", comment: "我建立的club")
                
                createdClub1Name.text = userT.userData.clubsCreated[0].name
                createdClub1Image.image = userT.userData.clubsCreated[0].clubImage
                
                createdClub2Name.text = userT.userData.clubsCreated[1].name
                createdClub2Image.image = userT.userData.clubsCreated[1].clubImage
                
                createdClub3Name.text = userT.userData.clubsCreated[2].name
                createdClub3Image.image = userT.userData.clubsCreated[2].clubImage
                
            } else if userT.userData.clubsCreatedNum == 2 {
                
                createdClubName.text = NSLocalizedString("Create new club", comment: "建立新的club")
                createdClub1Name.text = userT.userData.clubsCreated[0].name
                createdClub1Image.image = userT.userData.clubsCreated[0].clubImage
                
                createdClub2Name.text = userT.userData.clubsCreated[1].name
                createdClub2Image.image = userT.userData.clubsCreated[1].clubImage
            } else if userT.userData.clubsCreatedNum == 1 {
                
                createdClubName.text = NSLocalizedString("Create new club", comment: "建立新的club")
                
                createdClub1Name.text = userT.userData.clubsCreated[0].name
                createdClub1Image.image = userT.userData.clubsCreated[0].clubImage
                
            } else if userT.userData.clubsCreatedNum == 0 {
                createdClubName.text = NSLocalizedString("Create new club", comment: "建立新的club")
                
            }
            
            if userT.userData.clubsJoinedNum  >= 2 {
                joinedClub1Name.text = userT.userData.clubsJoined[0].name
                joinedClub1Image.image = userT.userData.clubsJoined[0].clubImage
                
                joinedClub2Name.text = userT.userData.clubsJoined[1].name
                joinedClub2Image.image = userT.userData.clubsJoined[1].clubImage
                
            } else if userT.userData.clubsJoinedNum  == 1 {
                
                joinedClub1Name.text = userT.userData.clubsJoined[0].name
                joinedClub1Image.image = userT.userData.clubsJoined[0].clubImage
                
            } else if userT.userData.clubsJoinedNum  == 0 {
                
            }
        }
    }
    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "clubCreatedNum" {
//            print("\(userInfo?.clubCreatedNum)")
//            self.tableView.reloadData()
//
//        } else if keyPath == "clubJoinedNum" {
//            print("\(userInfo?.clubJoinedNum)")
//            self.tableView.reloadData()
//        } else {
//            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//        }
//    }
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadDataAndreflesh() {
        let spinnerView = SpinnerView.spinnerInView(navigationController!.view, animated: true)
        spinnerView.text = NSLocalizedString("Please wait", comment: "请稍后")
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        userIsLogOut = appdelegate.userIsLogOut
        appdelegate.getUserInfo()
        appdelegate.getAndInjectNotification()
        
        tableView.reloadData()
        self.showUserBasicInfo()
        afterDelay(0.1, closure: {spinnerView.removeFromSuperview()})
        let view = spinnerView.superview
        view!.userInteractionEnabled = true
    }
    

    // MARK: - Table view data source
    
//
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 && indexPath.row != 0{
            
            let createdClubView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowCLubDetailView") as! UserCreatClubCollectionViewController
            createdClubView.clubInfo = userInfo?.userData.clubsCreated[indexPath.row-1]//temp
            createdClubView.currentUser = userInfo
            createdClubView.viewType = 0
                self.navigationController?.pushViewController(createdClubView, animated: true)
            
        } else if indexPath.section == 2 && indexPath.row == 0{
            if userInfo!.userData.clubsCreatedNum >= 3 {
            self.performSegueWithIdentifier("toClubListForCreated", sender: nil)
            } else {
              self.performSegueWithIdentifier("toCreateClub", sender: nil)
            }
            
        } else if indexPath.section == 3 && indexPath.row != 0{
            let createdClubView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowCLubDetailView") as! UserCreatClubCollectionViewController
            createdClubView.clubInfo = userInfo?.userData.clubsJoined[indexPath.row-1]
            createdClubView.currentUser = userInfo
            createdClubView.viewType = 1
            self.navigationController?.pushViewController(createdClubView, animated: true)
        } else if indexPath.section == 3 && indexPath.row == 0 {
            self.performSegueWithIdentifier("toClubListForJoined", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return 1
        }else if section == 2 && userInfo!.userData.clubsCreatedNum == 0  {

            return 1
        } else if section == 2 && userInfo?.userData.clubsCreatedNum == 1 {

            return 2
        } else if section == 2 && userInfo?.userData.clubsCreatedNum == 2 {
            return 3
        } else if section == 2 && userInfo?.userData.clubsCreatedNum == 3 {
            return 4
        } else if section == 2 {
            return 4
        } else if section == 3 && ((userInfo?.userData.clubsJoinedNum)!) == 0 {
            return 1
        } else if section == 3 && ((userInfo?.userData.clubsJoinedNum)!) == 1 {
            return 2
        } else if section == 3 {
            return 3
        }else {
            return 1
        }
    }

    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        if indexPath.section == 1 && indexPath.row == 0 {
//        let cell = tableView.dequeueReusableCellWithIdentifier("userNotificationCell", forIndexPath: indexPath)
//            
//            if let mynotifications = myNotifications {
//                if mynotifications.count >= 1 {
//                    let cell = self.tableView.dequeueReusableCellWithIdentifier("userNotificationCell")
//                    cell?.showBadgeWithStyle(.Number, value: mynotifications.count, animationType: .None)
//                    //
//                }
//            }
//
//        // Configure the cell...
//
//            return cell
////        } else {
////            let cell = tableView.dequeueReusableCellWithIdentifier("createdClub", forIndexPath: indexPath)
////            return cell
////        }
//        } else {
//            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
//        }
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - method
    
//    func creatNewClubForThisAccount (clubName: String) {
//        if let user = userInfo {
//            let avuser = user.changeUserToAVuserForSever()
//            let newClub = Club(clubCeater: avuser, clubName: clubName)
//            Club.creatNewClubToSever(newClub)
//            self.userInfo = addNewClubToUser(user, newClub: newClub)
//        }
//    }
    
    func addNewClubToUser(user: User, newClub: Club) -> User {
        user.clubJoinedNum += 1
        user.clubCreatedNum += 1
        
        return user
    }
    
    @IBAction func createViewDidCreatedClub (segue: UIStoryboardSegue) {
//        let controller = segue.sourceViewController as! CreateNewClubTableViewController
//        self.newClub = controller.newClub
//        self.userInfo?.clubCreatedNum += 1
//        self.userInfo?.clubJoinedNum += 1
//        self.needRefresh = !self.needRefresh
//        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "editUser" {
            let navigateController = segue.destinationViewController as! UINavigationController
            let controller = navigateController.topViewController as! EditUserInfoTableViewController
            
            controller.newUser = userInfo
            controller.delegate = self
        } else if segue.identifier == "toClubListForJoined" {
            let navigateController = segue.destinationViewController as! UINavigationController
            let controller = navigateController.topViewController as! ClubListTableViewController
            controller.showTpye = 1
            controller.clubs = userInfo?.userData.clubsJoined
            controller.currentUser = userInfo
        } else if segue.identifier == "toCreateClub" {
            let navigateController = segue.destinationViewController as! UINavigationController
            let controller = navigateController.topViewController as! CreateNewClubTableViewController
            controller.creater = userInfo
        } else if segue.identifier == "showNotificationView" {
            let navigateController = segue.destinationViewController as! UINavigationController
            let controller = navigateController.topViewController as! DealNoticifationTableViewController
//            self.myNotifications = Notification.getNotification(AVUser.currentUser())
            controller.currentUser = userInfo
            controller.notifications = myNotifications
        } else if segue.identifier == "toClubListForCreated" {
            let navigateController = segue.destinationViewController as! UINavigationController
            let controller = navigateController.topViewController as! ClubListTableViewController
            controller.showTpye = 0
            controller.clubs = userInfo?.userData.clubsCreated
            controller.currentUser = userInfo
        } else if segue.identifier == "toShowCreatedClubInfo"/*弃用segue*/ {
            
        }
    }
    
    func getMyNotification (currentUser: User) -> [Notification] {
        let avCurrentUser = AVUser(objectId: currentUser.userID)
        var results = [Notification]()
        let query = AVQuery(className: "MyNotification")
        query.whereKey("receiver", equalTo: avCurrentUser)
        query.whereKey("hasDealed", equalTo: false)
        
//        query.findObjectsInBackgroundWithBlock({avMyNotifications, error in
//            if error != nil {
//                print("\(error)")
//            } else {
            let avMyNotifications = query.findObjects()
                for avMyNotification in avMyNotifications {
                    if avMyNotification.fetch() {
                    let result = Notification()
                        result.creater = avMyNotification["creater"] as? AVUser
                        result.receiver = avMyNotification["receiver"] as? AVUser
                        result.detailMessage = avMyNotification["detailMessage"] as! String
                        result.hasDealed = avMyNotification["hasDealed"] as! Bool
                        result.notificationType = avMyNotification["notificationType"] as! Int
                        results.append(result)
                        print("get notification")
                    }
                    
//                }
//            }
//        })
        }
        return results
    
    }
    
    
    
    //MARK: - 暂用method
    //待替换以节约请求数
    func getUserInfo () {
   //     let user1 = AVUser.currentUser()
     //   self.userInfo = User(avuser: user1)
       // userInfo?.userData = UserData.getDataFromServe(user1)
        
//        if userInfo == nil {
//            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            userInfo = appdelegate.userInfo
//        }
        userInfo!.addObserver(self, forKeyPath: "clubCreatedNum", options: .New, context: nil)
        userInfo!.addObserver(self, forKeyPath: "clubJoinedNum", options: .New, context: nil)
    }
    
    func creatAVuserForUpdate (user: User) -> AVUser {
        let avuser = AVUser(className: "_User", objectId: user.userID)
        avuser.sessionToken = user.sessionToken
        
        return avuser
    }
    
    deinit {
        userInfo!.removeObserver(self, forKeyPath: "clubCreatedNum")
        userInfo!.removeObserver(self, forKeyPath: "clubJoinedNum")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("*******user info view has deinit*******")
    }
    
}

extension UserInfoTableViewController: EditUserInfoTableViewControllerDelegate {
    
    func editUserInfoTableViewControllerDidLogOut(controller: EditUserInfoTableViewController, isUserLogOut: Bool) {
        self.userIsLogOut = isUserLogOut
    }
    

    
    func editUserInfoTableViewControllerDidSaved(controller: EditUserInfoTableViewController, userData: User) {
        self.userInfo = userData
        self.tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editUserInfoTableViewControllerDidCancel(controller: EditUserInfoTableViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
