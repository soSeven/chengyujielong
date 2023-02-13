//
//  ConfigureModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class ConfigureModel: Mapable {
    
    var bubbleReward : [ConfigureBubbleReward]!
    var bubbleTimeRule : ConfigureBubbleTimeRule!
    var checkpointReward : [ConfigureCheckpointReward]!
    var checkpointWithdrawalChance : [Int]!
    var constField : ConfigureConst!
    var onlineReward : [ConfigureOnlineReward]!
    var openRedPacket : ConfigureOpenRedPacket!
    var signReward : [ConfigureSignReward]!
    var withdrawalDrawGoldRes : [ConfigureWithdrawalDrawGoldRe]!
    var withdrawalDrawRedPacketRes : [ConfigureWithdrawalDrawRedPacketRe]!
    var withdrawalDrawRes : [ConfigureWithdrawalDrawRe]!
    var withdrawalDrawShow : [ConfigureWithdrawalDrawShow]!
    
    required init(json: JSON) {
        
        bubbleReward = json["bubble_reward"].arrayValue.map{ ConfigureBubbleReward(json: $0)}
        bubbleTimeRule =  ConfigureBubbleTimeRule(json: json["bubble_time_rule"])
        checkpointReward = json["checkpoint_reward"].arrayValue.map{ ConfigureCheckpointReward(json: $0)}
        checkpointWithdrawalChance = json["checkpoint_withdrawal_chance"].arrayValue.map{ $0.intValue }
        constField = ConfigureConst(json: json["const"])
        onlineReward = json["online_reward"].arrayValue.map{ ConfigureOnlineReward(json: $0)}
        openRedPacket = ConfigureOpenRedPacket(json: json["open_red_packet"])
        signReward = json["sign_reward"].arrayValue.map{ ConfigureSignReward(json: $0)}
        withdrawalDrawGoldRes = json["withdrawal_draw_gold_res"].arrayValue.map{ ConfigureWithdrawalDrawGoldRe(json: $0)}
        withdrawalDrawRedPacketRes = json["withdrawal_draw_red_packet_res"].arrayValue.map{ ConfigureWithdrawalDrawRedPacketRe(json: $0)}
        withdrawalDrawRes = json["withdrawal_draw_res"].arrayValue.map{ ConfigureWithdrawalDrawRe(json: $0)}
        withdrawalDrawShow = json["withdrawal_draw_show"].arrayValue.map{ ConfigureWithdrawalDrawShow(json: $0)}
    }
    
}

class ConfigureWithdrawalDrawShow: Mapable {
    
    var max : Int!
    var min : Int!
    var show1 : Int!
    var show3 : Int!
    var show5 : Int!
    var show7 : Int!
    
    required init(json: JSON) {
        max = json["max"].intValue
        min = json["min"].intValue
        show1 = json["show_1"].intValue
        show3 = json["show_3"].intValue
        show5 = json["show_5"].intValue
        show7 = json["show_7"].intValue
    }
    
}

class ConfigureWithdrawalDrawRe: Mapable{

    var max : Int!
    var min : Int!
    var result : String!
    
    required init(json: JSON) {
        max = json["max"].intValue
        min = json["min"].intValue
        result = json["result"].stringValue
    }

}

class ConfigureWithdrawalDrawRedPacketRe: Mapable {

    var number : Int!
    var prob : Int!
    
    required init(json: JSON) {
        number = json["number"].intValue
        prob = json["prob"].intValue
    }

}

class ConfigureWithdrawalDrawGoldRe: Mapable {

    var number : Int!
    var prob : Int!

    required init(json: JSON) {
        number = json["number"].intValue
        prob = json["prob"].intValue
    }

}

class ConfigureSignReward: Mapable {

    var number : Float!
    var type : Int!
    var watchVideos : Int!
    
    required init(json: JSON) {
        number = json["number"].floatValue
        type = json["type"].intValue
        watchVideos = json["watch_videos"].intValue
    }

}

class ConfigureOpenRedPacket : Mapable {

    var goldCoin : Int!
    var max : Float!
    var min : Float!
    var number : Int!
    
    required init(json: JSON) {
        goldCoin = json["gold_coin"].intValue
        max = json["max"].floatValue
        min = json["min"].floatValue
        number = json["number"].intValue
    }

}

class ConfigureOnlineReward: Mapable{

    var duration : Int!
    var max : Int!
    var min : Int!
    var type : Int!
    var watchVideos : Int!
    
    required init(json: JSON) {
        duration = json["duration"].intValue
        max = json["max"].intValue
        min = json["min"].intValue
        type = json["type"].intValue
        watchVideos = json["watch_videos"].intValue
    }

}

class ConfigureConst: Mapable {

    var videoPerCheckpoint : Int!
    var videoAfterCheckpoint : Int!
    var checkpointwithdrawal: Int!
    var ylhAd: Int!
    var csjAd: Int!
    var checkVersion: String!
    
    required init(json: JSON) {
        videoPerCheckpoint = json["video_per_checkpoint"].intValue
        videoAfterCheckpoint = json["video_after_checkpoint"].intValue
        checkpointwithdrawal = json["checkpoint_withdrawal"].intValue
        ylhAd = json["ios_ylh_video"].intValue
        csjAd = json["ios_csj_video"].intValue
        checkVersion = json["ios_examine"].stringValue
    }

}

class ConfigureCheckpointReward: Mapable {

    var max : Float!
    var maxCheckpoint : Int!
    var min : Float!
    var minCheckpoint : Int!
    var videoMax : Float!
    var videoMin : Float!
    
    required init(json: JSON) {
        max = json["max"].floatValue
        maxCheckpoint = json["max_checkpoint"].intValue
        min = json["min"].floatValue
        minCheckpoint = json["min_checkpoint"].intValue
        videoMax = json["video_max"].floatValue
        videoMin = json["video_min"].floatValue
    }

}

class ConfigureBubbleTimeRule : Mapable {

    var continueField : Int!
    var interval : Int!

    required init(json: JSON) {
        continueField = json["continue"].intValue
        interval = json["interval"].intValue
    }

}

class ConfigureBubbleReward: Mapable {

    var gold : Int!
    var times : Int!
    var videoDoubleStatus : Int!
    var videoStatus : Int!
    
    required init(json: JSON) {
        gold = json["gold"].intValue
        times = json["times"].intValue
        videoDoubleStatus = json["video_double_status"].intValue
        videoStatus = json["video_status"].intValue
    }

}

class ConfigurePriceModel: Mapable {
    
    var text: String!
    var cash : Int!
    var level : Int!
    var type: Int!

    required init(json: JSON) {
        type = json["type"].intValue
        level = json["level"].intValue
        cash = json["cash"].intValue
        text = json["text"].stringValue
    }
    
}
