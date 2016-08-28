//
//  MapViewController.swift
//  Adam
//
//  Created by 周岩峰 on 6/14/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreData
import AVOSCloud

class MapViewController: UIViewController {
    
    lazy var locationManager = CLLocationManager()
    var currentUserLocation: CLLocationCoordinate2D?
    
    var publishs = [Publish]()
    var joinedClub = [Club]()
    var currentUser: User!
    
    var menuView: MenuView! {
        didSet {
            showUserWithRegion(2000)
        }
    }
    var showingPublish: Publish?
    
    var showingPublishs = [Publish]()
    
    var popViewNames = [String]()
    var popViewNames1 = [String]()
    var ninaSelectionView: NinaSelectionView!
    var ninaSelectionView1: NinaSelectionView!
    var popViewSecleted: String!
    
    
    let allClub = NSLocalizedString("All clubs", comment: "全部")
    let mostDelicious = NSLocalizedString("Most delicious", comment: "最美味的")
    let mostClean = NSLocalizedString("Most clean", comment: "")
    let mostBestPrice = NSLocalizedString("Best price", comment: "")
    let mostBestService = NSLocalizedString("Best Service", comment: "")
    let aLLnear = NSLocalizedString("All nearby", comment: "")
    
    var nextShowPublishs = [Publish]()
//    var nextShowPins = [PublishPin]()
    var showingPins = [PublishPin]()
    
