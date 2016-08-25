//
//  DetailMapViewController.swift
//  Adam
//
//  Created by 周岩峰 on 8/23/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import MapKit

class DetailMapViewController: UIViewController ,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var locationManager = CLLocationManager()
    var currentUserLocation: CLLocationCoordinate2D?
    var publish: Publish!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        mapView.delegate = self
        mapView.mapType = .Standard
        
        addAnnotation()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAnnotation () {
        let publishPin = PublishPin(publish: self.publish)
        mapView.addAnnotation(publishPin)
        let region = MKCoordinateRegionMakeWithDistance(publishPin.coordinate, 800, 800)
        mapView.setRegion(region, animated: true)
        
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

extension DetailMapViewController: CLLocationManagerDelegate{
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
