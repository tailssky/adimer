//
//  tabBarViewController.swift
//  Adam
//
//  Created by 周岩峰 on 7/20/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class tabBarViewController: UITabBarController {
    
    var notificationNum: Int!
    
    var needRefresh = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if notificationNum == nil {
            notificationNum = 0
        }
        setupTabbarItemBadge(notificationNum)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        if AVUser.currentUser() == nil {
//            if let signInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInView") as? SignInViewController  {
//                self.tabBarController?.presentViewController(signInViewController, animated: true, completion: nil)
//                return
//            }
//        }
//        if needRefresh {
//            let spinnerView = SpinnerView.spinnerInView(tabBar, animated: true)
//            spinnerView.text = NSLocalizedString("Please wait", comment: "请稍后")
//            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appdelegate.getAndInjectUserData()
//            appdelegate.getAndInjectNotification()
////            getPublishs()
//            //        tableView.reloadData()
//            
//            afterDelay(0.1, closure: {spinnerView.removeFromSuperview()})
//            let view = spinnerView.superview
//            view!.userInteractionEnabled = true
//            self.needRefresh = false
//        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTabbarItemBadge (showNum: Int) {
        
        let personBarItem = tabBar.items![2]
//        let barFrame = self.tabBar.frame
        if showNum != 0 {
        personBarItem.badgeCenterOffset = CGPointMake(-2,5)
        personBarItem.badgeBgColor = UIColor(red: 175/255, green: 0/255, blue: 33/255, alpha: 1)
        personBarItem.showBadgeWithStyle(.Number, value: showNum, animationType: .None)
        } else {
            personBarItem.clearBadge()
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
