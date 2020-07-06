
import UIKit
import MobileCoreServices

class MemoFormViewController: UIViewController {
    var subject: String!
    lazy var dao = MemoDAO()
    //    let imagePicker = UIImagePickerController()
    var capturedImage: UIImage!
    var flagImageSave = false
    var videoURL: URL!
    
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        if segmentedOutlet.selectedSegmentIndex == 0 {
            flagImageSave = true
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            flagImageSave = false
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
    }
    @IBAction func photo(_ sender: Any) {
        //이미지 저장기능을 사용하지 않기 때문에 설정.
        flagImageSave = false
        //이미지를 선택하거나 취소했을때 호출될 메소드의 위치를 설정.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //이미지피커의 데이터 소스 속성을 photolibrary로 설정.
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        //이미지 저장기능을 사용해야하기 때문에 설정.
        flagImageSave = true
        //이미지를 선택하거나 선택취소했을때 호출될 메소드 지정.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    @IBAction func save(_ sender: Any) {
        guard self.contents.text.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "No contents", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        let data = MemoVO()
        data.title = self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.regdate = Date()
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.memoList.append(data)
        self.dao.insert(data)
        _ = self.navigationController?.popViewController(animated: true)
    }
    //    @IBAction func pick(_ sender: UIBarButtonItem) {
    //        let select = UIAlertController(title: "Choose your photo to import.", message: nil, preferredStyle: .actionSheet)
    //        select.addAction(UIAlertAction(title: "Camera", style: .default) { (_) in
    //            self.presentPicker(source: .camera)
    //        })
    //        select.addAction(UIAlertAction(title: "Photo Library", style: .default) { (_) in
    //            self.presentPicker(source: .photoLibrary)
    //        })
    //        select.addAction(UIAlertAction(title: "Saved Photos Album", style: .default){ (_) in
    //            self.presentPicker(source: .savedPhotosAlbum)
    //        })
    //        select.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //        self.present(select, animated: false)
    //        select.popoverPresentationController?.barButtonItem = sender
    //    }
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nTitle = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
        nTitle.textAlignment = .center
        nTitle.font = .boldSystemFont(ofSize: 23)
        nTitle.textColor = #colorLiteral(red: 0.5789041519, green: 0.3935802579, blue: 0.3027411699, alpha: 1)
        nTitle.text = "New Memo"
        self.navigationItem.titleView = nTitle
        self.contents.delegate = self
//        let bgImage = UIImage(named:"memo-background.png")!
//        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
//        self.contents.layer.borderWidth = 0
//        self.contents.layer.borderColor = UIColor.clear.cgColor
//        self.contents.backgroundColor = UIColor.clear
        //contents.becomeFirstResponder()
        // observer 등록 코드. 보통 viewdidload에서 구현.
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            //             if let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            //                 let keyboardHeight = keyboardSize.cgRectValue.height
            let posY = strongSelf.preview.frame.origin.y - 150
            UIView.animate(withDuration: 0.25, animations: {
                strongSelf.preview.frame = CGRect( x: strongSelf.preview.frame.origin.x, y: posY, width: strongSelf.preview.frame.size.width, height: strongSelf.preview.frame.height)
            })
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            let posY = strongSelf.preview.frame.origin.y + 150
            UIView.animate(withDuration: 0.25, animations: {
                strongSelf.preview.frame = CGRect( x: strongSelf.preview.frame.origin.x, y: posY, width: strongSelf.preview.frame.size.width, height: strongSelf.preview.frame.height)
            })
        })
        //        let style = NSMutableParagraphStyle()
        //        style.lineSpacing = 9
        //        self.contents.attributedText = NSAttributedString(string: " ", attributes: [NSAttributedString.Key.paragraphStyle: style])
        //        self.contents.text = ""
    }
    
    // Do any additional setup after loading the view.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contents.resignFirstResponder()
    }
    
    //image picker
    //    func presentPicker(source: UIImagePickerController.SourceType) {
    //        guard UIImagePickerController.isSourceTypeAvailable(source) == true else {
    //            let alert = UIAlertController(title: "not available type", message: nil, preferredStyle: .alert)
    //            self.present(alert, animated: false)
    //            return
    //        }
    //
    //        //create image picker instance
    //        let picker = UIImagePickerController()
    //        picker.delegate = self
    //        picker.allowsEditing = true
    //        self.present(picker, animated: false)
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MemoFormViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //이미지 선택을 완료했을때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //이미지와 동영상을 구분하기 위해서 타입을 가져옴.
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(capturedImage, self, nil, nil)
            }
            self.preview.image = capturedImage
        } else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
            if flagImageSave == true{
                videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
        }
        //이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MemoFormViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        let length = ( (contents.length > 15) ? 15: contents.length )
        self.subject = contents.substring(with: NSRange(location: 0 , length: length))
        self.navigationItem.title = subject
        
    }
}
