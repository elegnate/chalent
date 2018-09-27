//
//  AcceptViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 31..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit
import TagListView


class AcceptViewController: UIViewController, TagListViewDelegate {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var imageviewProfile: UIImageView!
    @IBOutlet weak var tagviewTalent: TagListView!
    
    var jsonData: UserInformation = UserInformation(name: "홍길동", address: "서울시 송파구", profile: #imageLiteral(resourceName: "p4"),
                                                    talent: ["C", "C++", "Python", "Swift"],
                                                    interest: ["바이올린"], id: "",
                                                    message: "바이올린을 배워보고 싶어요! 바이올린은 있고 장소는 서로 협의했으면 좋겠습니다")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "요청"
        tabBarController?.tabBar.isHidden = true
        tagviewTalent.delegate = self
        tagviewTalent.textFont = customFont(weight: .regular, size: 15)
        
        labelName.text = jsonData.name
        labelAddress.text = jsonData.address
        imageviewProfile.image = jsonData.profile
        labelMessage.text = jsonData.message
        labelMessage.changeLineHeight(lineHeight: 10)
        
        if let interest = jsonData.interest, interest.count > 0 {
            labelMessage.changeTextDesign(findText: interest[0], color: ThemaColor.red, backgroundColor: UIColor.clear, weight: .bold, size: 16, isOverlap: true)
        }
        
        for talent in jsonData.talent! {
            tagviewTalent.addTag(talent)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
