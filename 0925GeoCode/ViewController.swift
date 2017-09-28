//
//  ViewController.swift
//  0925GeoCode
//
//  Created by D7702_10 on 2017. 9. 25..
//  Copyright © 2017년 D7702_10. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var maps: MKMapView!
    
    //가변 배열 자동으로 어펜드
    //var yTitle = NSMutableArray()
    var Subts = NSMutableArray()
    //var Subts = [String]()
    //var Subts = ["1","2","3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        zoomToRegion()
        
        /////////////////////////////
        
        let path = Bundle.main.path(forResource: "PinList", ofType: "plist")
        print("path = \(String(describing: path))")
        
        let contents = NSArray(contentsOfFile: path!)
        print("path = \(String(describing: contents))")
        
        var annotations = [MKPointAnnotation]()
        
        maps.delegate = self
        
        // optional binding
        if let myItems = contents {
            // Dictionary Array에서 값 뽑기
            for item in myItems {
                let address = (item as AnyObject).value(forKey: "Address")
                let title = (item as AnyObject).value(forKey: "Title")
                let subT = (item as AnyObject).value(forKey: "SubTitle")
                
                Subts[(item as AnyObject).value(forKey: "count") as! Int] = subT as! String
                
                
                print("서브타이틀 = \(String(describing: subT))")
                print("카운터 = ", (item as AnyObject).value(forKey: "count") as Any)
                print("레벨 = ", Subts[(item as AnyObject).value(forKey: "count") as! Int])

                
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(address as! String, completionHandler: { placemarks, error in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let myPlacemarks = placemarks {
                        let myPlacemark = myPlacemarks[0]
                        
                        print("placemark[0] = \(String(describing: myPlacemark.name))")
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = title as? String
                        annotation.subtitle = address as? String
                        
                        
                     
                        
                        if let myLocation = myPlacemark.location {
                            annotation.coordinate = myLocation.coordinate
                            annotations.append(annotation)
                        }
                        
                    }
                    print("annotations = \(annotations)")
                    self.maps.showAnnotations(annotations, animated: true)
                    self.maps.addAnnotations(annotations)
                    
                })
            }
        } else {
            print("contents의 값은 nil")
        }
        
    }
    
    func zoomToRegion() {
        
        //  DIT 위치정보 35.166197, 129.072594
        let center = CLLocationCoordinate2DMake(35.166197, 129.072594)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(center, span)
        
        maps.setRegion(region, animated: true)
        
    }
    
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
            let identifier = "MyPin"
            var  annotationView = maps.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
    
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
    
                if annotation.title! == "시민공원" {
                    // 부시민공원
                    annotationView?.pinTintColor = UIColor.green
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named:"citizen_logo.png" )
                    annotationView?.leftCalloutAccessoryView = leftIconView
    
                } else if annotation.title! == "동의과학대" {
                    // 동의과학대학교
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
                    leftIconView.image = UIImage(named:"DIT_logo.png" )
                    annotationView?.leftCalloutAccessoryView = leftIconView
    
                } else {
                    // 송상현광장
                    annotationView?.pinTintColor = UIColor.blue
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
                    leftIconView.image = UIImage(named:"Songsang.png" )
                    annotationView?.leftCalloutAccessoryView = leftIconView
                }
            } else {
                annotationView?.annotation = annotation
            }
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
    
            return annotationView
    
        }
    
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
            print("callout Accessory Tapped!")
    
            let viewAnno = view.annotation
            let viewTitle: String = ((viewAnno?.title)!)!
            var viewSubTitle = ""
            
            if viewTitle == "송상현광장"{
                viewSubTitle = Subts[2] as! String
            }else if viewTitle == "시민공원"{
                viewSubTitle = Subts[1] as! String
            }else{
                viewSubTitle = Subts[0] as! String
            }
            
            //let viewExplain: String = ((viewAnno?.subtitle)!)!
            
            //print("\(viewTitle) \(viewSubTitle)")
            
            let ac = UIAlertController(title: viewTitle, message: viewSubTitle, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }

}

