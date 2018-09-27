//
//  EditMyInformationViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 30..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit


class InformationTalentCell: UITableViewCell {
    
    @IBOutlet weak var labelTalent: UILabel!
}


struct InformationTalent {
    var talent: [String]!
    var interest: [String]!
    
    init(talent: [String], interest: [String]) {
        self.talent = talent
        self.interest = interest
    }
}


class EditMyInformationViewController: ViewControllerInTableView {

    enum typeOfSlideView: Int {
        case talent = 0
        case interest
    }
    
    @IBOutlet weak var tableviewTalent: UITableView!
    @IBOutlet weak var tableviewInterest: UITableView!
    @IBOutlet weak var textfieldTalent: UITextField!
    @IBOutlet weak var buttonAddTalent: UIButton!
    
    @IBOutlet weak var constraintInputBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintUnderBarCenterX: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewTalentTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewTalentLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewInterestTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewInterestLeading: NSLayoutConstraint!
    
    var jsonData: InformationTalent = InformationTalent(talent: ["피아노", "C++", "포토샵"],
                                                        interest: ["클라이밍", "축구", "헬스"])
    var slideConstraints: [NSLayoutConstraint]!
    var showTalentView = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide(_:)),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        tableviewInterest.delegate = self
        tableviewInterest.dataSource = self
        tableviewInterest.initDesign()
        tableviewTalent.delegate = self
        tableviewTalent.dataSource = self
        tableviewTalent.initDesign()
        
        constraintTableViewInterestTrailing.constant += view.frame.width
        constraintTableViewInterestLeading.constant += view.frame.width
        slideConstraints = [constraintTableViewTalentLeading, constraintTableViewTalentTrailing,
                            constraintTableViewInterestLeading, constraintTableViewInterestTrailing]
    }
    
    override func loadView() {
        super.loadView()
        setCellCode = setCell
        setCellCountCode = setCellCount
        setCellDeleteCode = setCellDelete
        canCellEdit = true
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
            
            constraintInputBottom.constant = moveConstant
            
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: animationOptions,
                           animations: { () -> Void in
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressAddTalent(_ sender: Any) {
        let tableView = showTalentView ? tableviewTalent : tableviewInterest
        addCell(tableView: tableView!)
        tableviewTalent.scrollToBottom()
    }
    
    @IBAction func pressExit(_ sender: Any) {
        animateSlideView(type: typeOfSlideView.talent.rawValue, constraints: slideConstraints, constraintUnderbarCenterX: constraintUnderBarCenterX)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressInterestView(_ sender: Any) {
        if showTalentView {
            animateSlideView(type: typeOfSlideView.interest.rawValue, constraints: slideConstraints, constraintUnderbarCenterX: constraintUnderBarCenterX)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            showTalentView = false
        }
    }
    
    @IBAction func pressTalentView(_ sender: Any) {
        if !showTalentView {
            animateSlideView(type: typeOfSlideView.talent.rawValue, constraints: slideConstraints, constraintUnderbarCenterX: constraintUnderBarCenterX)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            showTalentView = true
        }
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


extension EditMyInformationViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func addCell(tableView: UITableView) {
        let indexPath:IndexPath!
        
        if tableView.restorationIdentifier == "TalentTable" {
            indexPath = IndexPath(row: jsonData.talent.count, section: 0)
            jsonData.talent.append(textfieldTalent.text!)
        } else {
            indexPath = IndexPath(row: jsonData.interest.count, section: 0)
            jsonData.interest.append(textfieldTalent.text!)
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        textfieldTalent.text = ""
    }
    
    func setCellCount(_ tableView: UITableView, section: Int) -> Int {
        if tableView.restorationIdentifier == "TalentTable" {
            return jsonData.talent.count
        } else {
            return jsonData.interest.count
        }
    }
    
    func setCellDelete(_ tableView: UITableView, indexPath: IndexPath) {
        if tableView.restorationIdentifier == "TalentTable" {
            jsonData.talent.remove(at: indexPath.row)
        } else {
            jsonData.interest.remove(at: indexPath.row)
        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func setCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InformationTalentCell") as! InformationTalentCell
        let text = tableView.restorationIdentifier == "TalentTable" ? jsonData.talent[indexPath.row] : jsonData.interest[indexPath.row]
        cell.labelTalent.text = "#" + text
        return cell
    }
    
}


