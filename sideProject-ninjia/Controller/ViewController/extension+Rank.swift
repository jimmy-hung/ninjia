//
//  extension+Rank.swift
//  sideProject-ninjia
//
//  Created by 洪立德 on 2019/2/20.
//  Copyright © 2019 蘇 郁傑. All rights reserved.
//

import UIKit

extension RankViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("listAry: \(listAry)")
        let myCell = scoreTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ScoreTableCell
        
        if indexPath.row == 0 {
            myCell.textLabel?.text = "Top \(indexPath.row + 1)"
        }else {
            myCell.textLabel?.text = "No. \(indexPath.row + 1)"
        }
        myCell.detailTextLabel?.text = "\(listAry[indexPath.row])"
        return myCell
    }
}