    var needfresh: Bool! {
        didSet {
            popViewNames = [String]()
            for club in joinedClub {
                let clubName = club.name
                popViewNames.append(clubName)
            }
            
            //    popViewNames.append(allClub)
            
            popViewNames1 = [aLLnear,mostDelicious,mostClean,mostBestPrice,mostBestService]
            
            popViewNames.append(allClub)
            
            if ninaSelectionView != nil {
                ninaSelectionView = nil
            }
            if ninaSelectionView1 != nil {
                ninaSelectionView1 = nil
            }
            
            setupNinaView()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popViewNames = [String]()
        for club in joinedClub {
            let clubName = club.name
            popViewNames.append(clubName)
        }
        
    //    popViewNames.append(allClub)
        
        popViewNames1 = [aLLnear,mostDelicious,mostClean,mostBestPrice,mostBestService]
        
        popViewNames.append(allClub)
        
        setupNinaView()
        
        
        needfresh = false
        
        
//        for club in joinedClub {
//            let clubName = club.name
//            popViewNames.append(clubName)
//        }
        
        locationBtn.layer.cornerRadius = 5
        locationBtn.clipsToBounds = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        setupMap()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        showUserWithRegion(2000)
    }
    
    @IBAction func leftBarBtnTapped () {
        if !ninaSelectionView.hidden {
            ninaSelectionView.showOrDismissNinaViewWithDuration(0.3)
        }
        ninaSelectionView1.showOrDismissNinaViewWithDuration(0.5, usingNinaSpringWithDamping: 0.8, initialNinaSpringVelocity: 0.3)
//        showUserWithRegion(1000)
        
//        mapView.setRegion(region!, animated: true)
//        var annotations = [PublishPin]()
//        for publish in nextShowPublishs {
//            let annotation = PublishPin(publish: publish)
//            
//            annotations.append(annotation)
//        }
//        showingPins = annotations
//        mapView.addAnnotations(annotations)
//        let center = mapView.userLocation.coordinate
//        nextShowPublishs = getNeighbouringPublish(center, allPublishs: publishs, distance: 0.5)
//        let region = centerMapAndRange(mapView, atPosition: center, distance: 1500)
//        if let region = region {
//        addMapData(nextShowPublishs,zoomRegion: region)
//        }
        
    }
    
    @IBAction func rightBatItemBtnTapped () {
        if !ninaSelectionView1.hidden {
            ninaSelectionView1.showOrDismissNinaViewWithDuration(0.3)
        }
        ninaSelectionView.showOrDismissNinaViewWithDuration(0.5, usingNinaSpringWithDamping: 0.8, initialNinaSpringVelocity: 0.3)
    }
    
    @IBAction func testBtn() {
        showUserWithRegion(1000)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        requestUserLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMap() {
        mapView.showsScale = true
//        
        
        
        if !publishs.isEmpty {
        nextShowPublishs = [Publish]()
        let center = mapView.userLocation.coordinate
        let publishsInDistance = getNeighbouringPublish(center, allPublishs: publishs, distance: 0.5)
        nextShowPublishs = publishsInDistance
        let region = centerMapAndRange(mapView, atPosition: center, distance: 1500)
        if let region = region {
            addMapData(nextShowPublishs,zoomRegion: region)
        }
            return
        }
        
        let center = mapView.userLocation.coordinate
        
        centerMapAndRange(mapView, atPosition: center, distance: 1000)
    }
    
    func resetupMap() {
        
        removeMapAnnotation()
        let region = regionForAnnotations(nextShowPublishs)
        addMapData(nextShowPublishs, zoomRegion: region)
    }
    
    func showUserWithRegion (range: Double) {
        let range = CLLocationDistance(range)
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, range, range)
        mapView.setRegion(region, animated: true)
    }
    
    func removeMapAnnotation() {

        mapView.removeAnnotations(showingPins)
//        let annotations = [PublishPin]()
////        mapView.addAnnotations(mapView.annotations)
//        mapView.addAnnotations(annotations)
//        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
//        mapView.setRegion(region, animated: true)
        self.showingPins = [PublishPin]()
    }
    
    func addMapData(publishsToshow: [Publish], zoomRegion: MKCoordinateRegion) {
        removeMapAnnotation()
        mapView.setRegion(zoomRegion, animated: true)
        var annotations = [PublishPin]()
        for publish in publishsToshow {
        let annotation = PublishPin(publish: publish)
        mapView.addAnnotation(annotation)
        annotations.append(annotation)
        }
        showingPins = annotations
        
    }
    
    func publishsToPublishPins (publishs: [Publish]) -> [PublishPin] {
        var publishPins = [PublishPin]()
        for publish in publishs {
            let publishPin = PublishPin(publish: publish)
            publishPins.append(publishPin)
        }
        return publishPins
    }
    
    private func requestUserLocation() {
        mapView.showsUserLocation = true //1
        if CLLocationManager.authorizationStatus() ==
            .AuthorizedWhenInUse { // 2
            locationManager.requestLocation()   // 3
        } else {
            locationManager.requestWhenInUseAuthorization()   // 4
        }
    }
    

    

    
    func regionForAnnotations(publishsToshow : [Publish]) -> MKCoordinateRegion {
        var annotations = [MKAnnotation]()
        
        for publish in publishsToshow {
            let annotation = PublishPin(publish: publish)
            annotations.append(annotation)
        }
        
        var region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90,longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90,longitude: -180)
            
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude,annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude,annotation.coordinate.longitude)
                bottomRightCoord.latitude = min(bottomRightCoord.latitude,annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude,annotation.coordinate.longitude)
            }
            let center = CLLocationCoordinate2D(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2, longitude: topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace, longitudeDelta: abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
            
            region = MKCoordinateRegion(center: center, span: span)
        }
        return mapView.regionThatFits(region)
    }
    
    func getNeighbouringPublish(center: CLLocationCoordinate2D, allPublishs: [Publish], distance: Double) -> [Publish] {
//        let center = mapView.userLocation.coordinate
//        let span = MKCoordinateRegionMakeWithDistance(center, 2000, 2000)
        var getPublishs = [Publish]()
        for publish in allPublishs {
            let distanceLA = abs(publish.rstLocation.coordinate.latitude - center.latitude)
            let distanceLO = abs(publish.rstLocation.coordinate.longitude - center.longitude)
            
            if distanceLA <= distance && distanceLO <= distance {
                getPublishs.append(publish)
            }
        }
        
        return getPublishs
    }
    
    private func centerMapAndRange(map: MKMapView?, atPosition position: CLLocationCoordinate2D? , distance: Double) -> MKCoordinateRegion?{
        guard let map = map, let position = position else {
            return nil
        }
        
        map.setCenterCoordinate(position, animated: true)
        
        let zoomRegion = MKCoordinateRegionMakeWithDistance(position, distance, distance)
        return zoomRegion
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShowDetail" {
            let controller = segue.destinationViewController as! ShowDetailViewController
            controller.publish = showingPublish
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

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PublishPin else {
            return nil
        }
        
        let identifier = "PublishPinDetailView"
        
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        
        
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
        }
        
        annotationView?.annotation = annotation
