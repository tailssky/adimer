//
//  ShowUserInfoTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 7/30/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class ShowUserInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var userPortrait: UIImageView!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userUserName: UILabel!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var removeUserBtn: UIButton!
    @IBOutlet weak var addFriendBtn: UIButton!
    
    @IBOutlet weak var userPhoneNum: UILabel!
    @IBOutlet weak var userPhoneNumName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userEmailName: UILabel!
    
    var userForShow: User!
    var viewType: Int!
    var fromClub: Club?
    var currentUser: User!
    var needRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()
        needRefresh = false
        
        userPortrait.image = userForShow.userPortraitImage
        userNickname.text = userForShow.nickname
        userUserName.text = userForShow.userName
        userPhoneNum.text = userForShow.phoneNumber
        userEmail.text = userForShow.email
        
        inviteBtn.sizeToFit()
        removeUserBtn.sizeToFit()
        addFriendBtn.sizeToFit()
        userEmail.sizeToFit()
        userPhoneNum.sizeToFit()
        userEmailName.sizeToFit()
        userPhoneNumName.sizeToFit()
        userUserName.sizeToFit()
        userNickname.sizeToFit()
        
        
        
        
        switch viewType {
        case 0:
            inviteBtn.hidden = false
            removeUserBtn.hidden = true
            addFriendBtn.hidden = true
        case 1:
            inviteBtn.hidden = true
            removeUserBtn.hidden = true
            addFriendBtn.hidden = true
        case 10:
            inviteBtn.hidden = true
            removeUserBtn.hidden = false
            addFriendBtn.hidden = true
        case 1:
            inviteBtn.hidden = true
            removeUserBtn.hidden = true
            addFriendBtn.hidden = false
        default:
            break
            
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        if needRefresh {
            NSNotificationCenter.defaultCenter().postNotificationName("needRefresh", object: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inviteBtnTapped() {
        if let fromClub = fromClub {
          Notification.createNotificationToServe(fromClub, carefulCreater: fromClub.creater, receiver: userForShow, message: NSLocalizedString("please join my",comment:"")+"\(fromClub.name)", notificationType: 0)
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        hudView.text = NSLocalizedString("Sended", comment: "已发送")
        afterDelay(0.6, closure: {hudView.removeFromSuperview()})
        let view = hudView.superview
        view!.userInteractionEnabled = true
         self.dismissViewControllerAnimated(true, completion: nil)
          self.navigationController!.popToRootViewControllerAnimated(true)  
//        afterDelay(0.8, closure: {self.dismissViewControllerAnimated(true, completion: nil)})
//        afterDelay(0.9, closure: {self.navigationController!.popToRootViewControllerAnimated(true)})
        
        
        }
    }
    
    @IBAction func removeUserBtnTapped () {
        let avUser = User.changeUserToAVuserForSever(userForShow)
        Club.quitFromClubOnServe(fromClub!, leaver: avUser)
        let message = NSLocalizedString("You has been removed from ", comment: "你被从XXclub移除") + "\(fromClub!.name)"
        Notification.createNotificationToServe(fromClub, carefulCreater: avUser, avReceiver: fromClub!.creater, message: message, notificationType: 12)
        needRefresh = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func needFreshData() {
        
    }
    
    @IBAction func cancelTapped () {
        dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    
    
    

}
