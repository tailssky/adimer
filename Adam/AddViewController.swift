//
//  AddViewController.swift
//  Adam
//
//  Created by 周岩峰 on 5/29/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter }()

class AddViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    var currentUser: User!
    var publish: Publish!
    
    var choosenToPublishClub: [Club]!
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: NSError?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: NSError?
    
//    @IBOutlet weak var longitudeLabel: UILabel!
//    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var getLocationButton: UIButton!
    
    @IBOutlet weak var isADswitch: UISwitch!
    
    @IBOutlet weak var newPublishPhoto: UIImageView!
   // @IBOutlet weak var newPublishText: UITextField!
    @IBOutlet weak var newPublishText: UITextView!
    @IBOutlet weak var newPublishDishName: UITextField!
    @IBOutlet weak var newPublishRstName: UITextField!
    
    @IBOutlet weak var dishSegmentedControl: UISegmentedControl!
    @IBOutlet weak var priceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cleannessSegmentedControl: UISegmentedControl!
    @IBOutlet weak var otherSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var publishContents = [PublishContent]()
    
    var isAD = false
    
//    var imagePicker = GKImagePicker()
    
    var textViewplaceholder = NSLocalizedString("Your review here.", comment: "")
    
    @IBAction func isADswitchChange () {
        isAD = isADswitch.on
    }
    
    @IBAction func segmentedChanged(sender: UISegmentedControl) {
       // print("semented changed\(sender.selectedSegmentIndex)")
    }
    
    @IBAction func pickNewPhoto () {
        
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save() {
        
        //display hud and dismiss the View
        
      //  saveToCoredata()
        if choosenToPublishClub.count > 0 {
            let spinnerView = SpinnerView.spinnerInView(navigationController!.view, animated: true)
            spinnerView.text = NSLocalizedString("Please wait", comment: "请稍后")
        //怎么只dismiss hud？ answer : afterDelay(0.6, closure: {hudView.removeFromSuperview()})
        if choosenToPublishClub.count != 0 {
        collectInfoToPublish()
            if currentUser.nickname != "" {
        publish.savePublishToServe(currentUser.nickname)
            }else{
                publish.savePublishToServe(currentUser.userName)
            }
        }
        afterDelay(0.1, closure: {self.dismissViewControllerAnimated(true, completion: nil)})
        } else {
            let alterMessage = NSLocalizedString("You need to create or join a club first.", comment: "alert")
            let alert = creatNormalAlert(alterMessage)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPublishPhoto.tag = 102
    
        
        dishSegmentedControl.selectedSegmentIndex = 1
        cleannessSegmentedControl.selectedSegmentIndex = 1
        priceSegmentedControl.selectedSegmentIndex = 1
        otherSegmentedControl.selectedSegmentIndex = 1
        
        newPublishText.delegate = self
        newPublishText.text = textViewplaceholder
        newPublishText.textColor = UIColor.lightGrayColor()
        
        
        choosenToPublishClub = currentUser.userData.clubsCreated + currentUser.userData.clubsJoined
        
        getLocation()
        
        let avcurrentUser = User.changeUserToAVuserForSever(currentUser)
        publish = Publish(publisher: avcurrentUser)
        
        //dateLabel.text = formatDate(NSDate())
        
        //gesture: hidekeyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddViewController.hideKeyboard(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    func formatDate(date: NSDate) -> String { return dateFormatter.stringFromDate(date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 1 || indexPath != nil && indexPath!.section == 1 && indexPath!.row == 1{
            return
        }
        
//        let subview = gestureRecognizer.view as? UITextView
//        if let subview = subview {
//            subview.clearsOnInsertion = true
//        }
        newPublishText.resignFirstResponder()
        newPublishDishName.resignFirstResponder()
        newPublishRstName.resignFirstResponder()
    }
    
    func collectInfoToPublish() {
        publish.isAD = isAD
        
        publish.restaurantName = newPublishRstName.text!
        if let location = location {
            publish.rstLocation = location
        } else {
            publish.rstLocation = CLLocation()
        }
        
        publish.dishName = newPublishDishName.text!
        publish.dishPhoto = newPublishPhoto.image!
        publish.reviewContent = newPublishText.text!
        
        publish.reviewDishRate = dishSegmentedControl.selectedSegmentIndex + 1
        publish.reviewPriceRate = priceSegmentedControl.selectedSegmentIndex + 1
        publish.reviewCleannessRate = cleannessSegmentedControl.selectedSegmentIndex + 1
        publish.othersRate = otherSegmentedControl.selectedSegmentIndex + 1
        //Unused
        publish.publishContentBelikedNum = 0
        publish.publishContentBeReadedNum = 0
        
        publish.publishedToClubs = choosenToPublishClub
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseClub" {
            let controller = segue.destinationViewController as! PickClubTableViewController
            controller.delegate = self
            controller.choosenClubs = self.choosenToPublishClub
            controller.clubsForChoose = self.currentUser.userData.clubsCreated + self.currentUser.userData.clubsJoined
        }
    }
    
    //MARK: - CoreData method
    
    func saveToCoredata () {
        let publishiContent = NSEntityDescription.insertNewObjectForEntityForName("PublishContent", inManagedObjectContext: managedObjectContext) as! PublishContent
        
        publishiContent.publishText = newPublishText.text
        publishiContent.grade = Int16(dishSegmentedControl.selectedSegmentIndex)
        publishiContent.userID = 0
        publishiContent.isAD = isAD
        if let location = location {
            publishiContent.location = location
        }
        publishiContent.date = NSDate()
        
        
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Error\(error)")
        }
        
        
        
    }
    
    //MARK: - About Locations method
    @IBAction func getLocation () {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .Denied || authStatus == .Restricted {
            showLocationServicesDeniedAlert()
            return
        }
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        
        updateLabels()
        configureButton()
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager () {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        updatingLocation = false
        
    }
    
    func configureButton() {
        if updatingLocation {
            getLocationButton.setTitle(NSLocalizedString("Getting..", comment: "get location button title"), forState: .Normal)
        } else {
            getLocationButton.setTitle(NSLocalizedString("My Location", comment: "get location button title"), forState: .Normal)
        }
    }
    
    func updateLabels () {
        if let location = location {
//            longitudeLabel.text = String(format: "%.2f", location.coordinate.longitude)
//            latitudeLabel.text = String(format: "%.2f", location.coordinate.latitude)
            if let placemark = placemark {
                addressLabel.text = stringFromPlacemark(placemark)
            } else if performingReverseGeocoding { addressLabel.text = NSLocalizedString("Searching for Address...", comment: "Adress label")
            } else if lastGeocodingError != nil { addressLabel.text = NSLocalizedString("Error Finding Address", comment: "Adress label")
            } else {
                addressLabel.text = NSLocalizedString("No Address Found", comment: "Adress label")
            }
        } else {
//            longitudeLabel.text = NSLocalizedString("", comment: "longitudelabel none content")
//            latitudeLabel.text = NSLocalizedString("", comment: "latitudelabel none content")
            addressLabel.text = NSLocalizedString("Tap 'Get Location' to get your location", comment: "AddressLabel none location content")
            
            //state message
            let stateMessage: String
            if let error = lastLocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    stateMessage = NSLocalizedString("Location Services Disabled", comment: "State Message")
                } else {
                    stateMessage = NSLocalizedString("Error getting location", comment: "")
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                    stateMessage = NSLocalizedString("Location Services Disabled", comment: "State Message")
            } else if updatingLocation {
                stateMessage = NSLocalizedString("Seaching...", comment: "State Message")
            } else {
                stateMessage = NSLocalizedString("Tap 'Get Location' to get your location", comment: "State Message")
            }
            
            addressLabel.text = stateMessage
        }
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        var line1 = ""
        if placemark.ISOcountryCode == "CN"{
//            if let s = placemark.administrativeArea {
//                line1 += s + " "
//            }
            if let s = placemark.locality { line1 += s + " "
            }
            if let s = placemark.subLocality {
                line1 += s
            }
            if let s = placemark.thoroughfare {
                line1 += s
            }
            if let s = placemark.subThoroughfare {
                line1 += s + " "
            }
            
        } else {
        if let s = placemark.subThoroughfare {
            line1 += s + " "
        }
        if let s = placemark.thoroughfare {
            line1 += s
        }
        
        if let s = placemark.subLocality {
            line1 += s
        }
        
        if let s = placemark.locality { line1 += s + " "
        }
        if let s = placemark.administrativeArea {
            line1 += s + " "
            }
        }
//        if let s = placemark.postalCode {
//            line2 += s }
//
        return line1
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                pickPhoto()
        }
        }
    
        
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        let subviews = cell?.contentView.subviews
//        for subview in subviews! {
//            var views = [UIView]()
//            let stackview = subview as? UIStackView
//            if let stackview = stackview {
//           let subviews1 = stackview.arrangedSubviews
//                for substackview in subviews1 {
//                    let substackviewsub = substackview as? UIStackView
//                    if let substackviewsub = substackviewsub {
//                       let view1 = substackviewsub.arrangedSubviews
//                        views += view1
//                        }
//                    
//                    }
//                }
//            
//            for subviewsub in views{
//                if subviewsub.tag == 102 {
//                    if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
//                        pickPhoto()
//            }
//            }
//        }
//        }
//        
//        if indexPath.row == 0 && indexPath.section == 1 &&  {
//            newPublishText.clearsOnInsertion = true
//            newPublishText.becomeFirstResponder()
//        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 1
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Location Services Disabled",comment:"location services denied alert,title"), message: NSLocalizedString("Please enable location services for this app in Settings.", comment: "ocation services denied alert,message"), preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "location services denied alert,button"), style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddViewController: UIImagePickerControllerDelegate {
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
//        let imagePicker = GKImagePicker()
//        imagePicker.cropSize = CGSizeMake(800, 600)
//        imagePicker.delegate = self
//        imagePicker.resizeableCropArea = true
//        imagePicker.imagePickerController.sourceType = .PhotoLibrary
//        presentViewController(imagePicker.imagePickerController, animated: true, completion: nil)
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        newPublishPhoto.image = info[UIImagePickerControllerEditedImage] as? UIImage
        newPublishPhoto.contentMode = UIViewContentMode.ScaleAspectFill
        newPublishPhoto.clipsToBounds = true
        
        publish.dishPhoto = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AddViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didfailwithEorror:\(error)")
        
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        
        stopLocationManager()
        updateLabels()
        configureButton()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpateLocations:\(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 { return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            updateLabels()
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
 //               addressLabel.text = "Done!"
                stopLocationManager()
                configureButton()
            }
        }
        
        if !performingReverseGeocoding {
            print("*** Going to geocode")
            performingReverseGeocoding = true
            geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                placemarks, error in
//                print("*** Found placemarks: \(placemarks), error: \(error)")
                self.lastGeocodingError = error
                if error == nil, let p = placemarks where !p.isEmpty { self.placemark = p.last! }
                else { self.placemark = nil }
                self.performingReverseGeocoding = false
                self.updateLabels()
            })
        }
    }
    
}

extension AddViewController: UINavigationControllerDelegate {
    
}

extension AddViewController: PickClubViewControllerDelegate {
    func pickClubViewHasChoosenClub(controller: PickClubTableViewController, choosenClub: [Club]) {
        self.choosenToPublishClub = choosenClub
    }
}

extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == textViewplaceholder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = textViewplaceholder
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
}

extension AddViewController: GKImagePickerDelegate {
    
    func imagePicker(imagePicker: GKImagePicker!, pickedImage image: UIImage!) {
        publish.dishPhoto = image
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        newPublishPhoto.image = image
        newPublishPhoto.contentMode = UIViewContentMode.ScaleAspectFill
        newPublishPhoto.clipsToBounds = true
        
        publish.dishPhoto = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
