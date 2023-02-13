//
//  AllTaskCellViewModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/29.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class AllTaskCellViewModel: NSObject {
    
    var avatar : String!
    var goldCoin : Int!
    var id : Int!
    var max : Int!
    var min : Int!
    var money : Int!
    var nowCount : Int!
    var status = BehaviorRelay<Int>(value: 0)
    var text : String!
    var textImage : String!
    
    let openReward = PublishSubject<AllTaskCellViewModel>()
    
    init(model: AllTaskList) {
        
        super.init()
        
        avatar = model.avatar
        goldCoin = model.goldCoin
        id = model.id
        max = model.max
        min = model.min
        money = model.money
        nowCount = model.nowCount
        status.accept(model.status)
        text = model.text
        textImage = model.textImage
        
    }
}
