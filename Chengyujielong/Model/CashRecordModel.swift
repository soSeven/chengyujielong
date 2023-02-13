//
//  CashRecordModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/13.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class CashRecordModel: PageModelType {
    
    typealias T = CashRecordListModel
    
    var paging: PageModel
    var data: [CashRecordListModel]
    
    required init(json: JSON) {
    
        data = json["data"].arrayValue.map{ CashRecordListModel(json: $0) }
        paging = PageModel(json: json["paging"])
        
    }
    
}

class CashRecordListModel: Mapable {
    
    var cash : Int!
    var createdAt : String!
    var id : Int!
    var paymentStatus : Int!

    required init(json: JSON) {
        cash = json["cash"].intValue
        createdAt = json["created_at"].stringValue
        id = json["id"].intValue
        paymentStatus = json["payment_status"].intValue
    }
    
}
