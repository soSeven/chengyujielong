//
//  NetProvider.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Moya
import FCUUID
import Alamofire
import FileKit
import Kingfisher
import SwifterSwift
import AdSupport

let NetProvider = MoyaProvider<NetAPI>(requestClosure: { (endpoint, done) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 20//设置请求超时时间
        done(.success(request))
    } catch {

    }
})

public enum NetAPI {
    case login
    case updateUser(token: String? = nil, userId: String? = nil)
    case configure(token: String? = nil, userId: String? = nil)
    
    /// 抽奖
    case lottery
    /// 提现
    case getCash
    /// 绑定微信号
    case bindWeChat(openid: String, sex: Int, unionid: String, avatar: String, nickName: String)

    /// 清空提现机会
    case clearDraw
    
    /// 金币拆红包
    case openRedBag
    
    /// 成就任务
    case allTask
    /// 今天任务
    case todayTask
    /// 领取成就
    case acceptAllTask(id: Int)
    /// 领取今日任务
    case acceptTodayTask(id: Int)
    
    ///领取闯关奖励(关卡数,0=未看视频1=已看视频,需要增加的红包金额)
    case passGameAward(checkpoint: Int,video : Int,red_packet: String)
    ///添加提示和重玩次数
    case addTipsRePlayNum
    ///领取签到奖励
    case rewardSign
    ///领取在线时长奖励
    case rewardOnline(duration: String,number: String)
}

public enum ProtocolType: String {
    /// 成语大神服务协议
    case user       = "user_agreement"
    /// 成语大神隐私政策
    case privacy    = "privacy_policy"
    /// 结算协议
    case settlement = "settlement_agreement"
}

extension NetAPI: TargetType {
    
    static var getBaseURL: String {
        if AppDefine.isDebug {
            return "https://api-testing.ynxxhy.com/"
        } else {
            return "https://api.ynxxhy.com/"
        }
        
    }
    
    static var getHTMLURL: String {
        if AppDefine.isDebug {
            return "http://www-testing.ynxxhy.com/"
        } else {
            return "http://www.ynxxhy.com/pages/"
        }
        
    }
    
    static func getHtmlProtocol(type: ProtocolType) -> URL? {
        return URL(string: String(format: "%@pages/%@", NetAPI.getHTMLURL, type.rawValue))
    }
    
    public var baseURL: URL {
        let baseUrl = URL(string: NetAPI.getBaseURL)!
        return baseUrl
    }
    
    public var path: String {
        
        switch self {
        case .login:
            return "api/v1/login"
        case .updateUser:
            return "api/v1/user/info"
        case .configure:
            return "api/v1/common/getConfig"
        case .lottery:
            return "api/v1/withdrawal/receiveDrawRes"
        case .getCash:
            return "api/v1/withdrawal/apply"
        case .bindWeChat:
            return "api/v1/user/bindWechat"
        case .clearDraw:
            return "api/v1/withdrawal/clearDraw"
        case .allTask:
            return "api/v1/task/index"
        case .todayTask:
            return "api/v1/task/indexToday"
        case .acceptAllTask:
            return "api/v1/task/addReward"
        case .acceptTodayTask:
            return "api/v1/task/addRewardToday"
        case .passGameAward:
            return "api/v1/reward/checkpoint"
        case .addTipsRePlayNum:
            return "api/v1/reward/addTipsRePlayNum"
        case .rewardSign:
            return "api/v1/reward/sign"
        case .rewardOnline:
            return "api/v1/reward/online"
        case .openRedBag:
            return "api/v1/reward/openRedPacket"
        }
    }
    
    public var method: Moya.Method {

        return .post
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var parameters: [String:Any]  {
        
        var params:[String:Any] = [:]
        if let id = UserManager.shared.login.value.0?.id {
            params["userid"] = id
        }
        if let token = UserManager.shared.login.value.0?.token {
            params["token"] = token
        }
        
        switch self {
        case .login:
            params["device_number"] = UIDevice.current.uuid()
        case let .updateUser(token, userId):
            if let t = token {
                params["token"] = t
            }
            if let u = userId {
                params["userid"] = u
            }
        case let .bindWeChat(openid, sex, unionid, avatar, nickName):
            params["openid"] = openid
            params["sex"] = sex
            params["unionid"] = unionid
            params["avatar"] = avatar.urlEncoded
            params["nickname"] = nickName
        case let .acceptAllTask(id):
            params["task_id"] = id
        case let .acceptTodayTask(id):
            params["task_id_today"] = id
        case let .passGameAward(checkpoint, video, red_packet):
            params["checkpoint"] = checkpoint
            params["video"] = video
            params["red_packet"] = red_packet
        case let .rewardOnline(duration ,number):
            params["duration"] = duration
            params["number"] = number
        default:
            break
        }
        return params
    }
    
    public var task: Task {
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        
        var headers:[String : String] = [:]
        
        headers["os"] = "1"
        headers["channel"] = "AppStore"
        headers["version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        headers["timestamp"] = Date().timeIntervalSince1970.string

        if let userid = UserManager.shared.login.value.0?.id {
            headers["userid"] = userid
        }
        
        if let token = UserManager.shared.login.value.0?.token {
            headers["token"] = token
        }
        
        switch self {
        case .login:
            headers["device-number"] = UIDevice.current.uuid()
        case let .updateUser(token, userId):
            if let t = token {
                headers["token"] = t
            }
            if let u = userId {
                headers["userid"] = u
            }
        case let .configure(token, userId):
            if let t = token {
                headers["token"] = t
            }
            if let u = userId {
                headers["userid"] = u
            }
        default:
            break
        }
        
        switch self {
        case .login:
            headers["sign"] = getSign(pa: headers)
        default:
            headers["sign"] = getSign(pa: headers + parameters)
        }
        
        return headers
    }
    
    private func getSign(pa: [String:Any]) -> String {
        let secretKey = AppDefine.isDebug ? "chengyudashen" : "wCmg8bAT3Eqqj3ChwVnEJJwVqeUPPHAK"
        let a = pa.sorted { (v1, v2) -> Bool in
            v1.key < v2.key
        }
        let s = a.map { (key, value) -> String in
            if let str = value as? String {
                return "\(key)=\(str.urlEncoded)"
            } else {
                return "\(key)=\(value)"
            }
        }.joined(separator: "&") + "&key=\(secretKey)"
        let md5 = s.md5.uppercased()
        return md5
    }
    
}

