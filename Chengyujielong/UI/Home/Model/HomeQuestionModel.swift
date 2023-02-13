//
//  HomeQuestionModel.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/9.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift

class HomeQuestionModel: Mapable {
    
    var lvl : Int!
    var id : Int!
    var word : [String]!
    var idiom : [String]!
    var posx : [Int]!
    var posy : [Int]!
    var answer : [Int]!
    
    required init(json: JSON) {
        lvl = json["data"]["lvl"].intValue
        id = json["data"]["conf"]["id"].intValue
        word = json["data"]["conf"]["word"].arrayValue.map{ $0.stringValue }
        idiom = json["data"]["conf"]["idiom"].arrayValue.map{ $0.stringValue }
        posx = json["data"]["conf"]["posx"].arrayValue.map{ $0.intValue }
        posy = json["data"]["conf"]["posy"].arrayValue.map{ $0.intValue }
        answer = json["data"]["conf"]["answer"].arrayValue.map{ $0.intValue }
        

    }
    
}

struct HomeQuestionCellModel {
    
    var word : String! = ""
    var posx : Int! 
    var posy : Int!
    var isAnswer : Bool! = false
    var showWord : String! = ""
    var isEnd : Bool! = false
    var isRight : Bool! = true
    var inAnswerArrayIndex : Int! = 0
    var isSelected : Bool! = false
}

struct HomeIdiomModel {
    
    var word : String!  //成语
    var modelAarray : [HomeQuestionCellModel]! //成语各个字的model
    var isByX : Bool!  //是否以x排序
    
}

struct HomeAnswerCellModel {
    
    var word : String! = ""
    var isFill : Bool! = false
    var index : Int! = 0
}

