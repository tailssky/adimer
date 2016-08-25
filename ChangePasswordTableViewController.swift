//
//  ChangePasswordTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 8/21/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class ChangePasswordTableViewController: UITableViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    var newUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBtnTapped () {
        changPassword()
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        hudView.text = NSLocalizedString("Changed!", comment: "Hud text,published")
        
        afterDelay(0.6, closure: {self.dismissViewControllerAnimated(true, completion: nil)})
    }
    
    @IBAction func cancelBtnTapped () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changPassword() {
        if password.text == password2.text && password.text != ""{
            if newUser.userID == AVUser.currentUser().objectId {
                let avUserQurey = AVQuery(className: "_User")
                avUserQurey.whereKey("objectId", equalTo: newUser.userID)
                let avUser = avUserQurey.getFirstObject() as! AVUser
                avUser.sessionToken = AVUser.currentUser().sessionToken
                
                avUser.password = password.text
                
                avUser.saveEventually({_ , error in
                    if error != nil {
                        print("\(error)")
                    }})
            } else {
                let alterMessage = NSLocalizedString("Error!", comment: "alert")
                let alert = creatNormalAlert(alterMessage)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alterMessage = NSLocalizedString("Pass words are not equal.", comment: "alert")
            let alert = creatNormalAlert(alterMessage)
            self.presentViewController(alert, animated: true, completion: nil)
        }

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

}
