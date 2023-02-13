//
//  PageModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class PageModel: Mapable {
    
    var total : Int!
    var count : Int!
    var page : Int!

    required init(json: JSON) {
        total = json["total"].intValue
        count = json["count"].intValue
        page = json["page"].intValue
    }
    
}

protocol PageModelType: Mapable {
    
    associatedtype T
    
    var paging : PageModel { get }
    var data : [T] { get }
    
}
