
import UIKit

class MemoFormViewController: UIViewController {
    var subject: String!
    lazy var dao = MemoDAO()
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
    @IBAction func pick(_ sender: UIBarButtonItem) {
        let select = UIAlertController(title: "Choose your photo to import.", message: nil, preferredStyle: .actionSheet)
        select.addAction(UIAlertAction(title: "Camera", style: .default) { (_) in
            self.presentPicker(source: .camera)
        })
        select.addAction(UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.presentPicker(source: .photoLibrary)
        })
        select.addAction(UIAlertAction(title: "Saved Photos Album", style: .default){ (_) in
            self.presentPicker(source: .savedPhotosAlbum)
        })
        select.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(select, animated: false)
        select.popoverPresentationController?.barButtonItem = sender
    }
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
        self.contents.delegate = self
        //contents.becomeFirstResponder()
        // observer 등록 코드. 보통 viewdidload에서 구현.
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] (noti) in
             guard let strongSelf = self else { return }
//             if let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                 let keyboardHeight = keyboardSize.cgRectValue.height
               let posY = strongSelf.preview.frame.origin.y - 120
                 UIView.animate(withDuration: 0.25, animations: {
                     strongSelf.preview.frame = CGRect( x: strongSelf.preview.frame.origin.x, y: posY, width: strongSelf.preview.frame.size.width, height: strongSelf.preview.frame.height)
            })
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            let posY = strongSelf.preview.frame.origin.y + 120
            UIView.animate(withDuration: 0.25, animations: {
                strongSelf.preview.frame = CGRect( x: strongSelf.preview.frame.origin.x, y: posY, width: strongSelf.preview.frame.size.width, height: strongSelf.preview.frame.height)
        })
    })
    }
                 
        // Do any additional setup after loading the view.

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contents.resignFirstResponder()
    }

    //image picker
    func presentPicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) == true else {
            let alert = UIAlertController(title: "not available type", message: nil, preferredStyle: .alert)
            self.present(alert, animated: false)
            return
        }
        //create image picker instance
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: false)
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    
}

extension MemoFormViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //이미지 선택을 완료했을때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //선택된 이미지를 미리보기에 표시.
        self.preview.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        //이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
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

