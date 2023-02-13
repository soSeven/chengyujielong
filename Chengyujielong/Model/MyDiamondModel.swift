//
//  MyDiamondModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyDiamondListModel: Mapable {
    
    var gold : Int!
    var id : Int!
    var isReceive : Int!
    var isSuccess : Int!
    var level : Int!
    var levelToday : Int!
    var moreLevel : Int!

    required init(json: JSON) {
        gold = json["gold"].intValue
        id = json["id"].intValue
        isReceive = json["is_receive"].intValue
        isSuccess = json["is_success"].intValue
        level = json["level"].intValue
        levelToday = json["level_today"].intValue
        moreLevel = json["more_level"].intValue
    }
    
}
