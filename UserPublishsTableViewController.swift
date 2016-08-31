//
//  UserPublishsTableViewController.swift
//  Adimer
//
//  Created by 周岩峰 on 8/31/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud
import AudioToolbox

class UserPublishsTableViewController: UITableViewController {
    
    var userInfo: User!
    var publishes: [Publish]!
    var needRefresh = false
    
    var soundID = kSystemSoundID_Vibrate
    
    struct PublushContentCellIdentifiers {
        static let publishContentCell = "PublishContentCell"
        static let nothingFound = "NothingFoundCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishes = [Publish]()
        
        getPublishesInBackground()
        
        //config the custom cell
        var cellNib = UINib(nibName: PublushContentCellIdentifiers.publishContentCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PublushContentCellIdentifiers.publishContentCell)
        cellNib = UINib(nibName: PublushContentCellIdentifiers.nothingFound, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PublushContentCellIdentifiers.nothingFound)
        
        tableView.rowHeight = 98
        
        let spinnerView = SpinnerView.spinnerInView(tableView, animated: true)
        spinnerView.text = NSLocalizedString("Please wait", comment: "请稍后")
        
        afterDelay(2, closure: {spinnerView.removeFromSuperview()})
        tableView.userInteractionEnabled = true
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if needRefresh {
            NSNotificationCenter.defaultCenter().postNotificationName("needRefresh", object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPublishesInBackground () {
        var publishes = [Publish]()
        let avUser = AVUser(objectId: userInfo.userID)
        let publishQuery = AVQuery(className: "Publish")
        publishQuery.whereKey("publisher", equalTo: avUser)
        let avPublishes = publishQuery.findObjects() as! [AVObject]
        let group = dispatch_group_create()
        let q_concurrent = dispatch_queue_create("my_concurrent_queue1", DISPATCH_QUEUE_CONCURRENT)
        //        let q_concurrent = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        for avPublish in avPublishes {
            dispatch_group_async(group, q_concurrent) {
                let publish = Publish.avPublishToPublishWithOutClub(avPublish)
                if let publish = publish {
                    publishes.append(publish)
                    print("--own publish Get----")}
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()){
            print("All done!!!")
            
            self.play()
            let  newpublishs = publishes.sort({(publish1: Publish, publish2: Publish) -> Bool in
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
            
            self.publishes = newpublishs
            self.tableView.reloadData()
        }
    }
    
    func play () {
        AudioServicesPlaySystemSound(soundID)
    }
    
    func deletePublish (publishToDelete: Publish) -> Bool {
        let avPublish = AVObject(className: "Publish", objectId: publishToDelete.publishID)
        if avPublish.fetch() {
            let avPublishClubs = avPublish["publishedToClubs"] as! [AVObject]
            for avPublishClub in avPublishClubs {
                avPublishClub.removeObject(avPublish, forKey: "publishs")
                avPublishClub.save()
            }
            if  avPublish.delete() {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return publishes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PublushContentCellIdentifiers.publishContentCell, forIndexPath: indexPath) as! PublishContentCell
        
        let publish = publishes[indexPath.row]
        cell.configureForPublishContent(publish)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("showPublishDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPublishDetail" {
            let navigationViewController = segue.destinationViewController as! UINavigationController
                let detaiViewController = navigationViewController.viewControllers[0] as! ShowDetailViewController
                let indexPath = sender as! NSIndexPath
                detaiViewController.publish = publishes[indexPath.row]
                }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            deletePublish(publishes[indexPath.row])
            publishes.removeObject(publishes[indexPath.row])
            needRefresh = true
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
