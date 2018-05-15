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
    var items: [Item]!
    var markers : [GMSMarker] = []
    var circles : [GMSCircle] = []
    let colors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5491491866), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.5308219178), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 0.5367883134), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.5186483305), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.4916256421), #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.475973887)]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates a marker in the center of the map.
        var bounds = GMSCoordinateBounds()
        var i : Int = 0
        for item in self.items {
            let coord = item.location.coord!
            if item.location.coord.distance < 1 {
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
                marker.title = item.name
                marker.snippet = item.category.value
                
                bounds = bounds.includingCoordinate(marker.position)

                self.markers.append(marker)
            }
            else {
                let loc = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
                let circle = GMSCircle(position: loc , radius: item.location.coord.distance)
                circle.fillColor = self.colors[i]
                circle.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                bounds = bounds.includingCoordinate(circle.position)

                self.circles.append(circle)
            }
            i += 1
            if i >= colors.count {
                i = 0
            }
        }
        let camera = GMSCameraPosition.camera(withLatitude: items[0].location.coord!.latitude, longitude: items[0].location.coord!.longitude, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0 , 50.0 ,50.0 ,50.0)))
        for marker in self.markers{
            marker.map = mapView
        }
        for circle in self.circles{
            circle.map = mapView
        }
        view = mapView
        
        // Do any additional setup after loading the view.
    }
    func prepareModel(items: [Item]){
        self.items = items
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
