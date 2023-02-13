//
//  HomeSignModel.swift
//  Chengyujielong
//
//  Created by yellow on 2020/10/10.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class HomeSignModel: Mapable {
    
    var addRedPacket : Float!
    var redPacket : String!
    var addGoldCoin : Int!
    var goldCoin : Int!
    
    required init(json: JSON) {
        addRedPacket = json["add_red_packet"].floatValue
        redPacket = json["red_packet"].string
        addGoldCoin = json["add_gold_coin"].intValue
        goldCoin = json["gold_coin"].intValue
    }
    
}

class HomeOnlineSignModel: Mapable {
    
    var addRedPacket : Float!
    var redPacket : String!
    var addGoldCoin : Int!
    var goldCoin : Int!
    var duration : Int!
    
    required init(json: JSON) {
        addRedPacket = json["add_red_packet"].floatValue
        redPacket = json["red_packet"].string
        addGoldCoin = json["add_gold_coin"].intValue
        goldCoin = json["gold_coin"].intValue
        duration = json["duration"].intValue
    }
    
}
