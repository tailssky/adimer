//
//  ShowDetailViewController.swift
//  Adam
//
//  Created by 周岩峰 on 8/19/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var publishPhoto: UIImageView!
    @IBOutlet weak var publisherPhoto: UIImageView!
    @IBOutlet weak var publisherName: UILabel!
    @IBOutlet weak var publishedTime: UILabel!
    @IBOutlet weak var isInterested: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var reviewContent: UILabel!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var uiView: UIView!
    
    @IBOutlet weak var publishContentStackView: UIStackView!
    
    @IBOutlet weak var dishRate: UILabel!
    @IBOutlet weak var cleanessRate: UILabel!
    @IBOutlet weak var priceRate: UILabel!
    @IBOutlet weak var otherRate: UILabel!
    
    @IBOutlet var dishRateImages: UIImageView!
    @IBOutlet var priceRateImages: UIImageView!
    @IBOutlet var cleanRateImages: UIImageView!
    @IBOutlet var otherRateImages: UIImageView!
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: NSError?
    
    var publish: Publish!
    var publisher: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        publisher = User.changerAVUserToUserNoAuthority(avPublisher)
        
        setupUI()
        //let w = self.uiView.frame.width
        
      //  scrollview.contentSize.width = self.uiView.frame.width
    //    scrollview.contentSize.height = self.uiView.frame.height
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         let avPublisher = publish.publisher
        publisher = User.changerAVUserToUserNoAuthority(avPublisher)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        publishPhoto.layer.cornerRadius = 20
        publishPhoto.clipsToBounds = true
        
        publisherPhoto.layer.cornerRadius = publisherPhoto.bounds.width/2
        publisherPhoto.clipsToBounds = true
        
        if publish.isAD {
            isInterested.hidden = false
        } else {
            isInterested.hidden = true
        }
        
        publishPhoto.image = publish.dishPhoto
        
        if let publisher = publisher {
            publisherPhoto.image = publisher.userPortraitImage
        } else {
            publisherPhoto.image = UIImage(named: "defaultPortraitImage")
        }
        
        publisherName.text = publish.publisherName
        
        if publish.reviewDishRate == 1 {
            dishRateImages.image = UIImage(named: "death")
        }
        if publish.reviewCleannessRate == 1 {
            cleanRateImages.image = UIImage(named: "death")
        }
        if publish.reviewPriceRate == 1 {
            priceRateImages.image = UIImage(named: "death")
        }
        if publish.othersRate == 1 {
            otherRateImages.image = UIImage(named: "death")
        }
        
        let forrmatter = NSDateFormatter()
        forrmatter.dateStyle = .MediumStyle
        let date = forrmatter.stringFromDate(publish.publishTime!)
        publishedTime.text = NSLocalizedString("Published at:", comment: "发表于：") + date
        
        restaurantName.text = NSLocalizedString("Restaurant name: ",comment: "店名") + publish.restaurantName
        reviewContent.text = NSLocalizedString("comment:",comment:"短评") + "\n \(publish.reviewContent)"
        dishName.text = NSLocalizedString("Dish name:", comment: "推荐：") + publish.dishName
        
        dishRate.text = NSLocalizedString("Dish rate:", comment: "美味：") + "\(publish.reviewDishRate)"
        cleanessRate.text = NSLocalizedString("Cleanness rate:", comment: "卫生：") + "\(publish.reviewCleannessRate)"
        priceRate.text = NSLocalizedString("Price rate:", comment: "性价比：") + "\(publish.reviewPriceRate)"
        otherRate.text = NSLocalizedString("Serves rate:", comment: "服务：") + "\(publish.othersRate)"
        
        dishName.sizeToFit()
        reviewContent.sizeToFit()
        reviewContent.preferredMaxLayoutWidth = uiView.frame.width - 8
        
        getGeocode()
        
        //        publishContentStackView.bounds.height = dishName.frame.height + 5 + reviewContent.frame.height
        
    }
    
    @IBAction func cancelBntTapped () {
        dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func showLocationBtnAction() {
        performSegueWithIdentifier("toShowLocation", sender: nil)
    }
    
    //MARK: - GeoCode 
    func updateLabels () {
        
            
            if let placemark = placemark {
                addressLabel.text = stringFromPlacemark(placemark)
            } else if performingReverseGeocoding { addressLabel.text = NSLocalizedString("Searching for Address...", comment: "Adress label")
            } else if lastGeocodingError != nil { addressLabel.text = NSLocalizedString("Error Finding Address", comment: "Adress label")
            } else {
                addressLabel.text = NSLocalizedString("No Address Found", comment: "Adress label")
        }
        
            //state message
    
    }

    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        var line1 = ""
        if placemark.ISOcountryCode == "CN"{
            if let s = placemark.administrativeArea {
                line1 += s + " "
            }
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
        
        return line1
    }
    
    func getGeocode() {
        if !performingReverseGeocoding {
            print("*** Going to geocode")
            performingReverseGeocoding = true
            geocoder.reverseGeocodeLocation(publish.rstLocation, completionHandler: {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShowLocation" {
            let controller = segue.destinationViewController as! DetailMapViewController
            controller.publish = publish
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
