//
//  EditUserInfoTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 7/13/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class EditUserInfoTableViewController: UITableViewController {
    
    weak var delegate: EditUserInfoTableViewControllerDelegate?
    
    @IBOutlet weak var userNewPortrait: UIImageView!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var newNickname: UITextField!
    
    @IBOutlet weak var phoneNumUILable: UILabel!
    @IBOutlet weak var emailUILable: UILabel!
    @IBOutlet weak var phonenumNameUILable1: UILabel!
    @IBOutlet weak var emaiNameUILable1: UILabel!
    @IBOutlet weak var nicknameNameUILable1: UILabel!
    @IBOutlet weak var changePasswordUILable1: UILabel!
    
    var needRefresh = false
    
    var newUser: User!
    var userHasLogOut = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNewPortrait.image = newUser.userPortraitImage
        
        phoneNumUILable.sizeToFit()
        emailUILable.sizeToFit()
        phonenumNameUILable1.sizeToFit()
        emaiNameUILable1.sizeToFit()
        nicknameNameUILable1.sizeToFit()
        changePasswordUILable1.sizeToFit()
        
        phoneNumUILable.text = newUser.phoneNumber
        emailUILable.text = newUser.email
        
        logOutBtn.sizeToFit()
       
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditUserInfoTableViewController.hideKeyboard(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
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
    
    @IBAction func save() {
        saveToChangeUserInfo()
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        hudView.text = NSLocalizedString("Saved!", comment: "Hud text,published")
        
        afterDelay(1, closure: {self.delegate?.editUserInfoTableViewControllerDidSaved(self, userData: self.newUser)})
        
        
    }
    
    @IBAction func cancel() {
        delegate?.editUserInfoTableViewControllerDidCancel(self)
    }
    
    func saveToChangeUserInfo() {
        if newUser.userID == AVUser.currentUser().objectId {
        if newNickname.text != ""{
        
            let avUserQurey = AVQuery(className: "_User")
            avUserQurey.whereKey("objectId", equalTo: newUser.userID)
            let avUser = avUserQurey.getFirstObject() as! AVUser
            avUser.sessionToken = AVUser.currentUser().sessionToken
            
            avUser.setObject(newNickname.text, forKey: "nickName")
            
            let image1 = userNewPortrait.image!
            let image = image1.resizedImageWithBounds(CGSize(width: 500, height: 500))
            let imageNSdata = UIImagePNGRepresentation(image)
            let avfile = AVFile(name: "photo.png", data: imageNSdata)
            avUser.setObject(avfile, forKey: "userPortraitImage")
            
            avUser.saveEventually({_ , error in
                if error != nil {
                    print("\(error)")
                }})
                } else {
            let avUserQurey = AVQuery(className: "_User")
            avUserQurey.whereKey("objectId", equalTo: newUser.userID)
            let avUser = avUserQurey.getFirstObject() as! AVUser
            avUser.sessionToken = AVUser.currentUser().sessionToken
            
            let image1 = userNewPortrait.image!
            let image = image1.imageByScalingToSize(CGSize(width: 500, height: 500))
            let imageNSdata = UIImagePNGRepresentation(image)
            let avfile = AVFile(name: "photo.png", data: imageNSdata)
            avUser.setObject(avfile, forKey: "userPortraitImage")
            
            avUser.saveEventually({_ , error in
                if error != nil {
                    print("\(error)")
                            }})
            }
        } else {
                    
        let alterMessage = NSLocalizedString("Error!", comment: "alert")
                    let alert = creatNormalAlert(alterMessage)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
    }
    
    @IBAction func someBtnTapped () {
//        needRefresh = true
        AVUser.logOut()
        
        needRefresh = true
        userHasLogOut = true
        
        delegate?.editUserInfoTableViewControllerDidLogOut(self, isUserLogOut: userHasLogOut)
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                pickPhoto()
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if indexPath != nil && indexPath!.section == 2 && indexPath!.row == 0/* || indexPath != nil && indexPath!.section == 1 && indexPath!.row == 1*/{
            return
        }
        newNickname.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toChangePassword" {
            let navcontroller = segue.destinationViewController as!UINavigationController
            let controller = navcontroller.viewControllers[0] as! ChangePasswordTableViewController
            controller.newUser = newUser
        }
    }

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
    
    deinit {
        print("Edituser info view has deinit")
    }

}

protocol EditUserInfoTableViewControllerDelegate: class {
    func editUserInfoTableViewControllerDidSaved (controller: EditUserInfoTableViewController, userData: User)
    func editUserInfoTableViewControllerDidCancel (controller: EditUserInfoTableViewController)
    func editUserInfoTableViewControllerDidLogOut (controller: EditUserInfoTableViewController, isUserLogOut: Bool)
}

extension EditUserInfoTableViewController: UIImagePickerControllerDelegate {
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) { showPhotoMenu() }
        else { choosePhotoFromLibrary() }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "'choose form camera or library' alert, cancel"), style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: "'choose form camera or library' alert, TAKE photo"), style: .Default, handler: {_ in self.takePhotoWithCamera()})
        alertController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title:
            NSLocalizedString("Choose From Library", comment: "'choose from camera or library' alert, choose from library"), style: .Default, handler: {_ in self.choosePhotoFromLibrary()})
        alertController.addAction(chooseFromLibraryAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        userNewPortrait.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        userNewPortrait.contentMode = UIViewContentMode.ScaleAspectFill
        userNewPortrait.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension EditUserInfoTableViewController: UINavigationControllerDelegate {
    
}
