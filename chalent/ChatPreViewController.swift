//
//  ChatViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 26..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit


class ChatPreviewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPreview: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelUnreadCount: DesignableLabel!
    @IBOutlet weak var buttonProfile: UIButton!
    
    var id: String = ""
}


class ChatPreViewController: ViewControllerInTableView {
    
    struct ChatPreview {
        var name: String
        var message: String
        var time: String
        var unreadCount: String
        var profile: UIImage
    }
    
    @IBOutlet weak var tableviewChat: UITableView!
    
    var selectIndex: IndexPath? = nil
    var jsonData: [ChatPreview] = [
        ChatPreview(name: "홍길동", message: "안녕하세요", time: "방금전", unreadCount: "1", profile: #imageLiteral(resourceName: "userPicture")),
        ChatPreview(name: "김영희", message: "장소 시간은 어떻게 할까요?", time: "8월 28일", unreadCount: "0", profile: #imageLiteral(resourceName: "p2"))
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableviewChat.delegate = self
        tableviewChat.dataSource = self
        tableviewChat.initDesign()
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = selectIndex {
            if segue.identifier == "ChatSeg" {
                let vc = segue.destination as! ChatViewController
                vc.title = jsonData[index.row].name
            } else if segue.identifier == "ProfileChatSeg" {
                let vc = segue.destination as! RequestViewController
            }
        }
    }
 
}


extension ChatPreViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath
        performSegue(withIdentifier: "ChatSeg", sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatPreviewCell") as! ChatPreviewCell
        let data = jsonData[indexPath.row]
        cell.labelName.text = data.name
        cell.labelTime.text = data.time
        cell.labelPreview.text = data.message
        cell.buttonProfile.setImage(data.profile, for: .normal)
        if data.unreadCount != "0" {
            cell.labelUnreadCount.isHidden = false
            cell.labelUnreadCount.text = data.unreadCount
        } else {
            cell.labelUnreadCount.isHidden = true
        }
        return cell
    }
    
}


