
import UIKit
import GoogleMobileAds

class MemoReadViewController: UIViewController {
    var bannerView4: GADBannerView!
    
    //@IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var img: UIImageView!
    // 데이터 넘겨받을 변수. 옵셔널로 선언해야 함.
    var param: MemoVO?
    func setupBannerView() {
         let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
         bannerView4 = GADBannerView(adSize: adSize)
         addBannerViewToView(bannerView4)
         bannerView4.adUnitID = "ca-app-pub-8233515273063706/2273981065"
         bannerView4.rootViewController = self
         bannerView4.load(GADRequest())
         //bannerView.delegate = self
     }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let bgImage = UIImage(named:"memo-background.png")!
//        self.view.backgroundColor = UIColor(patternImage: bgImage)
        setupBannerView()
        bannerView4.isHidden = false
        //self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, hh:mm a"
        let dateString = formatter.string(for: (param?.regdate))
        title = dateString

    }
    
}

