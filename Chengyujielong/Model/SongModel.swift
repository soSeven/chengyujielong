//
//  SongModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import SwiftyJSON

class SongModel: Mapable {
    
    var id : Int!
    var level : Int!
    var content : [String]!
    var url : String!
    var cashNum: Int!
    
    required init(json: JSON) {
        id = json["id"].intValue
        level = json["level"].intValue
        content = json["content"].arrayValue.map{ $0.stringValue }
        url = json["url"].stringValue
        cashNum = json["to_level_cash"].intValue
    }
}

class AnswerRightModel: Mapable {
    
    var gold: Int
    var goldToCashNum: Int
    var song: SongModel!
    
    required init(json: JSON) {
        gold = json["gold"].intValue
        goldToCashNum = json["gold_to_cash_num"].intValue
        song = SongModel(json: json["song"])
    }
    
}

class AnswerErrorModel: Mapable {
    
    var hp: Int
    
    required init(json: JSON) {
        hp = json["hp"].intValue
    }
    
}

class AnswerDeleteModel: Mapable {
    
    var singleNum: Int
    
    required init(json: JSON) {
        singleNum = json["single_num"].intValue
    }
    
}

class RedBagModel: Mapable {
    
    var cash: Int
    
    required init(json: JSON) {
        cash = json["cash"].intValue
    }
    
}

