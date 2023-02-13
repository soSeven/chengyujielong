//
//  UserModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/15.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

class LoginUserModel: Mapable {
    
    var id : String!
    var token : String!
    var isNew : Bool!
    var channel : String!
    
    required init(json: JSON) {
        id = json["id"].stringValue
        channel = json["channel"].stringValue
        isNew = json["is_new"].boolValue
        token = json["token"].stringValue
    }
}

class UserModel: NSObject, Mapable{

    var id : String!
    var token : String!
    var isNew : Bool!

    var avatar : String!
    var bindWechatTime : String!
    var channel : String!
    var channelId : Int!
    var checkpointLastDate : String!
    var createdAt : String!
    var deviceNumber : String!
    var deviceToken : String!
    var goldCoin : Int!
    
    var hasDraw = BehaviorRelay<Int>(value: 0)
    var hasDrawTime = BehaviorRelay<Int>(value: 0)
    var hasDrawTimeShowStart = PublishRelay<Bool>()
    
    var historyGoldCoin : Int!
    var historyRedPacket : Int!
    var isNextDayCallback : Int!
    var isPayCallback : Int!
    var isRegisterCallback : Int!
    var isSignRound : Int!
    var isTrackCallback : Int!
    var lastCheckpointRewardNum : Int!
    var lastSignRewardDate : String!
    var lastSignRewardDay : Int!
    var lastWithdrawalChanceResult : String!
    var lastWithdrawalChanceTime : Int!
    var lastWithdrawalDrawCheckpoint : Int!
    var nickname : String!
    var onlineAllNum : Int!
    var onlineLastDate : String!
    var onlineNum : Int!
    var onlineReward : [OnlineReward]!
    var onlineRewardCleanTime : Int!
    var onlineRewardReceive1 : Int!
    var onlineRewardReceive2 : Int!
    var onlineRewardReceive3 : Int!
    var onlineRewardReceive4 : Int!
    var openid : String!
    var os : Int!
    var playAgainNum : Int!
    var redPacket : String!
    var sex : Int!
    var shareUrl : String!
    var signReward : [SignReward]!
    var status : String!
    var tipsNum : Int!
    var todayCheckpointNum : Int!
    var todayOpenRedPacketNum : Int!
    var unionid : String!
    var updatedAt : String!
    var version : String!
    var withdrawalChanceCountdown  = BehaviorRelay<Int>(value: 0)
    var withdrawalTime : String!
    
    var titleName : String!
    /// 任务红点
    var taskStatus = BehaviorRelay<Bool>(value: false)
    
    /// 当前关卡数
    var currentLevel = BehaviorRelay<Int>(value: 0)
//    /// 当前阶段最大关卡数
//    private var maxLevel = 0
//    /// 当前阶段最小关卡数
//    private var minLevel = 0
    /// 总关卡值  当前关卡值  差多少关  进度  是否显示提现
    var difRelay = BehaviorRelay<(Int, Int, Int, CGFloat, Bool)>(value: (0, 0, 0, 0, false))
    
    /// 重玩次数
    let retryRelay = BehaviorRelay<Int>(value: 0)
    /// 提示次数
    let tipRelay = BehaviorRelay<Int>(value: 0)
    
    let signDotRelay = BehaviorRelay<Bool>(value: false)

