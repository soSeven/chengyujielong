//
//  PlayModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/9.
//  Copyright © 2020 Kaka. All rights reserved.
//

//{"data":{"lvl":3,"conf":{"barrier":[],"id":3,"word":["两","少","斤","缺","小","斤","无","计","猜","较"],"idiom":["斤斤计较","缺斤少两","两小无猜"],"posx":[2,2,2,2,3,3,4,4,5,5],"posy":[4,5,6,7,4,6,4,6,4,6],"answer":[1,4,7]}},"errcode":0,"errmsg":""}

import SwiftyJSON
import RxSwift
import RxCocoa

class PlayModel: Mapable {
    
    var lvl : Int!
    var id : Int!
    var word : [String]!
    var idiom : [String]!
    var posx : [Int]!
    var posy : [Int]!
    var answer : [Int]!
    var width = 0
    var height = 0
    var maxHeight: CGFloat = 0
    var maxWidth: CGFloat = 0
    var originScale: CGFloat = 0
    
    var margin = 4.uiX
    var itemWidth = 40.uiX
    
    required init(json: JSON) {
        
        let conf = json
        lvl = conf["id"].intValue
        id = conf["id"].intValue
        word = conf["word"].arrayValue.map{ $0.stringValue }
        idiom = conf["idiom"].arrayValue.map{ $0.stringValue }
        posx = conf["posx"].arrayValue.map{ j in
            let x =  j.intValue
            if x > width {
                width = x
            }
            return x
        }
        posy = conf["posy"].arrayValue.map{ j in
            let y =  j.intValue
            if y > height {
                height = y
            }
            return y
        }
        answer = conf["answer"].arrayValue.map{ $0.intValue }
        
        width += 1
        height += 1
    }
    
    func setupScale() {
        
        var maxRow = 2
        for (idx, _) in answer.enumerated() {
            let y = idx / width
            if y + 1 > maxRow {
                maxRow = y + 1
            }
        }
        
        let originScaleWidth = maxWidth / (CGFloat(width) * (itemWidth) + CGFloat(width - 1) * (margin))
        let originScaleHeight = maxHeight / ((CGFloat(height + maxRow) * (itemWidth) + CGFloat(height + maxRow - 2) * (margin)) + 5.uiX)
        originScale = CGFloat.minimum(originScaleWidth, originScaleHeight)
        
        itemWidth = itemWidth * originScale
        margin = margin * originScale
    }
    
    convenience init(level: Int) {
        let path = Bundle.main.path(forResource: "level_\(level)", ofType: "json")!
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path))
        let j = try! JSON(data: jsonData)
        self.init(json: j)
    }
    
}


class PlayWordViewModel: NSObject {
    
    enum ItemType {
        case empty
        case write
        case right
        case wrong
        case finish
        case wait
        case read
    }
    
    let type = BehaviorRelay<ItemType>(value: .empty)
    let text = BehaviorRelay<String?>(value: nil)
    var rightText = ""
    let selected = BehaviorRelay<Bool>(value: false)
    let animation = PublishRelay<(Bool, Float)>()
    var groupViewModel = [PlayGroupViewModel]()
    var x = 0
    var y = 0
    var distance: Float = 0
}


class PlayGroupViewModel: NSObject {
    
    let items: [PlayWordViewModel]
    let text: String?
    
    init(items: [PlayWordViewModel], text: String?) {
        
        self.items = items
        self.text = text
        
    }
 
}

class PlaySuccessModel: Mapable {
    
    var addRedPacket : String!
    var redPacket : String!
    var taskStatus : Bool!
    var lastCheckpointRewardNum : Int!

    required init(json: JSON) {
        addRedPacket = json["add_red_packet"].stringValue
        redPacket = json["red_packet"].stringValue
        taskStatus = json["task_status"].boolValue
        lastCheckpointRewardNum = json["last_checkpoint_reward_num"].intValue
    }
    
}
