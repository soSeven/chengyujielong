//
//  CashModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/13.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class CashListModel: Mapable {
    
    var cash : Int!
    var id : Int!
    var isNew : Int!
    var isReceive : Int!
    var isReceiveCash : Int!
    var level : Int!
    var signDay : Int!

    required init(json: JSON) {
        cash = json["cash"].intValue
        id = json["id"].intValue
        isNew = json["is_new"].intValue
        isReceive = json["is_receive"].intValue
        isReceiveCash = json["is_receive_cash"].intValue
        level = json["level"].intValue
        signDay = json["sign_day"].intValue
    }
    
}

class GetCashModel: Mapable {
    
    var redPacket : String!

    required init(json: JSON) {
        redPacket = json["red_packet"].string
    }
    
}
