//
//  ChatViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 26..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit


class MessageCell: UITableViewCell {
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTime: UILabel!
}


class ChatViewController: ViewControllerInTableView {
    
    enum typeOfMessageOwner: String{
        case other = "0"
        case my = "1"
    }
    
    struct ChatBubble {
        var contents: [String]
        var time: String
        var owner: typeOfMessageOwner
    }
    
    @IBOutlet weak var viewInput: UIView!
    @IBOutlet weak var textviewInput: UITextView!
    @IBOutlet weak var tableviewChat: UITableView!
    @IBOutlet weak var constraintInputBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintInputHeight: NSLayoutConstraint!
    
    var chatId: String? = nil
    var fileio: FileIO? = nil
    
    var fileData: [ChatBubble] = []
    
    // 회원탈퇴시 채팅창
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide(_:)),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
        tabBarController?.tabBar.isHidden = true
        
        tableviewChat.delegate = self
        tableviewChat.dataSource = self
        tableviewChat.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableviewChat.scrollToBottom()
        
        textviewInput.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        textviewInput.delegate = self
        textviewInput.translatesAutoresizingMaskIntoConstraints = false
        
        /*appendFileData(message: "안녕하세요?", time: "2018.09.06_13:31", owner: .other)
        appendFileData(message: "안녕하세요! 코딩 배우고 싶으시다구요?", time: "2018.09.06_13:32", owner: .my)
        appendFileData(message: "네 ㅎㅎ 배워보고 싶어서.. 어떤거 배우고 싶으세요?", time: "2018.09.06_13:33", owner: .other)
        appendFileData(message: "제 프로필에 있는 것들은 다 가능해요!", time: "2018.09.06_13:33", owner: .other)
        appendFileData(message: "음.. 저는 영어회화 배우고 싶어서요 어느정도 하세요?", time: "2018.09.06_13:34", owner: .my)
        appendFileData(message: "미국에 2년정도 살다왔어요! 적당히 프리토킹은 가능해요 ㅎㅎ", time: "2018.09.06_13:37", owner: .other)
        appendFileData(message: "그럼 잘부탁드려요 ㅎㅎ 전 초보라 ㅜㅜ", time: "2018.09.06_13:40", owner: .my)
        appendFileData(message: "코딩은 얼마나 하세요? 처음 배우시는 거에요?", time: "2018.09.06_13:41", owner: .my)
        appendFileData(message: "어떤 언어 배우시려고 하는건지도 중요한데..", time: "2018.09.06_13:41", owner: .my)
        appendFileData(message: "전 파이썬 배우려고 했는데 파이썬 할 줄 아시나요?", time: "2018.09.06_13:42", owner: .other)
        appendFileData(message: "네 적당히 할 줄 알아요 ㅎㅎㅎ 파이썬 해본 적 있으세요?", time: "2018.09.06_13:43", owner: .my)
        appendFileData(message: "설치하고 print해본 정도에요 ㅋㅋㅋ 많이 못해요 ㅜㅠ", time: "2018.09.06_13:44", owner: .other)
        appendFileData(message: "어려우려나요?", time: "2018.09.06_13:45", owner: .other)
        appendFileData(message: "본인하기 나름이죠! 흥미 느끼면 별로 안어려울거에요 ㅎㅎ", time: "2018.09.06_13:50", owner: .my)
        appendFileData(message: "흥미가 없으면 하기 싫으니까요.. 그래서 목표가 중요해요 이거 한 번 만들어 보고 싶다 이런 목표요 ㅎㅎㅎ", time: "2018.09.06_13:50", owner: .my)*/
        loadFileData()
    }
    
    override func loadView() {
        super.loadView()
        setCellCode = setCell
        setCellCountCode = setCellCount
        headerHeight = 5
        footerHeight = 5
        chatId = "test"
        guard let id = chatId else { return }
        fileio = FileIO(id, directory: "chat")
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
            tableviewChat.scrollToBottom(isAnimated: true)
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ChatViewController {
    
    func loadFileData() {
        guard let chats = fileio?.readLines() else { return }
        let lines = chats.count
        
        for i in 0..<lines {
            let idx = lines - i - 1
            var split = chats[idx].split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
            if split.count == 3 {
                let time = String(split[0])
                let owner = typeOfMessageOwner.init(rawValue: String(split[1])) ?? .other
                let message = String(split[2])
                combineSameTimeMessages(message: message, time: time, owner: owner)
            }
        }
    }
    
    func combineSameTimeMessages(message: String, time: String, owner: typeOfMessageOwner) {
        if let lastBubble = fileData.last,
            lastBubble.time == time && lastBubble.owner == owner {
            fileData[fileData.count - 1].contents.append(message)
        } else {
            fileData.append(ChatBubble(contents: [message], time: time, owner: owner))
        }
    }
    
    func appendFileData(message: String, time: String, owner: typeOfMessageOwner) {
        guard let file = fileio else { return }
        let input = owner.rawValue + " " + message
        guard let timestamp = file.write(input, timestamp: time) else { return }
        combineSameTimeMessages(message: message, time: timestamp, owner: owner)
    }
}


extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let textViewFrame = textView.frame
        
        if textView.contentSize.height < 85 {
            let size = CGSize(width: textViewFrame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            
            textView.isScrollEnabled = false
            constraintInputHeight.constant = estimatedSize.height
        } else {
            textView.isScrollEnabled = true
        }
    }
}


extension ChatViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fileData.count
    }
    
    func setCellCount(_ tableView: UITableView, section: Int) -> Int {
        return fileData[section].contents.count
    }
    
    func setCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageCell? = nil
        let row = indexPath.row
        let message = fileData[indexPath.section]
        
        if message.owner == .other {
            cell = tableView.dequeueReusableCell(withIdentifier: "OtherChatCell2") as? MessageCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell") as? MessageCell
        }
        
        cell?.labelTime.text = String(message.time[message.time.index(after: message.time.index(of: "_")!)..<message.time.endIndex])
        cell?.labelMessage.text = message.contents[row]
        return cell!
    }
    
}


