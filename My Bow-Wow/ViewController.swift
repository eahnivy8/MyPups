import UIKit
import WebKit
import GoogleMobileAds

struct Puppy: Codable {
    let message: String
}
class ViewController: UIViewController, WKNavigationDelegate {
    
    var interstitial: GADInterstitial!
    var interstitial1: GADInterstitial!
    @IBOutlet weak var bannerView1: GADBannerView!
    @IBOutlet weak var puppyWebView: WKWebView!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func previousCat(_ sender: UIButton) {
        puppyWebView.goBack()
        if (interstitial1.isReady) {
            interstitial1.present(fromRootViewController: self)
            interstitial1 = createAd1()
        }
    }
    @IBAction func nextCat(_ sender: UIButton) {
        photo()
        if (interstitial.isReady) {
            interstitial.present(fromRootViewController: self)
            interstitial = createAd()
        }
    }
    func createAd() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: "ca-app-pub-8233515273063706/3834189331")
        inter.load(GADRequest())
        return inter
    }
    func createAd1() -> GADInterstitial {
        let inter1 = GADInterstitial(adUnitID: "ca-app-pub-8233515273063706/7494518153")
        inter1.load(GADRequest())
        return inter1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nTitle = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
             nTitle.textAlignment = .center
             nTitle.font = .boldSystemFont(ofSize: 23)
             nTitle.textColor = #colorLiteral(red: 0.5789041519, green: 0.3935802579, blue: 0.3027411699, alpha: 1)
             nTitle.text = "My Pups"
             self.navigationItem.titleView = nTitle
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8233515273063706/3834189331")
        let request = GADRequest()
        interstitial.load(request)
        interstitial1 = GADInterstitial(adUnitID: "ca-app-pub-8233515273063706/7494518153")
        let request1 = GADRequest()
        interstitial1.load(request1)
        puppyWebView.navigationDelegate = self
        
        bannerView1.adUnitID = "ca-app-pub-8233515273063706/7686089849"
        bannerView1.rootViewController = self
        bannerView1.load(GADRequest())
        
        let urlString = "https://dog.ceo/api/breeds/image/random"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            //parsing
            //1
            if error != nil {
                return
            }
            //2
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                return
            }
            //3
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let summary = try decoder.decode(Puppy.self, from: data)
                let urlString = summary.message
                let url = URL(string: urlString)
                let urlRequest = URLRequest(url: url!)
                DispatchQueue.main.async {
                    self.puppyWebView.load(urlRequest)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    func photo() {
        let str = "https://dog.ceo/api/breeds/image/random"
        guard let urlString = URL(string: str) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: urlString) { (data, response, error) in
            //parsing
            //1
            if error != nil {
                return
            }
            //2
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                return
            }
            //3
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let summary = try decoder.decode(Puppy.self, from: data)
                let urlString = summary.message
                let url = URL(string: urlString)
                let urlRequest = URLRequest(url: url!)
                DispatchQueue.main.async {
                    self.puppyWebView.load(urlRequest)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
}



