//
//  RewardRecordModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class RewardRecordModel: PageModelType {
    
    typealias T = RewardRecordListModel
    
    var paging: PageModel
    var data: [RewardRecordListModel]
    
    required init(json: JSON) {
    
        data = json["data"].arrayValue.map{ RewardRecordListModel(json: $0) }
        paging = PageModel(json: json["paging"])
        
    }
    
}

class RewardRecordListModel: Mapable {
    
    var activeDay : Int!
    var createdAt : String!
    var gold : Int!
    var id : Int!
    var isDouble : Int!
    var level : Int!
    var sourceType : Int!

    required init(json: JSON) {
        activeDay = json["active_day"].intValue
        createdAt = json["created_at"].stringValue
        gold = json["gold"].intValue
        id = json["id"].intValue
        isDouble = json["is_double"].intValue
        level = json["level"].intValue
        sourceType = json["source_type"].intValue
    }
    
}
