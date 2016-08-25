//
//  CreateNewClubTableViewController.swift
//  Adam
//
//  Created by 周岩峰 on 8/11/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit

class CreateNewClubTableViewController: UITableViewController {
    
    var creater: User!
    var newClub: Club?
    var needRefresh = false
    
    
    @IBOutlet weak var newClubImage: UIImageView!
    @IBOutlet weak var newClubName: UITextField!

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
    
    @IBAction func createClubBtnTapped () {
        if let clubNmae = newClubName.text  {
            if clubNmae != "" {
                let spinnerView = SpinnerView.spinnerInView(navigationController!.view, animated: true)
                spinnerView.text = NSLocalizedString("Please wait", comment: "Hud text,published")
               let succeed =  creatNewClubForThisAccount(clubNmae, clubImage: newClubImage.image!)
                guard succeed else {
                    afterDelay(0.1, closure: {spinnerView.removeFromSuperview()})
                    let view1 = spinnerView.superview
                    view1!.userInteractionEnabled = true
                    
                    let hudView = HudView.hudInView(navigationController!.view, animated: true)
                    hudView.text = NSLocalizedString("Create failed", comment: "创建失败")
                    afterDelay(0.6, closure: {hudView.removeFromSuperview()})
                    let view = hudView.superview
                    view!.userInteractionEnabled = true
                    return
                }
                
                //
                afterDelay(0.1, closure: {spinnerView.removeFromSuperview()})
                let view1 = spinnerView.superview
                view1!.userInteractionEnabled = true
                
                let hudView = HudView.hudInView(navigationController!.view, animated: true)
                hudView.text = NSLocalizedString("Created", comment: "Hud text,Created")
                self.needRefresh = true
                afterDelay(0.6, closure: {})
                let view = hudView.superview
                view!.userInteractionEnabled = true
                dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        } else {
            let alertMessage = NSLocalizedString("Please name your club", comment: "请输入名字")
            creatNormalAlert(alertMessage)
        }
    }
    
    @IBAction func cancelBntTapped () {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func creatNewClubForThisAccount (clubName: String, clubImage: UIImage) -> Bool {
        if let user = creater {
            let avuser = User.changeUserToAVuserForSever(user)
            let newClub = Club(clubCeater: avuser, clubName: clubName, clubImage: clubImage)
            self.newClub = newClub
            let result = Club.creatNewClubToSever(newClub)
            //            self.userInfo = addNewClubToUser(user, newClub: newClub)
            return result
        }
        return false
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && indexPath.section == 0{
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                pickPhoto()
            }
        }
//        else if indexPath.row == 0 && indexPath.section == 0 && view.tag == 103{
//            newClubName.becomeFirstResponder()
//        }
//        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

}

extension CreateNewClubTableViewController: UIImagePickerControllerDelegate {
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
        newClubImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        newClubImage.contentMode = UIViewContentMode.ScaleAspectFill
        newClubImage.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CreateNewClubTableViewController: UINavigationControllerDelegate {
    
}
