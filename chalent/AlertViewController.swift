//
//  NotificationViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 25..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit


class AlertCell: UITableViewCell {
    
    @IBOutlet weak var imageviewProfile: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelArriveTime: UILabel!
}


struct AlertInformation {
    var user: UserInformation!
    var talent: String = ""
    var time: String = ""
    var type: Int
}


class AlertViewController: ViewControllerInTableView {
    
    enum typeOfAlert: Int {
        case request = 0
        case accept
        case error
    }
    
    @IBOutlet weak var tableviewAlert: UITableView!
    
    var jsonData: [AlertInformation] = [
        AlertInformation(user: UserInformation(name: "김영희", address: "서울시 송파구", profile: #imageLiteral(resourceName: "p2"),
                                               talent: ["인테리어", "클라이밍", "스카이다이빙"],
                                               interest: ["영어회화", "토익", "포토샵"], id: "", message: ""), talent: "토익", time: "방금전", type: 0),
        AlertInformation(user: UserInformation(name: "김철수", address: "서울시 송파구", profile: #imageLiteral(resourceName: "p1"),
                                               talent: ["영어회화", "주식", "투자"],
                                               interest: ["포토샵", "일러스트"], id: "", message: ""), talent: "포토샵", time:"8월 29일", type: 1)
    ]
    var selectRow: Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewAlert.initDesign()
        tableviewAlert.delegate = self
        tableviewAlert.dataSource = self
        
        let dismissBtn = navigationItem.leftBarButtonItem
        dismissBtn?.action = #selector(self.dismissAlertViewController)
        dismissBtn?.target = self
        
        let removeBtn = navigationItem.rightBarButtonItem
        removeBtn?.action = #selector(self.removeAllAlertCell)
        removeBtn?.target = self
    }
    
    @objc func dismissAlertViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func removeAllAlertCell() {
        jsonData.removeAll()
        tableviewAlert.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        canCellEdit = true
        setCellCode = setCell
        setCellCountCode = setCellCount
        setCellDeleteCode = setCellDelete
        cellHeight = 80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AcceptSeg" {
            let vc = segue.destination as! AcceptViewController
            vc.jsonData = jsonData[selectRow].user
            selectRow = -1
        }
    }
    
}


extension AlertViewController {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch typeOfAlert.init(rawValue: jsonData[indexPath.row].type) ?? .error {
        case .request:
            selectRow = indexPath.row
            performSegue(withIdentifier: "AcceptSeg", sender: self)
            break
        case .accept:
            let tabbar = self.presentingViewController as? UITabBarController
            tabbar?.selectedIndex = 2
            presentingViewController?.dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func setCellCount(_ tableView: UITableView, section: Int) -> Int {
        return jsonData.count
    }
    
    func setCellDelete(_ tableView: UITableView, indexPath: IndexPath) {
        jsonData.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func setCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let data = jsonData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell") as! AlertCell
        var msg = ""
        
        cell.selectionStyle = .none
        cell.imageviewProfile.image = data.user.profile ?? #imageLiteral(resourceName: "userPicture")
        cell.labelArriveTime.text = data.time
        
        switch (typeOfAlert.init(rawValue: data.type) ?? .error) {
        case .request: msg = "\(data.user.name)님이 회원님의 #\(data.talent) 재능과 교환을 원합니다."
            break
        case .accept: msg = "\(data.user.name)님이 #\(data.talent) 재능 교환을 수락했습니다."
            break
        default:
            msg = "일시적인 오류로 불러오지 못했습니다."
        }
        
        cell.labelMessage.text = msg
        cell.labelMessage.changeTextDesign(findText: data.user.name, color: ThemaColor.black, backgroundColor: UIColor.clear, weight: .bold, size: 15)
        cell.labelMessage.changeTextDesign(findText: "#\(data.talent)", color: ThemaColor.red, backgroundColor: UIColor.clear, weight: .bold, size: 15, isOverlap: true)
        
        return cell
    }
    
}
