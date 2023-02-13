//
//  DiamondRedBagModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class OpenCoinRedBagModel: Mapable {
    
    var addRedPacket : String!
    var redPacket : String!
    var goldCoin : Int!

    required init(json: JSON) {
        addRedPacket = json["add_red_packet"].string
        redPacket = json["red_packet"].string
        goldCoin = json["gold_coin"].intValue
    }
    
}
