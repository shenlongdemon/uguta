//
//  ProductMapViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 5/14/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class ProductMapViewController: BaseViewController {
    var item: Item!
    override func viewDidLoad() {
        super.viewDidLoad()
        var coord = item.location.coord!
        let camera = GMSCameraPosition.camera(withLatitude: coord.latitude, longitude: coord.longitude, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
        marker.title = self.item.name
        marker.snippet = self.item.category.value
        marker.map = mapView
        // Do any additional setup after loading the view.
    }
    func prepareModel(item: Item){
        self.item = item
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