    required init(json: JSON) {
        avatar = json["avatar"].stringValue.urlDecoded
        bindWechatTime = json["bind_wechat_time"].stringValue
        channel = json["channel"].stringValue
        channelId = json["channel_id"].intValue
        checkpointLastDate = json["checkpoint_last_date"].stringValue
        createdAt = json["created_at"].stringValue
        deviceNumber = json["device_number"].stringValue
        deviceToken = json["device_token"].stringValue
        goldCoin = json["gold_coin"].intValue
        historyGoldCoin = json["history_gold_coin"].intValue
        historyRedPacket = json["history_red_packet"].intValue
        id = json["id"].stringValue
        isNextDayCallback = json["is_next_day_callback"].intValue
        isPayCallback = json["is_pay_callback"].intValue
        isRegisterCallback = json["is_register_callback"].intValue
        isSignRound = json["is_sign_round"].intValue
        isTrackCallback = json["is_track_callback"].intValue
        lastCheckpointRewardNum = json["last_checkpoint_reward_num"].intValue
        lastSignRewardDate = json["last_sign_reward_date"].stringValue
        lastSignRewardDay = json["last_sign_reward_day"].intValue
        lastWithdrawalChanceResult = json["last_withdrawal_chance_result"].stringValue
        lastWithdrawalChanceTime = json["last_withdrawal_chance_time"].intValue
        lastWithdrawalDrawCheckpoint = json["last_withdrawal_draw_checkpoint"].intValue
        nickname = json["nickname"].stringValue
        onlineAllNum = json["online_all_num"].intValue
        onlineLastDate = json["online_last_date"].stringValue
        onlineNum = json["online_num"].intValue
        onlineReward = json["online_reward"].arrayValue.map{ OnlineReward(json: $0) }
        onlineRewardCleanTime = json["online_reward_clean_time"].intValue
        onlineRewardReceive1 = json["online_reward_receive_1"].intValue
        onlineRewardReceive2 = json["online_reward_receive_2"].intValue
        onlineRewardReceive3 = json["online_reward_receive_3"].intValue
        onlineRewardReceive4 = json["online_reward_receive_4"].intValue
        openid = json["openid"].stringValue
        os = json["os"].intValue
        playAgainNum = json["play_again_num"].intValue
        redPacket = json["red_packet"].string
        sex = json["sex"].intValue
        shareUrl = json["share_url"].stringValue
        signReward = json["sign_reward"].arrayValue.map{ SignReward(json: $0) }
        status = json["status"].stringValue
        tipsNum = json["tips_num"].intValue
        todayCheckpointNum = json["today_checkpoint_num"].intValue
        todayOpenRedPacketNum = json["today_open_red_packet_num"].intValue
        token = json["token"].stringValue
        unionid = json["unionid"].stringValue
        updatedAt = json["updated_at"].stringValue
        version = json["version"].stringValue
        titleName = json["title_name"].stringValue
        
        let taskStatusN = json["task_status"].boolValue
        taskStatus.accept(taskStatusN)
        
        let withdrawalChanceCountdownN = json["withdrawal_chance_countdown"].intValue
        withdrawalChanceCountdown.accept(withdrawalChanceCountdownN)
        withdrawalTime = json["withdrawal_time"].stringValue
        
//        let hasDrawN = json["has_draw"].intValue
//        hasDraw.accept(hasDrawN)
        
//        lastWithdrawalChanceResult = 3000000
//        withdrawalChanceCountdown.accept(80)
        
        super.init()
        
        let tipKey = "tipNumber"
        let tipNumber = UserDefaults.standard.object(forKey: tipKey) as? Int ?? 3
        tipRelay.accept(tipNumber)
        tipRelay.subscribe(onNext: { n in
            UserDefaults.standard.setValue(n, forKey: tipKey)
        }).disposed(by: rx.disposeBag)
        
        let retryKey = "retryNumber"
        let retryNumber = UserDefaults.standard.object(forKey: retryKey) as? Int ?? 2
        retryRelay.accept(retryNumber)
        retryRelay.subscribe(onNext: { n in
            UserDefaults.standard.setValue(n, forKey: retryKey)
        }).disposed(by: rx.disposeBag)
        
//        let levelInfoKey = "hasDrawTimeLevelInfo"
//        let levelInfo = UserDefaults.standard.dictionary(forKey: levelInfoKey)
//        var levelLastShowTimeMaxLevel = 0
//        if let levelInfo = levelInfo {
//            let minL = levelInfo["minLevel"] as? Int ?? 0
//            let maxL = levelInfo["maxLevel"] as? Int ?? 0
//            let time = levelInfo["time"] as? Int ?? 0
//            let isShow = levelInfo["isShow"] as? Bool ?? false
////            if isShow {
////                <#code#>
////            }
//            levelLastShowTimeMaxLevel = maxL
//            maxLevel = maxL
//            minLevel = minL
//            hasDrawTime.accept(time)
//        } else {
//            (maxLevel, minLevel) = getMaxAndMinLevel()
//        }
        
        hasDrawTime.subscribe(onNext: {[weak self] i in
            guard let self = self else { return }
            self.setupHawDrawTime(time: i)
        }).disposed(by: rx.disposeBag)
        
        hasDrawTimeShowStart.subscribe(onNext: {[weak self] i in
            guard let self = self else { return }
            let (rewardMaxLevel, _) = self.getRewardMaxAndMinLevel()
            self.setupHawDraw(level: rewardMaxLevel)
        }).disposed(by: rx.disposeBag)
        
        /// 3关以内提现机会都有效
        let skipLevel = 3
        
//        lastCheckpointRewardNum = 137
        currentLevel.accept(lastCheckpointRewardNum + 1)
        currentLevel.subscribe(onNext: {[weak self] currentLevel in
            guard let self = self else { return }
            self.lastCheckpointRewardNum = currentLevel - 1
            
            /// 1.获取领奖区间
            let (rewardMaxLevel, _) = self.getRewardMaxAndMinLevel()
            /// 2.这个区间是否有领奖机会
            let isHasDraw = self.getIsHawDraw(level: rewardMaxLevel)
            if isHasDraw {
                if self.lastCheckpointRewardNum <= rewardMaxLevel + skipLevel && self.lastCheckpointRewardNum >= rewardMaxLevel {
                    self.hasDraw.accept(1)
                    if UserDefaults.standard.object(forKey: "cash_opportunity_user_key") == nil {
                        UserDefaults.standard.setValue(1, forKey: "cash_opportunity_user_key")
                        MobClick.event("cash_opportunity", attributes: [
                            "type" : "user"
                        ])
                    }
                    MobClick.event("cash_opportunity", attributes: [
                        "type" : "number"
                    ])
                } else if self.lastCheckpointRewardNum < rewardMaxLevel {
                    self.hasDraw.accept(0)
                } else {
                    self.setupHawDraw(level: rewardMaxLevel)
                    self.setupHawDrawTime(time: 0)
                    self.hasDraw.accept(0)
                }
            } else {
                if self.lastCheckpointRewardNum <= rewardMaxLevel + skipLevel && self.lastCheckpointRewardNum >= rewardMaxLevel {
                    let time = self.getHasDrawTime()
                    self.hasDrawTime.accept(time)
                }
                self.hasDraw.accept(0)
            }
            
        }).disposed(by: rx.disposeBag)
        
        Observable.combineLatest(hasDraw.asObservable(), hasDrawTime.asObservable()).subscribe(onNext: {[weak self] (hasDraw, hasDrawTime) in
            guard let self = self else { return }
            let currentLevel = self.lastCheckpointRewardNum ?? 0
            if hasDraw > 0 || hasDrawTime > 0 {
                let (rewardMaxLevel, rewardMinLevel) = self.getRewardMaxAndMinLevel()
                let difCurrent = currentLevel - rewardMinLevel
                var dif = rewardMaxLevel - currentLevel
                if dif < 0 {
                    dif = 0
                }
                let totol = rewardMaxLevel - rewardMinLevel
                var p: CGFloat = 1
                if totol > 0, difCurrent < totol {
                    p = CGFloat(difCurrent) / CGFloat(totol)
                }
                self.difRelay.accept((totol, difCurrent, dif, p, true))
            } else {
                let (currentMaxLevel, currentMinLevel) = self.getMaxAndMinLevel()
                let difCurrent = currentLevel - currentMinLevel
                var dif = currentMaxLevel - currentLevel
                if dif < 0 {
                    dif = 0
                }
                let totol = currentMaxLevel - currentMinLevel
                var p: CGFloat = 1
                if totol > 0, difCurrent < totol {
                    p = CGFloat(difCurrent) / CGFloat(totol)
                }
                self.difRelay.accept((totol, difCurrent, dif, p, false))
            }
        }).disposed(by: rx.disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).startWith(0).subscribe(onNext: {[weak self] time in
            guard let self = self else { return }
            let signCanReceive = self.signReward.filter{ $0.hasReceive == 0 && $0.canReceive > 0 }
            if signCanReceive.count > 0 {
                self.signDotRelay.accept(true)
                return
            }
            let dif = Int(OnlineTimeManager.shared.getDifSeconds())
            let needReceive = self.onlineReward.filter{ $0.hasReceive == 0 }
            let canReceive = needReceive.filter{$0.duration * 60 <= dif}
            if canReceive.count > 0 {
                self.signDotRelay.accept(true)
            } else {
                self.signDotRelay.accept(false)
            }
        }).disposed(by: rx.disposeBag)
        
    }
    
