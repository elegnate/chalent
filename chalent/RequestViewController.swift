//
//  RequestViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 31..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit
import TagListView


struct UserInformation {
    var name: String
    var address: String
    var profile: UIImage?
    var talent: [String]?
    var interest: [String]?
    var id: String
    var message: String
}


class RequestViewController: UIViewController {

    @IBOutlet weak var viewNavi: UIView!
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageviewProfile: UIImageView!
    @IBOutlet weak var tagviewTalent: TagListView!
    @IBOutlet weak var tagviewInterest: TagListView!
    @IBOutlet weak var textfieldMessage: UITextField!
    
    @IBOutlet weak var constraintProfileAreaTop: NSLayoutConstraint!
    @IBOutlet weak var constraintMessageAreaBottom: NSLayoutConstraint!
    
    var jsonData: UserInformation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide(_:)),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
        viewNavi.layer.addBorder([.bottom], color: ThemaColor.grayNavigation, width: 0.5)
        
        if let userProfile = jsonData {
            let tagFont = customFont(weight: .regular, size: 15)
            tagviewTalent.textFont = tagFont
            tagviewInterest.textFont = tagFont
            for talent in userProfile.talent! {
                tagviewTalent.addTag(talent)
            }
            for interest in userProfile.interest! {
                tagviewInterest.addTag(interest)
            }
            labelName.text = userProfile.name
            labelAddress.text = userProfile.address
            imageviewProfile.image = userProfile.profile ?? #imageLiteral(resourceName: "userPicture")
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
            let moveConstant = up ? -endFrame.height : 0
            
            constraintProfileAreaTop.constant = moveConstant + 20
            constraintMessageAreaBottom.constant = moveConstant
            
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
