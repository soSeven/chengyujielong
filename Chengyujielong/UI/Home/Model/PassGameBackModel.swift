//
//  PassGameBackModel.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/30.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import SwiftyJSON

class PassGameBackModel: Mapable {
    
    var addRedPacket : String!
    var redPacket : String!
    var taskStatus : Int!
    var lastCheckpointRewardNum : Int!

    required init(json: JSON) {
        addRedPacket = json["add_red_packet"].string
        redPacket = json["red_packet"].string
        taskStatus = json["task_status"].intValue
        lastCheckpointRewardNum = json["last_checkpoint_reward_num"].intValue
    }
    
}
