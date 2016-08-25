//
//  SignUpViewController.swift
//  Adam
//
//  Created by 周岩峰 on 7/12/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBAction func signUpUser() {
        if  nameField.text == "" || passwordField.text == "" || retypePasswordField == "" || emailField.text == ""{
            
            let alert = creatNormalAlert(NSLocalizedString("Something Missing", comment: "sign up"))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if passwordField.text == retypePasswordField.text {
            let user = AVUser()
    
            user.username = nameField.text
            user.password = passwordField.text
            user.email = emailField.text
            
            if phoneNumber.text != "" {
                user.mobilePhoneNumber = phoneNumber.text
            }
            
            let image = UIImage(named: "defaultPortraitImage")
            let imageNSdata = UIImagePNGRepresentation(image!)
            let avfile = AVFile(name: "photo.png", data: imageNSdata)
            user.setObject(avfile, forKey: "userPortraitImage")
            
            
            user.setObject(0, forKey: "userEXP")
            user.setObject(0, forKey: "userLevel")
            user.setObject("", forKey: "nickName")
            user.setObject(0, forKey: "clubCreatedNum")
            user.setObject(0, forKey: "clubJoinedNum")
            user.setObject(2, forKey: "sex")
            
            
            user.signUpInBackgroundWithBlock({succeed, error in
                if succeed {
                    
                    let userdata = UserData(owner: user)
                    let avUserData = AVObject(className: "UserData", objectId: userdata.creatNewUserDataToServe())
                    user.setObject(avUserData, forKey: "userData")
                    user.saveInBackgroundWithBlock({succeed, errors in
                        if succeed{
                        
                    
                    dispatch_async(dispatch_get_main_queue(), {
                      let alert = UIAlertController(title: NSLocalizedString("Congratulations", comment: "alert"), message: NSLocalizedString("Sign up succeed!", comment: "alert"), preferredStyle: .Alert)
                        let alertActionOK = UIAlertAction(title: NSLocalizedString("OK", comment: "normal alert button OK"), style: .Default, handler: {(action: UIAlertAction) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)})
                        alert.addAction(alertActionOK)
                        self.presentViewController(alert, animated: true, completion: nil)
                            })
                            }
                        })
                
                
                    
                } else {
                    
                    self.showErrorMessage(error)
                }
            })

        } else {
            let alterMessage = NSLocalizedString("The typed password wasn't the same.", comment: "alert")
            let alert = creatNormalAlert(alterMessage)
            self.presentViewController(alert, animated: true, completion: nil)
                    }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - methrod
    
    func showErrorMessage(error: NSError) {
        if error.code == 202 {
            
            dispatch_async(dispatch_get_main_queue(), {
                let alert = creatNormalAlert(NSLocalizedString("user name has been used", comment: "sign up"))
                self.presentViewController(alert, animated: true, completion: nil)})
        } else if error.code == 203 {
            
            dispatch_async(dispatch_get_main_queue(), {
                let alert = creatNormalAlert(NSLocalizedString("email has been used", comment: "sign up"))
                self.presentViewController(alert, animated: true, completion: nil)})
        } else if error.code == 214 {
            
            dispatch_async(dispatch_get_main_queue(), {
                let alert = creatNormalAlert(NSLocalizedString("phone Number has been used", comment: "sign up"))
                self.presentViewController(alert, animated: true, completion: nil)})
        } else if error.code == 125 {
            
            dispatch_async(dispatch_get_main_queue(), {
                let alert = creatNormalAlert(NSLocalizedString("The email address was invalid", comment: "sign up"))
                self.presentViewController(alert, animated: true, completion: nil)})
        } else{
            let alterMessage = NSLocalizedString("Couldn't sign in,please check your network", comment: "alert")
            let alert = creatNormalAlert(alterMessage)
            self.presentViewController(alert, animated: true, completion: nil)
            
            print("\(error)")
            
        }
    }
    
    @IBAction func cancelBtnAction () {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    */

}
