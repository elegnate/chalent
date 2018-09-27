//
//  SignUpViewController.swift
//  trada
//
//  Created by jwan on 2018. 9. 4..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController {
    
    enum typeOfRequiredFieldCheck: Int {
        case name = 1
        case address = 2
        case email = 4
        case password = 8
        case all = 15
    }

    @IBOutlet weak var viewEmailCheck: UIView!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPw: UITextField!
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldAddress: UITextField!
    @IBOutlet weak var buttonAddProfile: UIButton!
    @IBOutlet weak var imageviewPwCheck: DesignableImageView!
    @IBOutlet weak var labelAlert: UILabel!
    
    @IBOutlet weak var constraintProfileTop: NSLayoutConstraint!
    
    let pickerController = UIImagePickerController()
    var requiredFieldCheck: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide(_:)),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        textfieldEmail.changePlaceHolderColor(color: UIColor.white)
        textfieldPw.changePlaceHolderColor(color: UIColor.white)
        textfieldName.changePlaceHolderColor(color: UIColor.white)
        textfieldAddress.changePlaceHolderColor(color: UIColor.white)
        
        pickerController.delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func KeyboardWillShow(_ notification:NSNotification) {
        self.MoveToolBar(isUp: true, with: notification)
    }
    
    @objc func KeyboardWillHide(_ notification:NSNotification) {
        self.MoveToolBar(isUp: false, with: notification)
    }
    
    fileprivate func MoveToolBar(isUp up: Bool, with notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animationOptions = UIViewAnimationOptions(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue)
            let moveConstant:CGFloat = up ? -120.0 : 20.0
            
            constraintProfileTop.constant = moveConstant
            
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: animationOptions,
                           animations: { () -> Void in
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editRequiredFiledCheck(_ type: typeOfRequiredFieldCheck, isAdd: Bool) {
        if isAdd && !isEnteredRequiredField(type) {
            requiredFieldCheck += type.rawValue
        } else if !isAdd && isEnteredRequiredField(type) {
            requiredFieldCheck -= type.rawValue
        }
        print(requiredFieldCheck)
    }
    
    func isEnteredRequiredField(_ type: typeOfRequiredFieldCheck) -> Bool {
        let value = type.rawValue
        return requiredFieldCheck & value == value
    }
    
    @IBAction func editingName(_ sender: Any) {
        let value = textfieldName.text!.isName()
        editRequiredFiledCheck(.name, isAdd: value)
    }
    
    @IBAction func editingEmail(_ sender: Any) {
        let value = textfieldEmail.text!.isEmail()
        viewEmailCheck.isHidden = !value
        editRequiredFiledCheck(.email, isAdd: value)
    }
    
    @IBAction func editingPassword(_ sender: Any) {
        let value = textfieldPw.text!.isPassword()
        imageviewPwCheck.isHidden = !value
        editRequiredFiledCheck(.password, isAdd: value)
    }
    
    @IBAction func pressAddProfile(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        pickerController.modalTransitionStyle = .crossDissolve
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pressRefreshEmail(_ sender: Any) {
        textfieldEmail.text = ""
        viewEmailCheck.isHidden = true
    }
    
    @IBAction func pressSignup(_ sender: Any) {
        if typeOfRequiredFieldCheck(rawValue: requiredFieldCheck) == .all {
            
        } else {
            if !isEnteredRequiredField(.name) {
                labelAlert.text = "올바른 이름을 입력하세요."
            } else if !isEnteredRequiredField(.address) {
                labelAlert.text = "주소를 입력하세요."
            } else if !isEnteredRequiredField(.email) {
                labelAlert.text = "올바른 이메일 아이디를 입력하세요."
            } else if !isEnteredRequiredField(.password) {
                labelAlert.text = "올바른 비밀번호를 입력하세요.\n영문 대/소문자, 특수문자, 숫자를 포함한 8~16자"
            }
        }
    }
    
    @IBAction func pressExit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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


extension SignUpViewController: UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            var line: CGFloat = image.size.width
            var posX: CGFloat = 0
            var posY: CGFloat = (image.size.height - line) / 2.0
            if image.size.width > image.size.height {
                line = image.size.height
                posX = (image.size.width - line) / 2.0
                posY = 0
            }
            let cgimage = image.cgImage?.cropping(to: CGRect(x: posX, y: posY, width: line, height: line)) ?? #imageLiteral(resourceName: "userPicture").cgImage
            buttonAddProfile.setTitle("", for: .normal)
            buttonAddProfile.setImage(UIImage(cgImage: cgimage!), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}


