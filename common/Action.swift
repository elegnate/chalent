//
//  Action.swift
//  trada
//
//  Created by jwan on 2018. 8. 26..
//  Copyright © 2018년 jwan. All rights reserved.
//

import Foundation
import SwiftyGif


extension Array {
    
    func convertStringsToTagSentence() -> String {
        var ret = ""
        for str in self as! [String] {
            ret += "#\(str)   "
        }
        return ret
    }
}


extension String {
    
    func regExp(filter:String) -> Bool {
        let regex = try! NSRegularExpression(pattern: filter, options: [])
        let list = regex.matches(in:self, options: [], range:NSRange.init(location: 0, length:self.count))
        return (list.count >= 1)
    }
    
    func isPassword() -> Bool {
        let ret = regExp(filter: "(?!^[0-9]*$)(?!^[a-zA-Z`~|!@#$%^&*\\[\\]{}():;_+=<>?]*$)^([a-zA-Z`~|!@#$%^&*\\[\\]{}():;_+=<>?0-9]{8,16})$")
        return ret
    }
    
    func isEmail() -> Bool {
        let ret = regExp(filter: "^[0-9a-zA-Z_]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z_]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$")
        return ret
    }
    
    func isName() -> Bool {
        let ret = regExp(filter: "(^[가-힣]{2,})|(^[a-zA-Z][a-zA-Z0-9]{3,})$")
        return ret
    }
}


extension UIViewController {
    
    func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = true) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func animateSlideView(type: Int, constraints: [NSLayoutConstraint],
                       constraintUnderbarCenterX: NSLayoutConstraint,
                       moveUnderbar: CGFloat = 60) {
        var moveWidth = view.frame.width
        
        if type == 1 {
            moveWidth = -moveWidth
            constraintUnderbarCenterX.constant =  moveUnderbar
        } else {
            constraintUnderbarCenterX.constant =  -moveUnderbar
        }
        for constraint in constraints {
            constraint.constant += moveWidth
        }
    }
    
    func animatePresentAndDismiss(type: String = kCATransitionFromRight) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = type
    }
    
    func startLoading() {
        let viewLoading = UIView(frame: view.frame)
        let imageview = UIImageView(frame: CGRect(x: view.frame.width / 2 - 50,
                                                  y: view.frame.height / 2 - 75,
                                                  width: 100, height: 100))
        let loadingImage = UIImage(gifName: "loading", levelOfIntegrity: 0.5)
        
        view.addSubview(viewLoading)
        viewLoading.addSubview(imageview)
        viewLoading.restorationIdentifier = "Loading"
        viewLoading.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        imageview.loopCount = -1
        imageview.setGifImage(loadingImage)
        imageview.startAnimating()
        imageview.contentMode = .scaleAspectFit
        imageview.alpha = 0.9
    }
    
    func endLoading() {
        for sub in view.subviews {
            if sub.restorationIdentifier == "Loading" {
                sub.removeFromSuperview()
                break
            }
        }
    }
}


extension UITableView {
    
    func scrollToBottom(isAnimated: Bool = false){
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
        }
    }
}