//        annotationView!.image = annotation.pinview
        
        //set up pin color here
        if annotation.publish.reviewDishRate == 1 || annotation.publish.reviewPriceRate == 1 || annotation.publish.reviewCleannessRate == 1 || annotation.publish.othersRate == 1 {
            annotationView!.pinTintColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:1)
        } else if annotation.publish.reviewDishRate == 3 && annotation.publish.reviewPriceRate != 3 && annotation.publish.reviewCleannessRate != 3 && annotation.publish.othersRate != 3{
            annotationView!.pinTintColor = UIColor(red:248/255, green:89/255, blue:89/255, alpha:1)
            
        } else if annotation.publish.reviewDishRate != 3 && annotation.publish.reviewPriceRate == 3 && annotation.publish.reviewCleannessRate != 3 && annotation.publish.othersRate != 3 {
            annotationView!.pinTintColor = UIColor(red:241/255, green:247/255, blue:65/255, alpha:1)
        } else if annotation.publish.reviewDishRate != 3 && annotation.publish.reviewPriceRate != 3 && annotation.publish.reviewCleannessRate == 3 && annotation.publish.othersRate != 3 {
            annotationView!.pinTintColor = UIColor(red:20/255, green:161/255, blue:30/255, alpha:1)
        } else if annotation.publish.reviewDishRate != 3 && annotation.publish.reviewPriceRate != 3 && annotation.publish.reviewCleannessRate != 3 && annotation.publish.othersRate == 3 {
            annotationView!.pinTintColor = UIColor(red:245/255, green:158/255, blue:192/255, alpha:1)
        } else if annotation.publish.reviewDishRate != 3 && annotation.publish.reviewPriceRate != 3 && annotation.publish.reviewCleannessRate != 3 && annotation.publish.othersRate != 3 {
            annotationView!.pinTintColor = UIColor(red:160/255, green:160/255, blue:160/255, alpha:1)
            
        } else if annotation.publish.reviewDishRate == 1 || annotation.publish.reviewPriceRate == 1 || annotation.publish.reviewCleannessRate == 1 || annotation.publish.othersRate == 1 {
            annotationView!.pinTintColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:1)
        } else {
           annotationView!.pinTintColor = UIColor(red:251/255, green:5/255, blue:5/255, alpha:1)
        }
        
        //set up detail view here
        let detailView =
            UIView.loadFromNibNamed(identifier) as! PublishPinDetailView
        detailView.delegate = self
        detailView.publish = annotation.publish
        annotationView!.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView) {
        if let detailView =
            view.detailCalloutAccessoryView as? PublishPinDetailView {
            detailView.currentUserLocation = self.currentUserLocation
        }
    }
}

// MARK:- CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        currentUserLocation = locations.first?.coordinate
    }
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
}

extension MapViewController: NinaSelectionDelegate {
    func setupNinaView () {
        if ninaSelectionView1 == nil {
            
            ninaSelectionView1 = NinaSelectionView(titles: popViewNames1, popDirection: .FromBelowToTop)
            ninaSelectionView1.ninaSelectionDelegate = self
            ninaSelectionView1.defaultSelected = 1
            ninaSelectionView1.shadowEffect = true
            ninaSelectionView1.shadowAlpha = 0.5
            self.mapView.addSubview(ninaSelectionView1)
        }
        if ninaSelectionView == nil {
    
        ninaSelectionView = NinaSelectionView(titles: popViewNames, popDirection: .FromBelowToTop)
        ninaSelectionView.ninaSelectionDelegate = self
        ninaSelectionView.defaultSelected = 1
        ninaSelectionView.shadowEffect = true
        ninaSelectionView.shadowAlpha = 0.5
        self.mapView.addSubview(ninaSelectionView)
        }
    }
    
