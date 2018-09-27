//
//  AccountHelpViewController.swift
//  chalent
//
//  Created by jwan on 2018. 9. 6..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit

class AccountHelpViewController: UIViewController {

    @IBOutlet weak var viewEmailCheck: UIView!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldAuthNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        textfieldEmail.changePlaceHolderColor(color: UIColor.white)
        textfieldAuthNumber.changePlaceHolderColor(color: UIColor.white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func pressGetAuthNumber(_ sender: Any) {
    }
    
    @IBAction func editingAuthNumber(_ sender: Any) {
        if textfieldAuthNumber.text!.count >= 7 {
            textfieldAuthNumber.text?.removeLast()
            dismissKeyboard()
            return
        }
    }
    
    @IBAction func editingEmail(_ sender: Any) {
        viewEmailCheck.isHidden = !textfieldEmail.text!.isEmail()
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
