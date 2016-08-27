//
//  SignInViewController.swift
//  Adam
//
//  Created by 周岩峰 on 7/11/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class SignInViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signIn() {
//        if let nametext = nameField.text {
//            if let passwordtext = passwordField.text {
        AVUser.logInWithUsernameInBackground(nameField.text!, password: passwordField.text!){avUser, error in
            if error != nil {
                switch error.code {
                case 200:
                    let alterMessage = NSLocalizedString("Username is missing or empty.", comment: "alert")
                    let alert = creatNormalAlert(alterMessage)
                    self.presentViewController(alert, animated: true, completion: nil)
                case 201:
                    let alterMessage = NSLocalizedString("Password is missing or empty.", comment: "alert")
                    let alert = creatNormalAlert(alterMessage)
                    self.presentViewController(alert, animated: true, completion: nil)
                case 202:
                    let alterMessage = NSLocalizedString("Username has already been taken.", comment: "alert")
                    let alert = creatNormalAlert(alterMessage)
                    self.presentViewController(alert, animated: true, completion: nil)
                case 210:
                    let alterMessage = NSLocalizedString("The username and password mismatch.", comment: "alert")
                    let alert = creatNormalAlert(alterMessage)
                    self.presentViewController(alert, animated: true, completion: nil)
                case 211:
                    let alterMessage = NSLocalizedString("Could not find user.", comment: "alert")
                    let alert = creatNormalAlert(alterMessage)
                    self.presentViewController(alert, animated: true, completion: nil)
                default:
                    let alterMessage = NSLocalizedString("Couldn't sign in,please check your network.", comment: "alert") + "\(error.code)"
                    let alert = creatNormalAlert(alterMessage)
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("\(error)")
                }
            } else {
                
                let spinnerView = SpinnerView.spinnerInView(self.view, animated: true)
                spinnerView.text = NSLocalizedString("Succeed", comment: "请稍后")
                
                let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appdelegate.userInfo = nil
                appdelegate.userInfo?.userData = nil
                appdelegate.notifications = nil
                appdelegate.userIsLogOut = false
                
                appdelegate.getAndInjectUserData()
                appdelegate.getAndInjectNotification()
              appdelegate.getPublishInMultipleThreads()
                
                afterDelay(0.1, closure: {self.dismissViewControllerAnimated(true, completion: nil)})
                
                
            }
//            }
//            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        
            NSNotificationCenter.defaultCenter().postNotificationName("needRefresh", object: nil)
        
        
    }
    
    @IBAction func noAccountBtn() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("SignIn View has deinited!")
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
