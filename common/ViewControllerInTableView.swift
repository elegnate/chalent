//
//  CustomTableView.swift
//  trada
//
//  Created by jwan on 2018. 8. 31..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit

class ViewControllerInTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var setCellCode: ((UITableView, IndexPath) -> UITableViewCell)?
    var setCellCountCode: ((UITableView, Int) -> Int)?
    var setCellDeleteCode: ((UITableView, IndexPath) -> Void)?
    
    var canCellEdit: Bool = false
    var cellHeight: CGFloat?
    var headerHeight: CGFloat = 1.0
    var footerHeight: CGFloat = 1.0
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canCellEdit
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let code = setCellDeleteCode, editingStyle == .delete {
            code(tableView, indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let code = setCellCountCode {
            return code(tableView, section)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeight {
            return height
        }
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let code = setCellCode {
            return code(tableView, indexPath)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "삭제") { (action, indexPath) in
            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = ThemaColor.red
        return [deleteButton]
    }

}
