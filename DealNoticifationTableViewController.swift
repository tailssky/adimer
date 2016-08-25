//
//  DealNoticifationTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 8/12/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class DealNoticifationTableViewController: UITableViewController {
    
    var notifications: [Notification]!
    var currentUser: User!
    var needRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
        needRefresh = false
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    //MARK: - method
    
    @IBAction func cancelBntTapped () {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dealWithInvitationOnServe(notication: Notification) -> Bool {
        if notication.notificationType == 0 {
            //            notication.receiver
            let qurey = AVQuery(className: "UserData")
            qurey.whereKey("owner", equalTo: notication.receiver)
            let avUserData = qurey.getFirstObject()
            
            avUserData.addUniqueObject(notication.avClub, forKey: "clubsJoined")
            avUserData.incrementKey("clubsJoinedNum", byAmount: 1)
            notication.avClub?.addUniqueObject(notication.receiver, forKey: "joiner")
            notication.avClub?.saveInBackground()
            
            if avUserData.save() {
                let ntfQuery = AVQuery(className: "MyNotification")
                ntfQuery.whereKey("receiver", equalTo: notication.receiver)
                ntfQuery.whereKey("hasDealed", equalTo: false)
                ntfQuery.whereKey("club", equalTo: notication.avClub)
                let avNotification = ntfQuery.getFirstObject()
                avNotification.setObject(true, forKey: "hasDealed")
                avNotification.save()
                return true
            } else {
                return false
            }
        }else if notication.notificationType == 12 {
            let ntfQuery = AVQuery(className: "MyNotification")
            ntfQuery.whereKey("receiver", equalTo: notication.receiver)
            ntfQuery.whereKey("hasDealed", equalTo: false)
            ntfQuery.whereKey("club", equalTo: notication.avClub)
            let avNotification = ntfQuery.getFirstObject()
            avNotification.setObject(true, forKey: "hasDealed")
            avNotification.save()
            return true
        } else if notication.notificationType == 1 /*friend invitation */ {
            return false
        } else {
            return false
        }
    }


    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! NotificationTableViewCell
        
        let notification = notifications[indexPath.row]
       
        if notification.notificationType == 0 {
            cell.delegate = self
            cell.cellType = 1
            if notification.hasDealed {
            cell.dealButton.hidden = true
            } else {
                cell.dealButton.hidden = false
                cell.dealButton.setTitle(NSLocalizedString("Accept", comment: "接受"), forState: .Normal)
            }
            let club = Club.avClubToClub(notification.avClub!)
            cell.row = indexPath.row
            cell.showImage.image = club?.clubImage
            cell.showMessage.text = notification.detailMessage
            cell.showSourceInfo.text = NSLocalizedString("From: ", comment: "来自：") + "\(notification.clubName!)"
        } else if notification.notificationType == 12 {
            cell.delegate = self
            cell.cellType = 1
            if notification.hasDealed {
                cell.dealButton.hidden = true
            } else {
                cell.dealButton.hidden = false
                cell.dealButton.setTitle(NSLocalizedString("OK", comment: "好的"), forState: .Normal)
            }
            let club = Club.avClubToClub(notification.avClub!)
            cell.row = indexPath.row
            cell.showImage.image = club?.clubImage
            cell.showMessage.text = notification.detailMessage
            cell.showSourceInfo.text = NSLocalizedString("From: ", comment: "来自：") + "\(notification.clubName!)"
        }

        // Configure the cell...

        return cell
    }
    

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

}

extension DealNoticifationTableViewController: NotificationCellDelegate{
    func notificationCellBtnTapped(controller: NotificationTableViewCell, row: Int) {
        let spinnerView = SpinnerView.spinnerInView(navigationController!.view, animated: true)
        spinnerView.text = NSLocalizedString("Please wait", comment: "Hud text,published")
        
        
        notifications[row].hasDealed = true
        dealWithInvitationOnServe(notifications[row])
        tableView.reloadData()
        self.needRefresh = true
        
        
        afterDelay(0.1, closure: {spinnerView.removeFromSuperview()})
        let view = spinnerView.superview
        view!.userInteractionEnabled = true
    }
}
