//
//  PublishPinDetailView.swift
//  Adam
//
//  Created by 周岩峰 on 8/10/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import Foundation
import MapKit

class PublishPinDetailView: UIView {
    var currentUserLocation: CLLocationCoordinate2D?
    var publish: Publish! {
        didSet {
            dishReview.text = publish.reviewContent
            restaurantName.text = publish.dishName
            dishImage.image = publish.dishPhoto
            updataDishRate()
            updataCleanRate()
            updataPriceRate()
            updataOtherRate()
        }
    }
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var dishReview: UILabel!
    
    @IBOutlet var dishRateImages: [UIImageView]!
    @IBOutlet var priceRateImages: [UIImageView]!
    @IBOutlet var cleanRateImages: [UIImageView]!
    @IBOutlet var otherRateImages: [UIImageView]!
    @IBOutlet weak var dishRateLabel: UILabel!
    @IBOutlet weak var priceRateLabel: UILabel!
    @IBOutlet weak var cleanRateLabel: UILabel!
    @IBOutlet weak var otherRateLabel: UILabel!
    
    weak var delegate: PublishPinDetailViewDelegate?
    
    
    override func awakeFromNib() {
        
        
    }
    
    @IBAction func detailBtnAction() {
        delegate?.detailBtnTapped(self,publish: publish)
    }
    
    @IBAction func gpsNavigationBtnTapped() {
        openTransitDirectionsForCoordinates(PublishPin(publish: publish).coordinate)
    }
    
    private func updataDishRate () {
        dishRateLabel.text = NSLocalizedString("Delicious", comment: "美味度")
        let  count1 = publish.reviewDishRate
        if count1 == 1 {
            dishRateImages[0].image = UIImage(named: "death")
            dishRateImages[1].image = UIImage(named: "death")
            dishRateImages[2].image = UIImage(named: "death")
        }
        var count = count1

        for imageView in dishRateImages {
            if (count > 0) {
                imageView.hidden = false
                count -= 1
            } else {
                imageView.hidden = true
            }
        }
    }
    
    private func updataPriceRate () {
        priceRateLabel.text = NSLocalizedString("Cost", comment: "价格指数")
        let count1 = publish.reviewPriceRate
        if count1 == 1 {
            priceRateImages[0].image = UIImage(named: "death")
            priceRateImages[1].image = UIImage(named: "death")
            priceRateImages[2].image = UIImage(named: "death")
        }
        var count = count1
        for imageView in priceRateImages {
            if (count > 0) {
                imageView.hidden = false
                count -= 1
            } else {
                imageView.hidden = true
                
            }
        }
        
    }
    
    private func updataCleanRate () {
        cleanRateLabel.text = NSLocalizedString("Cleanness", comment: "卫生指数")
        let  count1 = publish.reviewCleannessRate
        if count1 == 1 {
            cleanRateImages[0].image = UIImage(named: "death")
            cleanRateImages[1].image = UIImage(named: "death")
            cleanRateImages[2].image = UIImage(named: "death")
        }
        var count = count1
        
        for imageView in cleanRateImages {
            if (count > 0) {
                imageView.hidden = false
                count -= 1
            } else {
                imageView.hidden = true
            }
        }
    }
    
    private func updataOtherRate () {
        otherRateLabel.text = NSLocalizedString("Service", comment: "服务指数")
        let  count1 = publish.othersRate
        if count1 == 1 {
            otherRateImages[0].image = UIImage(named: "death")
            otherRateImages[1].image = UIImage(named: "death")
            otherRateImages[2].image = UIImage(named: "death")
        }
        var count = count1
      
        for imageView in otherRateImages {
            if (count > 0) {
                imageView.hidden = false
                count -= 1
            } else {
                imageView.hidden = true
            }
        }
    }
    
    //MARK:- Transit Helpers
    func openTransitDirectionsForCoordinates(coord:CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coord,
                                    addressDictionary: publish.addressDictionary) // 1
        let mapItem = MKMapItem(placemark: placemark)  // 2
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeTransit]  // 3
        mapItem.openInMapsWithLaunchOptions(launchOptions)  // 4
    }
    
//    func requestTransitTimes() {
//        guard let currentUserLocation = currentUserLocation else {
//            return
//        }
//
//        let request = MKDirectionsRequest()
//        
//        let source = MKMapItem(placemark:
//            MKPlacemark(coordinate: currentUserLocation,
//                addressDictionary: nil))
//        let destination = MKMapItem(placemark:
//            MKPlacemark(coordinate: publish.rstLocation.coordinate,
//                addressDictionary: nil))
//    
//        request.source = source
//        request.destination = destination
//        request.transportType = MKDirectionsTransportType.Transit
//        
//        let directions = MKDirections(request: request)
//        directions.calculateETAWithCompletionHandler { response, error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//             
////                self.updateEstimatedTimeLabels(response)
//            }
//        }
//    }

    
}
protocol PublishPinDetailViewDelegate: class {
    func detailBtnTapped(controlller: PublishPinDetailView, publish: Publish)
}
