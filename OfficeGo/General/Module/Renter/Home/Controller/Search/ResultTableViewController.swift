//
//  ResultTableViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

private let resultCell = SearchResultTableViewCell.reuseIdentifierStr

class ResultTableViewController: UITableViewController {
    
    var resultArray:[String] = []
    var isFrameChange = false
    /// 点击cell回调闭包
    var callBack: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 控制器根据所在界面的status bar，navigationbar，与tabbar的高度，不自动调整scrollview的 inset
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: resultCell)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)
        cell.textLabel?.text = resultArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        SSLog(cell?.textLabel?.text ?? "")
        
        
        // 点击cell调用闭包
        callBack()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // 设置view的frame
        if isFrameChange == false {
            view.frame = CGRect(x: 0, y: 64, width: kWidth, height: kHeight - 64)
            isFrameChange = true
        }
        
    }
}
