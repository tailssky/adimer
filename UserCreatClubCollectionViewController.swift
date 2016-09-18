//
//  UserCreatClubCollectionViewController.swift
//  Adam
//
//  Created by 周岩峰 on 7/22/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

private let reuseIdentifier = "clubMemberCell"

class UserCreatClubCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var clubInfo: Club!
    var viewType: Int! /*0 for created club ,1 for joined club*/
    var currentUser: User!
    var needRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()
        needRefresh = false
        
        self.title = clubInfo.name
        
        if viewType == 1 {
            rightBarButton.title = NSLocalizedString("Exit club", comment: "离开club")
            
//           rightBarButton.target = nil
//            rightBarButton.action = #selector(UserCreatClubCollectionViewController.exitClub)
        } else if viewType == 0 {
            rightBarButton.title = NSLocalizedString("Dismiss club", comment: "解散club")
            
            let gestureReconizer = UILongPressGestureRecognizer(target: self, action:#selector(self.changNameBtnTapped))
            gestureReconizer.cancelsTouchesInView = false
            self.view.addGestureRecognizer(gestureReconizer)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "addMemberCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        if needRefresh {
            NSNotificationCenter.defaultCenter().postNotificationName("needRefresh", object: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAddMember" {
            let addMemeberViewController = segue.destinationViewController as! AddMemberViewController
            addMemeberViewController.byClub = clubInfo
            addMemeberViewController.currentUser = currentUser
        } 
    }
    
    @IBAction func exitClub() {
          if viewType == 1 {
            let avUser = User.changeUserToAVuserForSever(currentUser)
            
            let spinnerView = SpinnerView.spinnerInView(navigationController!.view, animated: true)
            spinnerView.text = NSLocalizedString("Please wait", comment: "Hud text,published")
            
            Club.quitFromClubOnServe(clubInfo, leaver: avUser)
            let message = "\(currentUser.nickname)"+NSLocalizedString(" has left ", comment: "XX已离开XXclub") + "\(clubInfo.name)"
            Notification.createNotificationToServe(clubInfo, carefulCreater: avUser, avReceiver: clubInfo.creater, message: message, notificationType: 12)
            
            afterDelay(0.1, closure: {spinnerView.removeFromSuperview()})
            let view = spinnerView.superview
            view!.userInteractionEnabled = true
            
            needRefresh = true
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController!.popToRootViewControllerAnimated(true)
        } else if viewType == 0 {
            let alertMessage = NSLocalizedString("Are you sure to dismiss this club?", comment: "")
            let alert = UIAlertController(title: NSLocalizedString("WARNING", comment: "normal alert title"), message: alertMessage, preferredStyle: .Alert)
            let alertActionSure = UIAlertAction(title: NSLocalizedString("Sure", comment: "normal alert button sure"), style: .Default, handler: {_ in
                
                let spinnerView = SpinnerView.spinnerInView(self.navigationController!.view, animated: true)
                spinnerView.text = NSLocalizedString("Please wait", comment: "Hud text,published")
                
                if self.dismissClub() {
                    self.needRefresh = true
                    afterDelay(0.1, closure: {spinnerView.removeFromSuperview()})
                    let view = spinnerView.superview
                    view!.userInteractionEnabled = true
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }})
            
            alert.addAction(alertActionSure)
            
            let alertActionCancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "normal alert button cancel"), style: .Cancel, handler: nil)
            alert.addAction(alertActionCancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func changNameBtnTapped() {
        let title = NSLocalizedString("Change club name", comment: "")
        let message = NSLocalizedString("Type your club's new name", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        let actionOK = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: {_ in
            if let newName = alert.textFields![0].text {
                let spinnerView = SpinnerView.spinnerInView(self.navigationController!.view, animated: true)
                spinnerView.text = NSLocalizedString("Please wait", comment: "请稍后")
                if self.changeClubName(newName) {
                    spinnerView.removeFromSuperview()
                    self.navigationController!.view.userInteractionEnabled = true
                    
                    self.needRefresh = true
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }})
        alert.addAction(actionOK)
        let actionCancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
        alert.addAction(actionCancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func needFreshData () {
        
    }
    
    private func changeClubName(newName: String) -> Bool {
        let avClub = AVObject(className: "Club", objectId: clubInfo.clubID)
        avClub.setObject(newName, forKey: "name")
        return avClub.save()
    }
    
    private func dismissClub() -> Bool {
        if clubInfo.creater.objectId == AVUser.currentUser().objectId {
            let avClub = AVObject(className: "Club", objectId: clubInfo.clubID)
            for avClubJoiner in clubInfo.joiners {
                let avUserDataQuery = AVQuery(className: "UserData")
                avUserDataQuery.whereKey("owner", equalTo: avClubJoiner)
                let avUseData = avUserDataQuery.getFirstObject()
                avUseData.removeObject(avClub, forKey: "clubsJoined")
                
                avUseData.incrementKey("clubsJoinedNum", byAmount: -1)
                
                
                avUseData.saveInBackground()
                Notification.createNotificationToServe(clubInfo, carefulCreater: clubInfo.creater, avReceiver: avClubJoiner, message: "\(clubInfo.name)"+NSLocalizedString(" has been dismissed.", comment: ""), notificationType: 12)
            }
            let avUserDataQuery1 = AVQuery(className: "UserData")
            avUserDataQuery1.whereKey("owner", equalTo: clubInfo.creater)
            let avUseData = avUserDataQuery1.getFirstObject()
            avUseData.removeObject(avClub, forKey: "clubsCreated")
            
            avUseData.incrementKey("clubsCreatedNum", byAmount: -1)
            
            
            avUseData.saveInBackground()
            
            if avClub.delete() {
                return true
            }
            return false
        }
        return false
    }
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tappedCancel() {
        dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func cellBtnTapped () {
        
    
            self.performSegueWithIdentifier("toAddMember", sender: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.clubInfo.joiners.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {


        if indexPath.row <= clubInfo.joiners.count - 1 /*row从0开始 需要减一*/ {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClubMemeberCollectionViewCell
        
        let avjoiner = clubInfo.joiners[indexPath.row]
            
            cell.userNickName.text = NSLocalizedString("UserName", comment: "用户名")
            cell.userPortraitImage.image = UIImage(named: "defaultPortraitImage")
            avjoiner.fetchInBackgroundWithKeys(["nickName","userPortraitImage"], block: {avjoinerInfo, error in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        let name = avjoinerInfo["nickName"] as! String
                        if  name != "" {
                            cell.userNickName.text = name
                        } else {
                            cell.userNickName.text = NSLocalizedString("UserName", comment: "用户名")
                        }
                    let avFile = avjoinerInfo["userPortraitImage"] as! AVFile
                    let nsData = avFile.getData()
                    cell.userPortraitImage.image = UIImage(data: nsData)})
                }})

    
        // Configure the cell
        
        return cell
        } else {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addMemberCell", forIndexPath: indexPath)
            
                        return cell
        }
    }
    


    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row <= clubInfo.joiners.count - 1 && viewType == 0{
            let avuser = clubInfo.joiners[indexPath.row]
            let user = User.changerAVUserToUserNoAuthority(avuser)
            if let showUserInfoView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowUserInfoView") as? ShowUserInfoTableViewController {
                showUserInfoView.fromClub = clubInfo
                showUserInfoView.userForShow = user
                showUserInfoView.viewType = 10
                showUserInfoView.currentUser = currentUser
                
                self.navigationController?.pushViewController(showUserInfoView, animated: true)
            }
        } else if indexPath.row <= clubInfo.joiners.count - 1 && viewType == 1{
            let avuser = clubInfo.joiners[indexPath.row]
            let user = User.changerAVUserToUserNoAuthority(avuser)
            if let showUserInfoView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowUserInfoView") as? ShowUserInfoTableViewController {
                showUserInfoView.fromClub = clubInfo
                showUserInfoView.userForShow = user
                showUserInfoView.viewType = 1
                showUserInfoView.currentUser = currentUser
                
                self.navigationController?.pushViewController(showUserInfoView, animated: true)
            } else{
            //保留button
                }
            }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    //MARK: - method
    
//    func findUser (usersInfo: String) -> AVUser? {
//        
//    }
//    
//    func addNotification (creater: AVUser, receiver: AVUser) -> Notification {
//        
//    }
//    
//    func addMemberToClub (newMember: AVUser) {
//        
//    }

}
