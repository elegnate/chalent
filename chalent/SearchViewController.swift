//
//  SearchViewController.swift
//  trada
//
//  Created by jwan on 2018. 8. 23..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit
import CoreLocation


class SearchTalentCell: UITableViewCell {
    
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelInterest: UILabel!
    @IBOutlet weak var labelTalent: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var imageviewProfile: UIImageView!
}

class SearchRecentCell: UITableViewCell {
    
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelDate: UILabel!
}


enum typeOfSearch: Int {
    case recent = 0
    case talent
}


class SearchViewController: ViewControllerInTableView {
    
    struct SearchRecent {
        var value: String
        var time: String
    }
    
    @IBOutlet weak var labelSearchDescript: UILabel!
    @IBOutlet weak var textfieldSearchValue: UITextField!
    @IBOutlet weak var tableviewResult: UITableView!
    @IBOutlet weak var buttonSearch: UIButton!
    
    
    let fileio = FileIO("recent", directory: "search")
    var searchLocation: String = ""
    var searchType: typeOfSearch = .recent
    var selectRow: Int = -1
    
    var jsonData: [UserInformation] = [
        UserInformation(name: "비공개", address: "서울시 강남구", profile: nil,
                        talent: ["클라이밍", "보드"],
                        interest: ["보드", "중국어", "작곡"], id: "", message: ""),
        UserInformation(name: "비공개", address: "서울시 강남구", profile: #imageLiteral(resourceName: "p7"),
                        talent: ["클라이밍", "글쓰기", "교정교열"],
                        interest: ["피아노", "일러스트", "이미지편집"], id: "", message: ""),
        UserInformation(name: "비공개", address: "서울시 강남구", profile: #imageLiteral(resourceName: "p5"),
                        talent: ["클라이밍", "요가"],
                        interest: ["향초만들기", "요리"], id: "", message: ""),
        UserInformation(name: "비공개", address: "서울시 강남구", profile: #imageLiteral(resourceName: "p6"),
                        talent: ["클라이밍", "축구", "당구"],
                        interest: ["FinalCut", "파이널컷", "EDM"], id: "", message: ""),
        UserInformation(name: "비공개", address: "서울시 강남구", profile: nil,
                        talent: ["클라이밍", "축구", "당구"],
                        interest: ["FinalCut", "파이널컷", "EDM"], id: "", message: ""),
        UserInformation(name: "비공개", address: "서울시 강남구", profile: nil,
                        talent: ["클라이밍", "축구", "당구"],
                        interest: ["FinalCut", "파이널컷", "EDM"], id: "", message: "")
    ]
    
    var fileData: [SearchRecent] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround(cancelsTouchesInView: false)
        
        textfieldSearchValue.delegate = self
        tableviewResult.delegate = self
        tableviewResult.dataSource = self
        tableviewResult.initDesign()
        
        loadFileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCellDeleteCode = setCellDelete
        changeTableViewLayout()
        if searchType == .recent {
            textfieldSearchValue.becomeFirstResponder()
        }
    }
    
    override func loadView() {
        super.loadView()
        setCellCode = setCell
        setCellCountCode = setCellCount
    }
    
    func changeTableViewLayout() {
        if searchType == .recent {
            canCellEdit = true
            cellHeight = 44
            labelSearchDescript.text = "최근 검색어"
        } else {
            canCellEdit = false
            cellHeight = 100
            labelSearchDescript.text = "검색 결과"
        }
        tableviewResult.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func editingSearchValue(_ sender: Any) {
        if textfieldSearchValue.text == "" {
            searchType = .recent
            changeTableViewLayout()
        }
    }
    
    @IBAction func pressSearch(_ sender: UIButton) {
        if textfieldSearchValue.text != "" {
            searchType = .talent
            changeTableViewLayout()
            appendFileData(textfieldSearchValue.text!)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSearchSeg" {
            guard let vc = segue.destination as? RequestViewController else { return }
            vc.jsonData = jsonData[selectRow]
            selectRow = -1
        }
    }
    
}


extension SearchViewController {
    
    func loadFileData() {
        fileio.readLines().forEach {
            let split = $0.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: false)
            if split.count == 2 {
                let time = String(split[0])
                let recent = SearchRecent(value: String(split[1]), time: time)
                fileData.append(recent)
            }
        }
    }
    
    func updateFileData() {
        fileio.clear()
        fileData.forEach({
            let _ = fileio.write($0.value, timestamp: $0.time)
        })
    }
    
    func removeFileData(_ i: Int) {
        fileData.remove(at: i)
        updateFileData()
    }
    
    func appendFileData(_ text: String) {
        for recent in fileData {
            if recent.value == text {
                return
            }
        }
        guard let timestamp = fileio.write(text) else { return }
        fileData.insert(SearchRecent(value: text, time: timestamp), at: 0)
    }
}


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pressSearch(buttonSearch)
        return true
    }
}


extension SearchViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchType == .talent {
            selectRow = indexPath.row
            performSegue(withIdentifier: "ProfileSearchSeg", sender: self)
        } else {
            textfieldSearchValue.text = fileData[indexPath.row].value
            pressSearch(buttonSearch)
        }
    }
    
    func setCellCount(_ tableView: UITableView, section: Int) -> Int {
        switch searchType {
        case .talent:
            return jsonData.count
        default:
            return fileData.count
        }
    }
    
    func setCellDelete(_ tableView: UITableView, indexPath: IndexPath) {
        removeFileData(indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func setCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch searchType {
        case .talent:
            return getTalentResultCell(tableView: tableView, i: indexPath.row)
        default:
            return getRecentResultCell(tableView: tableView, i: indexPath.row)
        }
    }
    
    func getRecentResultCell(tableView: UITableView, i: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRecentCell") as! SearchRecentCell
        cell.labelValue.text = "#\(fileData[i].value)"
        cell.labelDate.text = convertSimpleDate(fileData[i].time)
        return cell
    }
    
    func convertSimpleDate(_ date: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월d일"
        if let date = fileio.getTimestamp(to: date) {
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getTalentResultCell(tableView: UITableView, i: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTalentCell") as! SearchTalentCell
        let data = jsonData[i]
        
        cell.imageviewProfile.image = data.profile ?? #imageLiteral(resourceName: "userPicture")
        cell.labelAddress.text = data.address
        cell.labelInterest.text = data.interest?.convertStringsToTagSentence()
        cell.labelTalent.text = data.talent?.convertStringsToTagSentence()
        cell.labelTalent.changeTextDesign(findText: "#\(textfieldSearchValue.text!)", color: ThemaColor.red, backgroundColor: UIColor.clear, weight: .bold, size: 16)
        cell.labelDistance.text = "10km 이내"
        
        return cell
    }
}