    private func getMaxAndMinLevel() -> (Int, Int) {
        let checkPoint = UserManager.shared.configure?.checkpointWithdrawalChance ?? []
        let current = lastCheckpointRewardNum ?? 0
        var max = 0
        var min = 0
        for i in checkPoint {
            if i > current {
                max = i
                break
            } else {
                min = i
            }
        }
        return (max, min)
    }
    
    private func getRewardMaxAndMinLevel() -> (Int, Int) {
        let checkPoint = UserManager.shared.configure?.checkpointWithdrawalChance ?? []
        let current = lastCheckpointRewardNum ?? 0
        var max = 0
        var min = 0
        for i in checkPoint {
            if i + 3 >= current {
                max = i
                break
            } else {
                min = i
            }
        }
        return (max, min)
    }
    
    private let hasDrawKey = "hasDrawKey"
    private func getIsHawDraw(level: Int) -> Bool {
        let hasDrawLevel = UserDefaults.standard.integer(forKey: hasDrawKey)
        if hasDrawLevel < level {
            return true
        }
        return false
    }
    
    private func setupHawDraw(level: Int) {
        UserDefaults.standard.setValue(level, forKey: hasDrawKey)
    }
    
    private let hasDrawTimeKey = "hasDrawTimeKey"
    private func getHasDrawTime() -> Int {
        return UserDefaults.standard.integer(forKey: hasDrawTimeKey)
    }
    
    private func setupHawDrawTime(time: Int) {
        UserDefaults.standard.setValue(time, forKey: hasDrawTimeKey)
    }

}

class SignReward: Mapable {
    
    var canReceive : Int!
    var hasReceive : Int!
    var number : Float!
    var type : Int!
    var watchVideos : Int!
    var day = 1
    
    required init(json: JSON) {
        canReceive = json["can_receive"].intValue
        hasReceive = json["has_receive"].intValue
        number = json["number"].floatValue
        type = json["type"].intValue
        watchVideos = json["watch_videos"].intValue
    }

}

class OnlineReward: Mapable {
    
    var duration : Int!
    var hasReceive : Int!
    var max : Int!
    var min : Int!
    var type : Int!
    var watchVideos : Int!
    var number : String!

    required init(json: JSON) {
        duration = json["duration"].intValue
        hasReceive = json["has_receive"].intValue
        max = json["max"].intValue
        min = json["min"].intValue
        type = json["type"].intValue
        watchVideos = json["watch_videos"].intValue
        number = json["number"].string
    }

}




