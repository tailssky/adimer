//
//  ClubListTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 8/8/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit

class ClubListTableViewController: UITableViewController {
    
    var clubs: [Club]!
    var showTpye: Int! //0 for createClub. 1 for joined club
    var currentUser: User!
    
    struct UserResultsCellIdentifiers {
        static let searchResultCell = "UserInfoCell"
        static let nothingFound = "NothingFoundCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let cellNib = UINib(nibName: UserResultsCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: UserResultsCellIdentifiers.searchResultCell)
//        let cellNib1 = UINib(nibName: UserResultsCellIdentifiers.nothingFound, bundle: nil)
//        tableView.registerNib(cellNib1, forCellReuseIdentifier: UserResultsCellIdentifiers.nothingFound)
        
        tableView.rowHeight = 80


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clubs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UserResultsCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! UserInfoCellTableViewCell
        
        //cell.portraitImage.image = clubs[indexPath.row]
        cell.mainName.text = clubs[indexPath.row].name
        let num = clubs![indexPath.row].joiners.count
        cell.subName.text = NSLocalizedString("Number of club: ", comment: "会员人数") + "\(num)"
        cell.portraitImage.image = clubs[indexPath.row].clubImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let createdClubView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowCLubDetailView") as! UserCreatClubCollectionViewController
        createdClubView.clubInfo = clubs[indexPath.row]
        let id = clubs[indexPath.row].creater.objectId
        if  id == currentUser.userID {
            createdClubView.viewType = 0
        }else {
        createdClubView.viewType = 1}
        createdClubView.currentUser = currentUser
        self.navigationController?.pushViewController(createdClubView, animated: true)
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
