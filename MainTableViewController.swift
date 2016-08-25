//
//  MainTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 8/18/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import CoreData
import AVOSCloud
import AudioToolbox

class MainTableViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainNavigationItem: UINavigationItem!
    
    var publishContents = [PublishContent]()
    
    var publishsToShow: [Publish]!{
        didSet{
            print("publishToShow receive data")
            tableView.reloadData()
        }
    }
    
    var searchResults: [Publish]?
    var needRefresh = true
    
    var userInfo: User!
    var userIsLogout = false
    
    let soundID = kSystemSoundID_Vibrate
    
    //    let refreshControl = UIRefreshControl()
    
    struct PublushContentCellIdentifiers {
        static let publishContentCell = "PublishContentCell"
        static let nothingFound = "NothingFoundCell"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if userIsLogout {
            if let signInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInView") as? SignInViewController  {
                self.tabBarController?.presentViewController(signInViewController, animated: true, completion: nil)
                return
            }
        }
        if needRefresh {
        let view0 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        self.view.addSubview(view0)
            
//        let tabbarcontroller = UIWindow().rootViewController as! tabBarViewController
//        tabBarViewController.item
        
        let spinnerView = SpinnerView.spinnerInView(view0, animated: true)
        spinnerView.text = NSLocalizedString("Please wait", comment: "请稍后")
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.getAndInjectUserData()
        appdelegate.getAndInjectNotification()
        getPublishs()
//        tableView.reloadData()
            
//        view.removeFromSuperview()
        
        afterDelay(0.1, closure: {spinnerView.removeFromSuperview()})
        let view1 = spinnerView.superview
        view1!.userInteractionEnabled = true
        self.needRefresh = false
            
        view0.removeFromSuperview()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        userIsLogout = appDelegate.userIsLogOut
        
        //tableView.reloadData()
        //fetch data from coredata
//        let fetchRequest = NSFetchRequest()
//        let entity = NSEntityDescription.entityForName("PublishContent", inManagedObjectContext: managedObjectContext)
//        fetchRequest.entity = entity
//        // 3
//        let sortDescriptor = NSSortDescriptor(key: "userID", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        do { // 4
//            let foundObjects = try managedObjectContext.executeFetchRequest(fetchRequest)
//            // 5
//            publishContents = foundObjects as! [PublishContent]
//        } catch {
//            fatalError("Error\(error)") }
        //        mainNavigationItem.bo
        
        
        
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: #selector(MainTableViewController.getPublishs), forControlEvents:
            UIControlEvents.ValueChanged)
        
//                showNavSpinner()
        //config the custom cell
        var cellNib = UINib(nibName: PublushContentCellIdentifiers.publishContentCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PublushContentCellIdentifiers.publishContentCell)
        cellNib = UINib(nibName: PublushContentCellIdentifiers.nothingFound, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PublushContentCellIdentifiers.nothingFound)
        
        tableView.rowHeight = 98 // temp!!
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowDetails" {
//            let navigationViewController = segue.destinationViewController as! UINavigationController
//            let detaiViewController = navigationViewController.viewControllers[0] as! DetailViewController
//            let indexPath = sender as! NSIndexPath
//            detaiViewController.publish = publishsToShow[indexPath.row]
//        }
        
        if segue.identifier == "ShowDetails" {
            let navigationViewController = segue.destinationViewController as! UINavigationController
            let detaiViewController = navigationViewController.viewControllers[0] as! ShowDetailViewController
            let indexPath = sender as! NSIndexPath
            detaiViewController.publish = publishsToShow[indexPath.row]
//            let s = detaiViewController.publish
            
        }
        
        if segue.identifier == "addNewPublish" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let addViewcontroller = navigationController.viewControllers[0] as! AddViewController
            addViewcontroller.managedObjectContext = managedObjectContext
            addViewcontroller.currentUser = userInfo
        }
    }
    
    func play() {
        AudioServicesPlaySystemSound(soundID)
    }
    
    func showNavSpinner () {
        let navLabel = UILabel()
        navLabel.text = NSLocalizedString("LOADING...", comment: "收取中")
        navLabel.textColor = UIColor.whiteColor()
        navLabel.font = UIFont(name: "system", size: 14)
        
        navLabel.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navLabel.sizeToFit()
        
        
        let titView = UIView(frame: CGRect(x: 50, y: 0, width: 40, height: 20))
        
        navLabel.center = CGPoint(x: titView.bounds.width - navLabel.bounds.width/2, y: titView.center.y)
        
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .White
        spinner.center = CGPoint(x: titView.bounds.width + 15, y: titView.center.y)
        //        let s = spinner.frame.width
        spinner.hidesWhenStopped = true
        titView.addSubview(spinner)
        titView.addSubview(navLabel)
        spinner.startAnimating()
        
        mainNavigationItem.titleView = titView
        
    }
    
    func showSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        mainNavigationItem.titleView = searchBar
    }
    
    func getPublishs() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.getPublishInMultipleThreads()
        print("publishs has refresh")
    }
    
    func dealWithPublishs (user: User) -> [AVObject] {
        let clubs = user.userData.clubsCreated + user.userData.clubsJoined
        var tempAvPublishs = [AVObject]()
        var avPublishs = [AVObject]()
        for club in clubs {
            let avClub = AVObject(className: "Club", objectId: club.clubID)
            
            avClub.fetch()
            let avPublishs = avClub["publishs"] as! [AVObject]
            tempAvPublishs += avPublishs
        }
        
        avPublishs = tempAvPublishs.orderedSetValue
        
        return avPublishs
        
    }
    //
    
}

extension MainTableViewController: UISearchBarDelegate {
    
}

extension MainTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let publishsToShow = publishsToShow {
        return publishsToShow.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PublushContentCellIdentifiers.publishContentCell, forIndexPath: indexPath) as! PublishContentCell
        
        let publish = publishsToShow[indexPath.row]
        
        
        cell.configureForPublishContent(publish)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowDetails", sender: indexPath)
    }
}

extension MainTableViewController {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchtext = searchBar.text
        searchResults = []
        if searchtext != "" {
        print("\(searchtext)")}
    }
}
