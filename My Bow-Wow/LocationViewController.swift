import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var detailList: UIBarButtonItem!
    var tf: UITextField!
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            tf.resignFirstResponder()
            //맵뷰의 마커를 전부 삭제.
            mapView.removeAnnotations(mapView.annotations)
            //배열의 데이터를 삭제(중요): 안하고 추가하면 계속 누적됨.
            matchingItems.removeAll()
            tf.text = "Pet hospital"
            let request = MKLocalSearch.Request()
            // 검색어 설정
            request.naturalLanguageQuery = tf.text
            // 검색할 영역 설정
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start(completionHandler: {(response: MKLocalSearch.Response!, error: Error!) in
                if error != nil {
                    let alert = UIAlertController(title: "Notice", message: "No results were found.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                    print("검색 결과가 없습니다.")
                    print("에러가 발생하였습니다.")
                } else if response.mapItems.count == 0 {
                    let alert = UIAlertController(title: "Alert", message: "No results", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                    print("검색 결과가 없습니다.")
                } else {
                    for item in response.mapItems as [MKMapItem] {
                        if item.name != nil {
                            print("이름:\(item.name!)")
                        }
                        if item.phoneNumber != nil {
                            print("전화번호:\(item.phoneNumber!)")
                        }
                        self.matchingItems.append(item as MKMapItem)
                        print("Matching items = \(self.matchingItems.count)")
                        //지도에 마커(marker)를 출력
                        let annotation = MKPointAnnotation()
                        //위치에 어노테이션을 표시.
                        annotation.coordinate = item.placemark.coordinate
                        print(annotation.coordinate)
                        annotation.title = item.name
                        annotation.subtitle = item.phoneNumber
                        self.mapView.addAnnotation(annotation)
                        self.detailList.isEnabled = true 
                    }
                }
            })
        } else {
            detailList.isEnabled = false 
            mapView.removeAnnotations(mapView.annotations)
            //배열의 데이터를 삭제(중요): 안하고 추가하면 계속 누적됨.
            matchingItems.removeAll()
            tf.text = nil
            tf.placeholder = "Type puppy toy shop or playgrounds"
            tf.becomeFirstResponder()
            tf.addTarget(self, action: #selector(search), for: .editingDidEndOnExit)
        }
    }
    @IBOutlet weak var mapView: MKMapView!
    //검색결과를 저장할 배열.
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    @objc func search() {
//        tf.text = nil
        //tf.placeholder = "Type cat toy shops or cat playgrounds"
        //tf.becomeFirstResponder()
        //tx.resignFirstResponder()
        //맵뷰의 마커를 전부 삭제.
        mapView.removeAnnotations(mapView.annotations)
        //배열의 데이터를 삭제(중요): 안하고 추가하면 계속 누적됨.
        matchingItems.removeAll()
        // 요청 객체를 생성
        let request = MKLocalSearch.Request()
        // 검색어 설정
        request.naturalLanguageQuery = tf.text
        // 검색할 영역 설정
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response: MKLocalSearch.Response!, error: Error!) in
            if error != nil {
//                let alert = UIAlertController(title: "Notice", message: "No results were found.", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                alert.addAction(ok)
//                self.present(alert, animated: true)
//                print("검색 결과가 없습니다.")
//                print("에러가 발생하였습니다.")
            
            } else if response.mapItems.count == 0 {
                let alert = UIAlertController(title: "Alert", message: "No results", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true)
                print("검색 결과가 없습니다.")
            } else {
                for item in response.mapItems as [MKMapItem] {
                    if item.name != nil {
                        print("이름:\(item.name!)")
                    }
                    if item.phoneNumber != nil {
                        print("전화번호:\(item.phoneNumber!)")
                    }
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    //지도에 마커(marker)를 출력
                    let annotation = MKPointAnnotation()
                    //위치에 어노테이션을 표시.
                    annotation.coordinate = item.placemark.coordinate
                    print(annotation.coordinate)
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    self.mapView.addAnnotation(annotation)
                    self.detailList.isEnabled = true
                }
            }
        })
    }
    lazy var locationManager: CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        m.desiredAccuracy = kCLLocationAccuracyBest
        return m
    }()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ResultTableViewController
        destination.mapItems = self.matchingItems
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //detailList.isEnabled = false
        //매번 확인을 해야 함.
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                updateLocation()
            case .denied, .restricted:
                // 에러 처리 (경고장 표시)
                break
            @unknown default:
                break
            }
        } else {
            // 경고창 표시(에러 처리)
        }
        let request = MKLocalSearch.Request()
        // 검색어 설정
        request.naturalLanguageQuery = tf.text
        // 검색할 영역 설정
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response: MKLocalSearch.Response!, error: Error!) in
            if error != nil {
//                let alert = UIAlertController(title: "Notice", message: "No results were found.", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(ok)
//                self.present(alert, animated: true)
//                print("검색 결과가 없습니다.")
//                print("에러가 발생하였습니다.")
            } else if response.mapItems.count == 0 {
                let alert = UIAlertController(title: "Alert", message: "No results", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true)
                print("검색 결과가 없습니다.")
            } else {
                for item in response.mapItems as [MKMapItem] {
                    if item.name != nil {
                        print("이름:\(item.name!)")
                    }
                    if item.phoneNumber != nil {
                        print("전화번호:\(item.phoneNumber!)")
                    }
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    //지도에 마커(marker)를 출력
                    let annotation = MKPointAnnotation()
                    //위치에 어노테이션을 표시.
                    annotation.coordinate = item.placemark.coordinate
                    print(annotation.coordinate)
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    self.mapView.addAnnotation(annotation)
                    self.detailList.isEnabled = true
                }
            }
        })
        //initTitleInput()
        mapView.delegate = self
        //txtSearch.becomeFirstResponder()
        
        
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
    }
    //func initTitleInput() {
    //        tf = UITextField(frame: CGRect(x:0, y:0, width: 300, height: 35))
    //        tf.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    //        tf.borderStyle = .roundedRect
    //        tf.font = .systemFont(ofSize: 13)
    //        tf.autocapitalizationType = .none
    //        tf.autocorrectionType = .no
    //        tf.spellCheckingType = .no
    //        tf.clearButtonMode = .whileEditing
    //        tf.text = "맛집"
    //        tf.addTarget(self, action: #selector(search), for: .editingDidEndOnExit)
    //tf.layer.borderWidth = 0.3
    
    //tf.layer.borderColor = UIColor(red:0.60, green:0.60, blue: 0.60, alpha:1.0).cgColor
    //       self.navigationItem.titleView = tf
    //  }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailList.isEnabled = false
        tf = UITextField(frame: CGRect(x:0, y:0, width: 300, height: 35))
        tf.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 13)
        tf.textColor = #colorLiteral(red: 0.5789041519, green: 0.3935802579, blue: 0.3027411699, alpha: 1)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearButtonMode = .whileEditing
        tf.text = "Pet hospital"
        //tf.addTarget(self, action: #selector(search), for: .editingDidEnd)
        self.navigationItem.titleView = tf
    }
}



extension LocationViewController: CLLocationManagerDelegate {
    func updateLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapView.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}

//extension LocationViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        mapView.centerCoordinate = userLocation.location!.coordinate
//    }
//}

