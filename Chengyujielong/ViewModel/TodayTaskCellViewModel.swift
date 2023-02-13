//
//  TodayTaskCellViewModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/29.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class TodayTaskCellViewModel: NSObject {
    
    var goldCoin : Int!
    var id : Int!
    var max : Int!
    var min : Int!
    var nowCount : Int!
    var rewardStatus : Int!
    var text : String!
    var type : Int!
    var status = BehaviorRelay<Int>(value: 0)
    
    let openReward = PublishSubject<TodayTaskCellViewModel>()
    
    init(model: TodayTaskListModel) {
        
        super.init()
        
        goldCoin = model.goldCoin
        id = model.id
        max = model.max
        min = model.min
        nowCount = model.nowCount
        rewardStatus = model.rewardStatus
        text = model.text
        type = model.type
        status.accept(model.status)
        
    }
}
