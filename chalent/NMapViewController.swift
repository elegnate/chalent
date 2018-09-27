//
//  NMapViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 22..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit
import CoreLocation



class NMapViewController: UIViewController,
                          NMapViewDelegate,
                          NMapPOIdataOverlayDelegate,
                          MMapReverseGeocoderDelegate,
                          CLLocationManagerDelegate,
                          UITextFieldDelegate {
    
    
    var labelLocation: UILabel = {
        let label = UILabel()
        label.font = customFont(weight: .light, size: 14)
        //label.layer.zPosition = .greatestFiniteMagnitude
        label.textAlignment = .center
        label.textColor = ThemaColor.black
        label.text = "현재 위치"
        label.backgroundColor = ThemaColor.whiteTras90
        label.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        return label
    }()
    
    var imgviewMarker: UIImageView = {
        let imgview = UIImageView(image: #imageLiteral(resourceName: "pubtrans_exact_default"))
        imgview.heightAnchor.constraint(equalToConstant: 30)
        imgview.widthAnchor.constraint(equalToConstant: 30)
        return imgview
    }()
    
    var buttonSearch: UIButton = {
       let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.setImage(#imageLiteral(resourceName: "rightg"), for: .normal)
        button.cornerRadius = 25
        button.addTarget(self, action: #selector(pressSearch), for: .touchUpInside)
        button.backgroundColor = ThemaColor.red
        button.imageEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18)
        return button
    }()
    
    
    var mapView: NMapView?
    var constraintsMapView: [NSLayoutConstraint]?
    private var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = NMapView(frame: self.view.frame)
        self.navigationController?.navigationBar.isTranslucent = false
        
        if let mapView = mapView {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization() //권한 요청
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            // set the delegate for map view
            mapView.delegate = self
            
            // set the application api key for Open MapViewer Library
            mapView.setClientId("AixvaorqYfsGlqo1sHXY")
            mapView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
            mapView.reverseGeocoderDelegate = self
            
            mapView.layer.addBorder([.top], color: ThemaColor.darkgray, width: 0.5)
            
            view.addSubview(mapView)
            constraintsMapView = mapView.anchorSideEqualToConstant(view: view, top: 45, bottom: 0, leading: view.frame.width, trailing: view.frame.width)
            mapView.addSubview(labelLocation)
            mapView.addSubview(imgviewMarker)
            mapView.addSubview(buttonSearch)
            _ = labelLocation.anchorSideEqualToConstant(view: mapView, top: 0.5, bottom: -999, leading: 0, trailing: 0)
            imgviewMarker.anchorBalanceEqualToConstant(view: mapView, horizontal: 0, vertical: -15)
            _ = buttonSearch.anchorSideEqualToConstant(view: mapView, top: -999, bottom: -20, leading: -999, trailing: -20)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView?.viewDidAppear()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[locations.count - 1].coordinate
        mapView?.setMapCenter(NGeoPoint(longitude: loc.longitude, latitude: loc.latitude), atLevel:11)
        manager.stopUpdatingLocation()
    }
    
    // 경위도에서 주소로 변환
    public func location(_ location: NGeoPoint, didFind placemark: NMapPlacemark!) {
        labelLocation.text = "\(placemark.doName!) \(placemark.siName!)"
        /*CLGeocoder().geocodeAddressString(labelLocation.text!) { (placemarks, error) in
            if let placemark = placemarks?.first, let loc = placemark.location {
                self.mapView?.setMapCenter(NGeoPoint(longitude: loc.coordinate.longitude, latitude: loc.coordinate.latitude))
            }
        }*/
    }
    
    func location(_ location: NGeoPoint, didFailWithError error: NMapError!) {
        //
    }
    
    
    public func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    // 맵의 중앙이 바뀔 때 마다 호출
    func onMapView(_ mapView: NMapView!, didChangeMapCenter location: NGeoPoint) {
        // find the place address
        mapView.findPlacemark(atLocation: location)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func pressSearch() {
        if let parent = presentingViewController {
            if parent.restorationIdentifier == "TabBarVC" {
                let tab = parent as! UITabBarController
                let vc = tab.viewControllers![1] as! SearchViewController
                vc.searchLocation = labelLocation.text!
            } else if parent.restorationIdentifier == "SignUpVC" {
                let vc = parent as! SignUpViewController
                vc.textfieldAddress.text = labelLocation.text
                vc.editRequiredFiledCheck(.address, isAdd: true)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
