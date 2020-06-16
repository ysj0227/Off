//
//  ViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class ViewController: JHTableViewController {


    override func viewDidLoad() {
 
        super.viewDidLoad()
        self.title = "OfficeGo示例"
        self.mainDatas = ["跳转Tableview","跳转CollectionView","跳转WebView","跳转EXView"]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = JHTableViewCell.dequeueReusableCell(tableView: tableView) ?? JHTableViewCell.init(style: .default)
        cell.textLabel?.text = self.mainDatas[indexPath.row] as? String
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = TableViewController.init(tableViewStyle: .StyleGrouped)
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = CollectionViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = WebViewController.init(url: "https://www.qq.com")
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = ExViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            SSLog("")
        }
    }
    deinit{
        SSLog("1释放")
    }
}

