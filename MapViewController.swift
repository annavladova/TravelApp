

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var closure: ((CGPoint) -> Void)?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(sender:)))
        mapView.addGestureRecognizer(longTapGesture)
    }
    
    @objc func longTap(sender: UIGestureRecognizer) {
        if sender.state == .began {
            mapView.removeAnnotations(mapView.annotations)
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationOnMap
            mapView.addAnnotation(annotation)
            let point = CGPoint(x: locationOnMap.latitude.rounded(2), y: locationOnMap.longitude.rounded(2))
            
            closure?(point)
        }
    }
}




