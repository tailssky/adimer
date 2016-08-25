//
//  PickClubTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 8/16/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit

class PickClubTableViewController: UITableViewController {
    
    var clubsForChoose: [Club]!
    var choosenClubs: [Club]!
    var selectedIndexPaths: [NSIndexPath]!
    
    weak var delegate: PickClubViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        selectedIndexPaths = [NSIndexPath]()
        
        for i in 0..<clubsForChoose.count {
            for choosenClub in choosenClubs {
                if clubsForChoose[i].clubID == choosenClub.clubID {
                    let selecetdIndexPath = NSIndexPath(forRow: i, inSection: 0)
                    selectedIndexPaths.append(selecetdIndexPath)
                }
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        delegate?.pickClubViewHasChoosenClub(self, choosenClub: choosenClubs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clubsForChoose.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let clubName = clubsForChoose[indexPath.row].name
        cell.textLabel?.text = clubName
        
        for choosenClub in choosenClubs {
            if choosenClub.clubID == clubsForChoose[indexPath.row].clubID
            {
                cell.accessoryType = .Checkmark
                return cell
            }
            
        }
        
        cell.accessoryType = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        for choosenIndexPath in selectedIndexPaths {
            if choosenIndexPath.row == indexPath.row {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    cell.accessoryType = .None
                    var newSelectIndexs = [NSIndexPath]()
                    var newChooseClubs = [Club]()
                    for newChoosenIndexPath in selectedIndexPaths {
                        if newChoosenIndexPath.row != indexPath.row {
                            newSelectIndexs.append(newChoosenIndexPath)
                        }
                    }
                    selectedIndexPaths = newSelectIndexs
                    
                    for newChooseClub in choosenClubs {
                        if newChooseClub.clubID != clubsForChoose[indexPath.row].clubID {
                            newChooseClubs.append(newChooseClub)
                        }
                    }
                    
                    choosenClubs = newChooseClubs
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    return
                }
            }
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    cell.accessoryType = .Checkmark
                    selectedIndexPaths.append(indexPath)
                    choosenClubs.append(clubsForChoose[indexPath.row])
                    
        }
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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

protocol PickClubViewControllerDelegate: class {
    func pickClubViewHasChoosenClub(controller: PickClubTableViewController, choosenClub: [Club])
}
