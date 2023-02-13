//
//  TaskModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/28.
//  Copyright © 2020 Kaka. All rights reserved.
//

import SwiftyJSON

class AllTaskModel: Mapable {
    
    var rewardCountLeft : Int!
    var taskList : [AllTaskList]!
    
    required init(json: JSON) {
        rewardCountLeft = json["reward_count_left"].intValue
        taskList = json["task_list"].arrayValue.map{ AllTaskList(json: $0) }
    }
}

class AllTaskList: Mapable {

    var avatar : String!
    var goldCoin : Int!
    var id : Int!
    var max : Int!
    var min : Int!
    var money : Int!
    var nowCount : Int!
    var rewardStatus : Int!
    var status : Int!
    var text : String!
    var textImage : String!

    required init(json: JSON) {
        avatar = json["avatar"].stringValue
        goldCoin = json["gold_coin"].intValue
        id = json["id"].intValue
        max = json["max"].intValue
        min = json["min"].intValue
        money = json["money"].intValue
        nowCount = json["now_count"].intValue
        rewardStatus = json["reward_status"].intValue
        status = json["status"].intValue
        text = json["text"].stringValue
        textImage = json["text_image"].stringValue
    }

}

class AllTaskRewardModel: Mapable {

    var goldCoin : Int!
    var goldCoinLatest : Int!
    var redPacket : String!
    var redPacketLatest : String!
    var titleName : String!
    var titleNameLatest : String!
    var taskStatus: Bool!

    required init(json: JSON) {
        goldCoin = json["gold_coin"].intValue
        goldCoinLatest = json["gold_coin_latest"].intValue
        redPacket = json["red_packet"].stringValue
        redPacketLatest = json["red_packet_latest"].stringValue
        titleName = json["title_name"].stringValue
        titleNameLatest = json["title_name_latest"].stringValue
        taskStatus = json["task_status"].boolValue
    }
    
}

class TodayTaskModel: Mapable {

    var rewardCountLeftToday : Int!
    var taskListToday : [TodayTaskListModel]!

    required init(json: JSON) {
        rewardCountLeftToday = json["reward_count_left_today"].intValue
        taskListToday = json["task_list_today"].arrayValue.map{ TodayTaskListModel(json: $0) }
    }

}

class TodayTaskListModel: Mapable {

    var goldCoin : Int!
    var id : Int!
    var max : Int!
    var min : Int!
    var nowCount : Int!
    var rewardStatus : Int!
    var status : Int!
    var text : String!
    var type : Int!
    
    required init(json: JSON) {
        goldCoin = json["gold_coin"].intValue
        id = json["id"].intValue
        max = json["max"].intValue
        min = json["min"].intValue
        nowCount = json["now_count"].intValue
        rewardStatus = json["reward_status"].intValue
        status = json["status"].intValue
        text = json["text"].stringValue
        type = json["type"].intValue
    }

}

class TodayTaskRewardModel: Mapable {

    var goldCoin : Int!
    var goldCoinLatest : Int!
    var redPacket : String!
    var redPacketLatest : String!
    var taskStatus: Bool!

    required init(json: JSON) {
        goldCoin = json["gold_coin"].intValue
        goldCoinLatest = json["gold_coin_latest"].intValue
        redPacket = json["add_red_packet"].stringValue
        redPacketLatest = json["red_packet_latest"].stringValue
        taskStatus = json["task_status"].boolValue
    }
    
}
