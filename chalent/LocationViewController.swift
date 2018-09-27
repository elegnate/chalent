//
//  LocationViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 22..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit


class LocationCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageview: UIImageView!
}


class LocationViewController: NMapViewController,
                              UITableViewDelegate,
                              UITableViewDataSource {
    
    enum typeOfSlideView: Int {
        case location = 0
        case nmap
    }
    
    @IBOutlet weak var tableviewCity: UITableView!
    @IBOutlet weak var tableviewBorough: UITableView!
    @IBOutlet weak var viewArea: UIView!
    
    @IBOutlet weak var constraintViewAreaLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintViewAreaTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintUnderbarCenterX: NSLayoutConstraint!
    
    private var showLocationView: Bool = false
    var slideConstraints: [NSLayoutConstraint]!
    
    let cities: [String] = ["서울", "경기도", "인천", "강원", "대전", "충북", "충남", "세종", "부산",
                            "대구", "울산", "경남", "경북", "광주", "전북", "전남", "제주"]
    let boroughs: [[String]] = [["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구",
                              "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구",
                              "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]
                              ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableviewCity.initDesign()
        tableviewBorough.initDesign()
        tableviewCity.delegate = self
        tableviewCity.dataSource = self
        tableviewBorough.delegate = self
        tableviewBorough.dataSource = self
        tableviewCity.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        
        slideConstraints = [constraintViewAreaLeading, constraintViewAreaTrailing]
        if let constraints = constraintsMapView, constraints.count >= 3 {
            slideConstraints.append(constraints[2])
            slideConstraints.append(constraints[3])
        }
        
        animateSlideView(type: typeOfSlideView.nmap.rawValue, constraints: slideConstraints, constraintUnderbarCenterX: constraintUnderbarCenterX)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 테이블 행수 얻기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let id = tableView.restorationIdentifier, id == "CityTable" {
            //return cities.count
            return 1
        }
        if let id = tableView.restorationIdentifier, id == "BoroughTable" {
            return boroughs[0].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = tableView.restorationIdentifier, let parent = presentingViewController,
            id == "BoroughTable" {
            let location = "\(cities[(tableviewCity.indexPathForSelectedRow?.row)!]) \(boroughs[0][indexPath.row])"
            if parent.restorationIdentifier == "TabBarVC" {
                let tab = parent as! UITabBarController
                let vc = tab.viewControllers![1] as! SearchViewController
                vc.searchLocation = location
            } else if parent.restorationIdentifier == "SignUpVC" {
                let vc = parent as! SignUpViewController
                vc.textfieldAddress.text = location
                vc.editRequiredFiledCheck(.address, isAdd: true)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    // 셀 내용 변경하기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let id = tableView.restorationIdentifier, id == "CityTable" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as! LocationCell
            cell.labelTitle.text = cities[indexPath.row]
            cell.cellSelectedDesign()
            return cell
        } else if let id = tableView.restorationIdentifier, id == "BoroughTable" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoroughCell") as! LocationCell
            cell.labelTitle.text = boroughs[0][indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func pressNMapView(_ sender: Any) {
        if showLocationView {
            animateSlideView(type: typeOfSlideView.nmap.rawValue, constraints: slideConstraints, constraintUnderbarCenterX: constraintUnderbarCenterX)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            showLocationView = false
        }
    }
    
    @IBAction func pressLocationView(_ sender: Any) {
        if !showLocationView {
            animateSlideView(type: typeOfSlideView.location.rawValue, constraints: slideConstraints, constraintUnderbarCenterX: constraintUnderbarCenterX)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            showLocationView = true
        }
    }
    
    @IBAction func pressExit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