    func selectNinaAction(button: UIButton!) {
        if !ninaSelectionView.hidden {
        ninaSelectionView.showOrDismissNinaViewWithDuration(0.3)
        }
        if !ninaSelectionView1.hidden {
        ninaSelectionView1.showOrDismissNinaViewWithDuration(0.3)
        }
        popViewSecleted = button.titleLabel?.text
        
        switch popViewSecleted {
        case allClub:
            
            nextShowPublishs = publishs
            
            let region = regionForAnnotations(nextShowPublishs)
            
            addMapData(nextShowPublishs,zoomRegion: region)

            
        case aLLnear:
            nextShowPublishs = [Publish]()
            let center = mapView.userLocation.coordinate
            let publishsInDistance = getNeighbouringPublish(center, allPublishs: publishs, distance: 0.5)
            nextShowPublishs = publishsInDistance
            let region = centerMapAndRange(mapView, atPosition: center, distance: 1500)
            if let region = region {
                addMapData(nextShowPublishs,zoomRegion: region)
            }
        case mostDelicious:
            nextShowPublishs = [Publish]()
            let center = mapView.userLocation.coordinate
            let publishsInDistance = getNeighbouringPublish(center, allPublishs: publishs, distance: 0.5)
            for publish in publishsInDistance {
                if publish.reviewDishRate == 3 {
                    nextShowPublishs.append(publish)
                }
            }
            let region = centerMapAndRange(mapView, atPosition: center, distance: 1500)
            if let region = region {
                addMapData(nextShowPublishs,zoomRegion: region)
            }
            
        case mostBestPrice:
            nextShowPublishs = [Publish]()
            let center = mapView.userLocation.coordinate
            let publishsInDistance = getNeighbouringPublish(center, allPublishs: publishs, distance: 0.5)
            for publish in publishsInDistance {
                if publish.reviewPriceRate == 3 {
                    nextShowPublishs.append(publish)
                }
            }
            let region = centerMapAndRange(mapView, atPosition: center, distance: 1500)
            if let region = region {
                addMapData(nextShowPublishs,zoomRegion: region)
            }
            
        case mostClean:
            nextShowPublishs = [Publish]()
            let center = mapView.userLocation.coordinate
            let publishsInDistance = getNeighbouringPublish(center, allPublishs: publishs, distance: 0.5)
            for publish in publishsInDistance {
                if publish.reviewCleannessRate == 3 {
                    nextShowPublishs.append(publish)
                }
            }
            let region = centerMapAndRange(mapView, atPosition: center, distance: 1500)
            if let region = region {
                addMapData(nextShowPublishs,zoomRegion: region)
            }
            
        case mostBestService:
            nextShowPublishs = [Publish]()
            let center = mapView.userLocation.coordinate
            let publishsInDistance = getNeighbouringPublish(center, allPublishs: publishs, distance: 0.5)
            for publish in publishsInDistance {
                if publish.othersRate == 3 {
                    nextShowPublishs.append(publish)
                }
            }
            let region = centerMapAndRange(mapView, atPosition: center, distance: 1500)
            if let region = region {
                addMapData(nextShowPublishs,zoomRegion: region)
            }
            
        default:
            nextShowPublishs = [Publish]()
            for publish in publishs {
                
                for club in publish.publishedToClubs {
                    if club.name == popViewSecleted {
                        nextShowPublishs.append(publish)
                    }
                }
               
            }
            
            let region = regionForAnnotations(nextShowPublishs)
            
                addMapData(nextShowPublishs,zoomRegion: region)
            
        }
        
        
        
        print("\(popViewSecleted)")
//        resetupMap()
    }
    
}

extension MapViewController: PublishPinDetailViewDelegate {
    func detailBtnTapped(controlller: PublishPinDetailView, publish: Publish) {
        self.showingPublish = publish
        performSegueWithIdentifier("toShowDetail", sender: nil)
        
    }
}
