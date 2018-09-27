//
//  MyInformationViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 30..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit
import TagListView


struct MyInformation {
    var name: String = ""
    var address: String = ""
    var profile: UIImage?
    var talent: [String]?
    var interest: [String]?
    var isPermissionAllRecommand: Bool = false
    var isPermissionSearchRecommand: Bool = true
    var id: String = ""
}


class MyInformationViewController: UIViewController {
    
    enum typeOfInput: Int {
        case talent = 0
        case interest
    }
    
    @IBOutlet weak var viewInput: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var tagviewTalent: TagListView!
    @IBOutlet weak var tagviewInterest: TagListView!
    @IBOutlet weak var buttonSearchRecommand: UIButton!
    @IBOutlet weak var buttonAllRecommand: UIButton!
    @IBOutlet weak var buttonInputMode: UIButton!
    @IBOutlet weak var imageviewProfile: UIImageView!
    @IBOutlet weak var textfieldInput: UITextField!
    
    @IBOutlet weak var constraintInputBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintProfileTop: NSLayoutConstraint!
    
    var inputMode: typeOfInput = .talent
    var jsonData = MyInformation(name: "홍길동", address: "서울시 송파구", profile: #imageLiteral(resourceName: "p4"),
                                   talent: ["C", "C++", "Python", "Swift", "코딩", "인테리어"],
                                   interest: ["영어회화", "토익", "포토샵", "축구"],
                                   isPermissionAllRecommand: false, isPermissionSearchRecommand: true, id: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide(_:)),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
        let tagFont = customFont(weight: .regular, size: 13)
        tagviewTalent.textFont = tagFont
        tagviewInterest.textFont = tagFont
        tagviewTalent.delegate = self
        tagviewInterest.delegate = self
        labelName.text = jsonData.name
        labelAddress.text = jsonData.address
        imageviewProfile.image = jsonData.profile ?? #imageLiteral(resourceName: "userPicture")
        viewInput.layer.zPosition = .greatestFiniteMagnitude
        
        for talent in jsonData.talent! {
            tagviewTalent.addTag(talent)
        }
        for interest in jsonData.interest! {
            tagviewInterest.addTag(interest)
        }
    }
    
    @objc func KeyboardWillShow(_ notification:NSNotification) {
        self.MoveToolBar(isUp: true, with: notification)
    }
    
    @objc func KeyboardWillHide(_ notification:NSNotification) {
        self.MoveToolBar(isUp: false, with: notification)
    }
    
    fileprivate func MoveToolBar(isUp up: Bool, with notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animationOptions = UIViewAnimationOptions(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue)
            let moveInputConstant:CGFloat = up ? -endFrame.height + 50.0 : 0.0
            let moveProfileConstant:CGFloat = up ? -160.0 : 20.0
            
            constraintInputBottom.constant = moveInputConstant
            constraintProfileTop.constant = moveProfileConstant
            
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
    
    @IBAction func pressInputMode(_ sender: Any) {
        if inputMode == .talent {
            buttonInputMode.setTitle("관심 #", for: .normal)
            buttonInputMode.setTitleColor(ThemaColor.darkgray, for: .normal)
            inputMode = .interest
        } else {
            buttonInputMode.setTitle("재능 #", for: .normal)
            buttonInputMode.setTitleColor(ThemaColor.red, for: .normal)
            inputMode = .talent
        }
    }
    
    @IBAction func pressAddTalentOrInterest(_ sender: Any) {
        if let text = textfieldInput.text, text != "" {
            let tagview = inputMode == .talent ? tagviewTalent : tagviewInterest
            tagview?.addTag(text)
            textfieldInput.text = ""
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}


extension MyInformationViewController: TagListViewDelegate {
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender.restorationIdentifier == "TalentTag" {
        } else {
        }
        
        sender.removeTagView(tagView)
    }
}


