import UIKit
import GoogleMobileAds

class MemoListTableViewController: UITableViewController {
    var bannerView3: GADBannerView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var dao = MemoDAO()
    @IBAction func add(_ sender: Any) {
        guard let memoFormVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoFormViewController") as? MemoFormViewController else { return }
        self.navigationController?.pushViewController(memoFormVC, animated: true)
        
    }
    func setupBannerView() {
         let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.width, height: 50))
         bannerView3 = GADBannerView(adSize: adSize)
         addBannerViewToView(bannerView3)
         bannerView3.adUnitID = "ca-app-pub-8233515273063706/1583715924"
         bannerView3.rootViewController = self
         bannerView3.load(GADRequest())
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.memoList = self.dao.fetch()
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nTitle = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
             nTitle.textAlignment = .center
             nTitle.font = .boldSystemFont(ofSize: 23)
             nTitle.textColor = #colorLiteral(red: 0.5789041519, green: 0.3935802579, blue: 0.3027411699, alpha: 1)
             nTitle.text = "Pet Diary"
             self.navigationItem.titleView = nTitle
        setupBannerView()
        bannerView3.isHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(MemoListTableViewController.add(_:)))
        let memo1 = MemoVO()
        memo1.title = "things to prepare"
        memo1.contents = "soap"
        memo1.regdate = Date(timeIntervalSinceNow: 3000)
        appDelegate.memoList.append(memo1)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.memoList.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.appDelegate.memoList[indexPath.row]
        let cellId = row.image == nil ? "memoCell" : "memoWithImage"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoTableViewCell
        cell.subject.text = row.title
        //cell.contents.text = row.contents
        cell.img?.image = row.image
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd HH:mm"
        cell.regdate?.text = formatter.string(for: row.regdate)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoReadVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoReadViewController") as! MemoReadViewController
        memoReadVC.param = appDelegate.memoList[indexPath.row]
        self.navigationController?.pushViewController(memoReadVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.memoList[indexPath.row]
        if dao.delete(data.objectID!) {
            self.appDelegate.memoList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

