import UIKit
import Firebase
import GoogleMobileAds
import CoreLocation
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADInterstitialDelegate {
    
    var window: UIWindow?
    var memoList = [MemoVO]()
    var interstitial: GADInterstitial?
    //var launchScreenView: UIView?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyBowWow")
        container.loadPersistentStores() {
            if let error = $1 as NSError? {
                error.description
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                error.description
            }
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            // create instance which will provide location info.
            //manager = CLLocationManager()
            // only to use in forground
            //manager?.requestWhenInUseAuthorization()
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithOpaqueBackground()
            let colorLiteral = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            coloredAppearance.backgroundColor = colorLiteral
            coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.brown]
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.brown]
            UINavigationBar.appearance().standardAppearance = coloredAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9527944922, green: 0.8348175287, blue: 0.5657938719, alpha: 1)
            UITabBar.appearance().tintColor = .brown
            
        } else {
            UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9527944922, green: 0.8348175287, blue: 0.5657938719, alpha: 1)
            UITabBar.appearance().tintColor = .brown
            // Fallback on earlier versions
        }
        //        if let view = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()?.view {
        //             launchScreenView = view
        //             view.translatesAutoresizingMaskIntoConstraints = false
        //
        //             if let rootView = window?.rootViewController?.view {
        //                 rootView.addSubview(view)
        //                 var constraints = [NSLayoutConstraint]()
        //                 constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": view])
        //                 constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": view])
        //                 rootView.addConstraints(constraints)
        //             }
        //         }
        //         interstitial = GADInterstitial(adUnitID: "ca-app-pub-8233515273063706/4122845826")
        //         interstitial?.delegate = self
        //         let request = GADRequest()
        //         interstitial?.load(request)
        //        FirebaseApp.configure()
        //        GADMobileAds.sharedInstance().start(completionHandler: nil)
        //        return true
        //    }
        //    func interstitialDidReceiveAd(_ ad: GADInterstitial!){
        //        guard let viewController = window?.rootViewController else { return }
        //        ad.present(fromRootViewController: viewController)
        //    }
        //    func interstitialWillDismissScreen(_ ad: GADInterstitial!) {
        //        launchScreenView?.removeFromSuperview()
        //    }
        return true
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
}


