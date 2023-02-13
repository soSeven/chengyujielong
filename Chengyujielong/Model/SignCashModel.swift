//
//  SignCashModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import SwiftyJSON

class SignCashModel: Mapable {
    
    var day : Int!
    var id : Int!
    var isCash : Int!
    var isReceiveCash : Int!
    var isSign : Int!
    var isToday : Int!
    var signDay : Int!
    var toSign : Int!
    var type: Int!
    var cash: Int!
    
    required init(json: JSON) {
        day = json["day"].intValue
        id = json["id"].intValue
        isCash = json["is_cash"].intValue
        isReceiveCash = json["is_receive_cash"].intValue
        isSign = json["is_sign"].intValue
        isToday = json["is_today"].intValue
        signDay = json["sign_day"].intValue
        toSign = json["to_sign"].intValue
        type = json["type"].intValue
        cash = json["cash"].intValue
    }
    
}
