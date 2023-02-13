//
//  HomeSignView.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/21.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import UIKit
import Hue
import SnapKit
import YYText
import RxSwift

class HomeSignView: UIView {
    
    private var cellArray:NSMutableArray?
    private var onlineCellArray:NSMutableArray?
    private var getSignButton : UIButton?
    private var onlinelineView : UIView?
    private var lineColorView : UIImageView?
    private var getLineButton : UIButton?
    private var timer : Timer?
    private var nextSecond : Int?
    private var nextGetModel :OnlineReward?
    private var nextSignModel :SignReward?
    private var signAwardView : HomeSignAwardView = {
        let signAwardView = HomeSignAwardView.init(frame: UIScreen.main.bounds)
        return signAwardView
    }()

    override init(frame: CGRect)  {
        
        super.init(frame: frame)
        
        setUpUI()
        
    }
    
    deinit {
        print("\(self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        
        let bgImage = UIImage.init(named: "home_img_frame01")!
                
        let BGImageView = UIImageView()
        BGImageView.image = bgImage
        
        self.addSubview(BGImageView)
        BGImageView.isUserInteractionEnabled = true
        
        BGImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(360.uiX)
            make.height.equalTo(480.uiX)
        }
        self.layoutIfNeeded()
        
        let closeImage = UIImage.init(named: "task_img_close")!
        let closeImageView = UIButton()
        closeImageView.setBackgroundImage(closeImage, for: .normal)
        
        self.addSubview(closeImageView)
        closeImageView.width = closeImage.size.width.uiX
        closeImageView.height = closeImage.size.height.uiX
        closeImageView.y = BGImageView.y - closeImageView.height
        closeImageView.x = 330.uiX
        closeImageView.addTarget(self, action: #selector(close) , for:.touchUpInside )
        
        let titleImage = UIImage.init(named: "sign_img_title")!
        let titleImageView = UIImageView()
        titleImageView.image = titleImage
        self.addSubview(titleImageView)
        titleImageView.isUserInteractionEnabled = true
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(BGImageView).offset(-18.uiX)
            make.width.equalTo(titleImage.size.width.uiX)
            make.height.equalTo(titleImage.size.height.uiX)
        }
        
        let signLabel = UILabel()
        signLabel.textAlignment = .left
        signLabel.textColor = .init(hex: "#7A310C")
        signLabel.font = UIFont.init(name: "HYa9gj", size: 16.uiX)
        signLabel.text = "登录奖励"
        self.addSubview(signLabel)
        signLabel.snp.makeConstraints { (make) in
            make.left.equalTo(BGImageView).offset(30.uiX)
            make.top.equalTo(BGImageView).offset(62.uiX)
            make.width.equalTo(70.uiX)
            make.height.equalTo(16.uiX)
        }
        
        let getSignButton = UIButton.init(frame: .zero)
        let getSignImage = UIImage.init(named: "sign_img_btn01")!
        getSignButton.setBackgroundImage(getSignImage, for: .normal)
        self.addSubview(getSignButton)
        getSignButton.snp.makeConstraints { (make) in
            make.right.equalTo(BGImageView).offset(-30.uiX)
            make.bottom.equalTo(signLabel).offset(3.uiX)
            make.width.equalTo(getSignImage.size.width.uiX)
            make.height.equalTo(getSignImage.size.height.uiX)
        }
        getSignButton.setTitle("", for: .normal)
        getSignButton.setTitle("明日可领取", for: .disabled)
        getSignButton.titleLabel?.font = .init(style: .regular, size: 13)
        getSignButton.titleLabel?.textColor = .init(hex: "#E8E7E6")
        getSignButton.titleLabel?.textAlignment = .center
        getSignButton.setBackgroundImage(UIImage.init(named: "sign_img_btn02")!, for: .disabled)
        
        self.layoutIfNeeded()
        let cellWidth = 64.uiX
        let cellHeight = 86.uiX
        let space = 10.uiX
        let cellArray = NSMutableArray()
        let count = 7
        var num = 0
        for _ in 0..<count {
            var cellX: CGFloat = 0.0
            var cellY: CGFloat = 0.0
            var width: CGFloat = 0.0
            cellX = CGFloat(num) * (cellWidth + space) + 80.uiX
            cellY = signLabel.frame.maxY + 70.uiX
            width = cellWidth
            if num > 3 {
                cellX = CGFloat(num - 4) * (cellWidth + space) + 80.uiX
                cellY = cellHeight + signLabel.frame.maxY + 76.uiX
            }
            if num == 6 {
                width = cellWidth*2 + 10.uiX
                cellX = CGFloat(num - 4) * (cellWidth + space) + 118.uiX
            }
            let cell = HomeSignCellView.init(frame: CGRect.init(center: CGPoint.init(x: cellX, y: cellY), size: CGSize.init(width: width, height: cellHeight)))
            cell.indexNum = num
            cellArray.add(cell)
            self.addSubview(cell)
            num += 1
        }
        self.cellArray = cellArray
        
        let onlineLabel = UILabel()
        onlineLabel.textAlignment = .left
        onlineLabel.textColor = .init(hex: "#7A310C")
        onlineLabel.font = UIFont.init(name: "HYa9gj", size: 16.uiX)
        onlineLabel.text = "在线奖励"
        self.addSubview(onlineLabel)
        onlineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(BGImageView).offset(30.uiX)
            make.top.equalTo(signLabel.snp_bottomMargin).offset(240.uiX)
            make.width.equalTo(70.uiX)
            make.height.equalTo(16.uiX)
        }
        
        let getLineButton = UIButton.init(frame: .zero)
        let getLineImage = UIImage.init(named: "sign_img_btn01")!
        getLineButton.setBackgroundImage(getLineImage, for: .normal)
        getLineButton.setBackgroundImage(UIImage.init(named: "sign_img_btn02")!, for: .disabled)
        self.addSubview(getLineButton)
        getLineButton.snp.makeConstraints { (make) in
            make.right.equalTo(BGImageView).offset(-30.uiX)
            make.bottom.equalTo(onlineLabel).offset(3.uiX)
            make.width.equalTo(getLineImage.size.width.uiX)
            make.height.equalTo(getLineImage.size.height.uiX)
        }
        getLineButton.setTitle("", for: .normal)
        getLineButton.titleLabel?.font = .init(style: .regular, size: 13)
        getLineButton.titleLabel?.textColor = .init(hex: "#E8E7E6")
        getLineButton.titleLabel?.textAlignment = .center
        self.getLineButton = getLineButton
        self.layoutIfNeeded()
        
        let onlineCellArray = NSMutableArray()
        let subCount = 4
        var subNum = 0
        let distance = 37.uiX
        let onlineCellWidth = 40.uiX
        let onlineCellHeight = 100.uiX
        let cellY = onlineLabel.frame.maxY + 32.uiX
        
        var firstCell :HomeOnlineSignCellView?
        var lastCell :HomeOnlineSignCellView?
        for _ in 0..<subCount {
            let cellX = 50.uiX + (distance + onlineCellWidth) * CGFloat(subNum)
            let cell = HomeOnlineSignCellView.init(frame: CGRect.init(origin: CGPoint.init(x: cellX, y: cellY), size: CGSize.init(width: onlineCellWidth, height: onlineCellHeight)))
            addSubview(cell)
            onlineCellArray.add(cell)
            if subNum == 0 {
                firstCell = cell
            }
            if subNum == subCount - 1 {
                lastCell = cell
            }
            subNum += 1
        }
        self.onlineCellArray = onlineCellArray
        
        if firstCell != nil && lastCell != nil {
            let onlinelineView = UIView.init(frame: .zero)
            insertSubview(onlinelineView, belowSubview: firstCell!)
            onlinelineView.layer.borderWidth = 1.5.uiX
            onlinelineView.layer.borderColor = UIColor.init(hex: "#582C06").cgColor
            onlinelineView.snp.makeConstraints { (make) in
                make.left.equalTo(firstCell!).offset(firstCell!.width/2)
                make.top.equalTo(firstCell!).offset(firstCell!.width/2)
                make.right.equalTo(lastCell!).offset(-(lastCell!.width/2))
                make.height.equalTo(10.uiX)
            }
            self.onlinelineView = onlinelineView
            
            let lineColorView = UIImageView.init(frame: .zero)
            insertSubview(lineColorView, aboveSubview: onlinelineView)
            lineColorView.image = UIImage.init(named: "home_img_schedule")
            lineColorView.snp.makeConstraints { (make) in
                make.left.centerY.equalTo(onlinelineView)
                make.width.equalTo(onlinelineView)
                make.height.equalTo(7.uiX)
            }
            self.lineColorView = lineColorView
            
            layoutIfNeeded()
        }
        
        getSignButton.addTarget(self, action: #selector(showSignAwardView), for: .touchUpInside)
        self.getSignButton = getSignButton
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let u = u else { return }
            self.changeUI(user: u)
        }).disposed(by: rx.disposeBag)
        
        getLineButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.getOnlineButtonAction()
        }).disposed(by: rx.disposeBag)
    }
    
    private func changeUI(user: UserModel) {
        //签到奖励
        let array :[SignReward] = user.signReward
        var count = 0
        var canGetReward = false
        for _ in 0..<array.count {
            guard let cellArray = self.cellArray else { return }
            let cell = cellArray[count] as! HomeSignCellView
            let model = array[count]
            cell.model  = model
            if model.canReceive == 1 && model.hasReceive == 0{
                canGetReward = true
                nextSignModel = model
            }
            count += 1
        }
        
        if canGetReward {
            getSignButton?.isEnabled = true
        } else {
            getSignButton?.isEnabled = false
        }
        
        //在线奖励
        let onlineArray :[OnlineReward] = user.onlineReward
        var onlineCount = 0
        let time = getOnlineTime()
        //是否全部领取完毕
        var isAllGet = true
        //是否有可以领取的
        var isTimeReady = false
        var nextModel :OnlineReward?
        var lastGetCount :Int = 0
        for _ in 0..<onlineArray.count {
            guard let array = self.onlineCellArray else { return }
            let cell = array[onlineCount] as! HomeOnlineSignCellView
            let model = onlineArray[onlineCount]
            cell.onlineTime = time
            cell.model = model
            if model.hasReceive == 0 {
                isAllGet = false
            }
            let durationTime = model.duration * 60
            if model.hasReceive == 0 && durationTime <= time && isTimeReady == false {
                isTimeReady = true
                nextGetModel = model
            }
            if nextModel == nil && model.hasReceive == 0 && durationTime > time{
                nextModel = model
            }
            if durationTime <= time {
                lastGetCount = onlineCount
            }
            onlineCount += 1
        }
        
        if self.lineColorView != nil {
            let colorWidth = Float(onlinelineView!.size.width) * Float(1.0/Float(onlineArray.count-1)) * Float(lastGetCount)
            
            self.lineColorView?.snp.remakeConstraints{ (make) in
                make.left.centerY.equalTo(self.onlinelineView!)
                make.width.equalTo(colorWidth)
                make.height.equalTo(7.uiX)
            }
        }
        
        if timer != nil {
            timer!.invalidate()
        }
        
        if isAllGet {
            getLineButton?.setTitle("明日可领取", for: .disabled)
            getLineButton?.isEnabled = false
            
        } else if isTimeReady {
            getLineButton?.isEnabled = true
        } else {
            getLineButton?.isEnabled = false
            getLineButton?.setTitle("00:00后可领取", for: .disabled)
            if nextModel != nil {
                startTimerWithModel(model: nextModel!)
            }
        }
        
    }
    
    private func startTimerWithModel (model : OnlineReward) {
        let second = getOnlineTime ()
        let modelSecond = model.duration * 60
        nextSecond = modelSecond - second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard self == self else {return}
            let timeString = self?.transToMinSec(time: (self?.nextSecond)!)
            self?.getLineButton?.setTitle("\(timeString ?? "")后可领取", for: .disabled)
            if self?.nextSecond! == 0 {
//                UserManager.shared.updateUser()
                if let u = UserManager.shared.user {
                    UserManager.shared.login.accept((u, .change))
                }
            } else {
                self?.nextSecond! -= 1
            }
        })
        
    }
    private func transToMinSec(time: Int) -> String
    {
        let allTime: Int = Int(time)
        var minutes = 0
        var seconds = 0
        var minutesText = ""
        var secondsText = ""
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "\(minutesText):\(secondsText)"
    }
    
    @objc func showSignAwardView () {
            
        if nextSignModel == nil {return}
        
//        if nextSignModel!.watchVideos > 0 {
//            let showAD: () -> Void = {[weak self] in
//                guard let self = self else { return }
//                if let sup = self.parentViewController as? PopView {
//                    let ad = RewardVideoSingleAd.shared
//                    ad.showAd(vc: sup)
//                    ad.completion = {
//                        self.signRequest ()
//                    }
//                }
//            }
//            showAD()
//        } else {
            signRequest ()
//        }
        
    }
    
    private func signRequest () {
        requestRewardSign().subscribe(onNext: {[weak self] model in
            guard let self = self else { return }
            guard let model = model else { return }
            self.didGetRewardSign(model: model)
//            UserManager.shared.updateUser()
            if let u = UserManager.shared.user {
                u.redPacket = model.redPacket
                u.goldCoin = model.goldCoin
                UserManager.shared.login.accept((u, .change))
            }
            
        }, onError: { error in
            
        }).disposed(by: self.rx.disposeBag)
    }
    
    private func didGetRewardSign (model : HomeSignModel) {
        close ()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let view = HomeSignAwardView.init(frame: UIScreen.main.bounds)
            view.model = model
            PopView.show(view: view)
        }
    }
    
    @objc func close () {
        if let sup = self.parentViewController as? PopView {
            sup.hide()
        }
    }
    
    // MARK: - Request
    private func requestRewardSign() -> Observable<HomeSignModel?>{
        return NetManager.requestObj(.rewardSign, type: HomeSignModel.self).asObservable()
        
    }
    
    func getOnlineTime () -> Int {
        
        var nowOnlineTime = 0
        let  now =  NSDate ()
        let  dformatter =  DateFormatter ()
        dformatter.dateFormat =  "yyyy年MM月dd日"
        let dateString = dformatter.string(from: now as Date)
        let  timeInterval: TimeInterval  = now.timeIntervalSince1970
        let  timeStamp =  Int (timeInterval)
        let lastDateString = UserDefaults.standard.string(forKey: "todayDateString")
        if lastDateString != dateString {
            UserDefaults.standard.set(dateString, forKey: "todayDateString")
            UserDefaults.standard.set(0, forKey: "userOnlineTime")
        } else {
            let lastOnlineTime = UserDefaults.standard.integer(forKey: "userOnlineTime")
            let lastOnlineTimeStamp = UserDefaults.standard.integer(forKey: "userOnlineTimeStamp")
            let subTime = timeStamp - lastOnlineTimeStamp
            nowOnlineTime = lastOnlineTime + subTime
            UserDefaults.standard.set(nowOnlineTime, forKey: "userOnlineTime")
            UserDefaults.standard.set(timeStamp, forKey: "userOnlineTimeStamp")
        }
        
        return nowOnlineTime
    }

    private func changeOnlineUI () {
        
    }
    
    @objc private func getOnlineButtonAction() {
        
       if self.nextGetModel == nil { return }
        
        let getRequest: () -> Void = {[weak self] in
            guard let self = self else {return}
            self.requestGetOnlineReward().subscribe(onNext: { model in
                self.close()
//                UserManager.shared.updateUser()
                if let u = UserManager.shared.user, let m = model {
                    u.redPacket = m.redPacket
                    u.goldCoin = m.goldCoin
                    UserManager.shared.login.accept((u, .change))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    let view = HomeOnlineSignRewardView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                    view.model = model
                    PopView.show(view:view)
                }
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }
        
//        if nextGetModel!.watchVideos > 0 {
//            let showAD: () -> Void = {[weak self] in
//                guard let self = self else { return }
//                if let sup = self.parentViewController as? PopView {
//                    let ad = RewardVideoSingleAd.shared
//                    ad.showAd(vc: sup)
//                    ad.completion = {
//                        getRequest ()
//                    }
//                }
//            }
//            showAD()
//        } else {
            getRequest()
//        }
        
    }
    
    // MARK: - Request
    private func requestGetOnlineReward() -> Observable<HomeOnlineSignModel?> {
        return NetManager.requestObj(.rewardOnline(duration: "\(self.nextGetModel?.duration ?? 0)", number: self.nextGetModel?.number ?? "0"), type: HomeOnlineSignModel.self).asObservable()
        
    }
}

class HomeSignCellView: UIView {
    
    private var BGImageView : UIImageView?
    private var centerImageView : UIImageView?
    private var numLabel : UILabel?
    private var titleLabel : UILabel?
    private var coverView : UIView?
    private var rightImageView : UIImageView?
    
    var model : SignReward? {
        didSet {
            let n = NumberFormatter()
            n.maximumFractionDigits = 2
            n.minimumFractionDigits = 0
            let s = n.string(from: NSNumber(value: model!.number)) ?? "0"
            if model!.type == 1 {
                //奖励类型。1=红包，2=金币
                centerImageView?.image = UIImage.init(named: "sign_login_hongbao")!
                numLabel?.text = "+\(s)元"
            } else {
                centerImageView?.image = UIImage.init(named: "sign_login_coin")!
                numLabel?.text = "+\(s)"
            }
            
            if model?.hasReceive == 1 {
                self.coverView?.isHidden = false
                self.rightImageView?.isHidden = false
            } else {
                self.coverView?.isHidden = true
                self.rightImageView?.isHidden = true
            }
            
            if model?.canReceive == 1 {
                BGImageView?.image = UIImage.init(named: "sign_login_img_choose")!
            }
            
        }
    }
    
    
    var indexNum : Int {
        didSet {
            if indexNum == 6 {
                let bgImage = UIImage.init(named: "sign_login_img03")!
                self.BGImageView!.snp.updateConstraints({ (make) in
                    make.center.equalToSuperview()
                    make.width.equalTo(bgImage.size.width.uiX*2 + 10.uiX)
                    make.height.equalTo(bgImage.size.height.uiX)
                })
            }
            var string = "第一天"
            switch indexNum {
            case 0:
                string = "第一天"
                break
            case 1:
                string = "第二天"
                break
            case 2:
                string = "第三天"
                break
            case 3:
                string = "第四天"
                break
            case 4:
                string = "第五天"
                break
            case 5:
                string = "第六天"
                break
            case 6:
                string = "第七天"
                break
            default:
                break
            }
            self.titleLabel?.text = string
            
        }
    }
    
    override init(frame: CGRect)  {
        indexNum = 0
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        let bgImage = UIImage.init(named: "sign_login_img03")!
        let BGImageView = UIImageView()
        BGImageView.image = UIImage.init(named: "sign_login_img02")!
        self.addSubview(BGImageView)
        BGImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(bgImage.size.width.uiX)
            make.height.equalTo(bgImage.size.height.uiX)
        }
        self.BGImageView = BGImageView
        
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.init(style: .medium, size: 10)
        titleLabel.textColor = .init(hex: "#7A310C")
        titleLabel.textAlignment = .center
        titleLabel.text = "第一天"
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(BGImageView)
            make.height.equalTo(18.uiX)
            make.top.equalTo(BGImageView)
        }
        self.titleLabel = titleLabel
        
        let centerImage = UIImage.init(named: "sign_login_coin")!
        let centerImageView = UIImageView()
        centerImageView.image = centerImage
        self.addSubview(centerImageView)
        centerImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(centerImage.size.width.uiX)
            make.height.equalTo(centerImage.size.height.uiX)
        }
        self.centerImageView = centerImageView
        
        let numLabel = UILabel.init()
        numLabel.font = UIFont.init(name: "DIN-Bold", size: 12.5.uiX)
        numLabel.textColor = .init(hex: "#7A310C")
        numLabel.textAlignment = .center
        numLabel.text = "+200"
        self.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(BGImageView)
            make.height.equalTo(12.uiX)
            make.top.equalTo(centerImageView.snp_bottomMargin).offset(8.uiX)
        }
        self.numLabel = numLabel
        
        let coverView = UIView.init()
        coverView.backgroundColor = .init(white: 1, alpha: 0.4)
        self.addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.center.equalTo(BGImageView)
            make.width.height.equalTo(BGImageView)
        }
        coverView.cornerRadius = 6.uiX
        coverView.clipsToBounds = true
        coverView.isHidden = true
        self.coverView = coverView
        
        let rightImage = UIImage.init(named: "sign_login_choose")!
        let rightImageView = UIImageView()
        rightImageView.image = rightImage
        self.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { (make) in
            make.width.equalTo(rightImage.size.width.uiX)
            make.height.equalTo(rightImage.size.height.uiX)
            make.right.equalTo(BGImageView).offset(2.uiX)
            make.bottom.equalTo(BGImageView).offset(2.uiX)
        }
        self.rightImageView = rightImageView
        
    }
    
}

class HomeSignAwardView: UIView {
    
    var getButton: UIButton?
    var coinImageView: UIImageView?
    var tipLabel: UILabel?
    var awardLabel: UILabel?
    var model : HomeSignModel? {
        didSet {
            if (model?.addRedPacket)! > 0 {
                //红包
                YBPlayAudio.cashClick()
                let image = UIImage.init(named: "sign_reward_img_hongbao")
                coinImageView?.image = image
                coinImageView?.snp.updateConstraints({ (make) in
                    make.size.equalTo(image!.snpSize)
                })
                tipLabel?.text = "我的余额:\(model?.redPacket ?? "")"
                awardLabel?.text = String(format: "+%.2f", model?.addRedPacket ?? 0)
                
            } else {
                //金币
                YBPlayAudio.coinClick()
                let image = UIImage.init(named: "sign_reward_img_coin")
                coinImageView?.image = image
                coinImageView?.snp.updateConstraints({ (make) in
                    make.size.equalTo(image!.snpSize)
                })
                tipLabel?.text = "我的金币:\(model?.goldCoin ?? 0)"
                awardLabel?.text = "+\(model?.addGoldCoin ?? 0)"
            }
        }
    }
    private func setUpUI() {
        
        let bgImage = UIImage.init(named: "sign_reward_img_bgd")!
        let BGImageView = UIImageView()
        BGImageView.image = bgImage
        self.addSubview(BGImageView)
        BGImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(102.uiX+UIDevice.statusBarHeight)
            make.width.equalTo(bgImage.size.width.uiX)
            make.height.equalTo(bgImage.size.height.uiX)
        }
        
        let coinImage = UIImage.init(named: "sign_reward_img_coin")!
        let coinImageView = UIImageView()
        coinImageView.image = coinImage
        self.addSubview(coinImageView)
        coinImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(BGImageView).offset(110.uiX)
            make.width.equalTo(coinImage.size.width.uiX)
            make.height.equalTo(coinImage.size.height.uiX)
        }
        self.coinImageView = coinImageView
        
        let getButton = UIButton.init(frame: .zero)
        let getImage = UIImage.init(named: "sign_reward_img_btn03")!
        getButton.setBackgroundImage(getImage, for: .normal)
        self.addSubview(getButton)
        getButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(BGImageView.snp_bottomMargin).offset(16.uiX)
            make.width.equalTo(getImage.size.width.uiX)
            make.height.equalTo(getImage.size.height.uiX)
        }
        self.getButton = getButton
        
        let tipLabel = UILabel.init()
        tipLabel.font = UIFont.init(style: .regular, size: 12.uiX)
        tipLabel.textColor = .init(hex: "#FFDEB0")
        tipLabel.textAlignment = .center
        tipLabel.text = "我的金币：9999"
        self.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(BGImageView)
            make.height.equalTo(12.uiX)
            make.top.equalTo(getButton.snp_bottomMargin).offset(12.uiX)
        }
        self.tipLabel = tipLabel
        
        let ligntImage = UIImage.init(named: "img_lignt_all")!
        let ligntImageView = UIImageView()
        ligntImageView.image = ligntImage
        self.insertSubview(ligntImageView, belowSubview: coinImageView)
        ligntImageView.snp.makeConstraints { (make) in
            make.center.equalTo(coinImageView)
            make.width.equalTo(ligntImage.size.width.uiX)
            make.height.equalTo(ligntImage.size.height.uiX)
        }
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        ligntImageView.layer.add(ro, forKey: "rotationAnimation")
        
        let awardLabel = UILabel.init()
        awardLabel.font = UIFont.init(style: .medium, size: 25.uiX)
        awardLabel.textColor = .init(hex: "#E38416")
        awardLabel.textAlignment = .center
        awardLabel.text = "+3000"
        self.addSubview(awardLabel)
        awardLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(BGImageView)
            make.height.equalTo(20.uiX)
            make.top.equalTo(coinImageView.snp_bottomMargin).offset(25.uiX)
        }
        self.awardLabel = awardLabel
        
        getButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    override init(frame: CGRect)  {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    @objc func close () {
        if let sup = self.parentViewController as? PopView {
            sup.hide()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class HomeOnlineSignCellView: UIView {
    
    var getOnlineButton: UIButton?
    var bgImageView: UIImageView?
    var imageView: UIImageView?
    var chooseImageView: UIImageView?
    var subLabel: UILabel?
    var subTimeLabel: UILabel?
    var onlineTime : Int = 0
    
    var model : OnlineReward? {
        didSet {
            guard let model = model else { return }
            subLabel?.text = "+\(model.number ?? "0")"
            subTimeLabel?.text = "\(model.duration ?? 0)分钟"
            
            //1=红包，2=金币
            if model.type == 1 {
                let image = UIImage.init(named: "sign_online_hongbao")
                imageView?.image = image
            } else {
                let image = UIImage.init(named: "sign_online_coin")
                imageView?.image = image
            }
            
            //0=未领取，1=已领取
            if (model.hasReceive != nil) {
                if model.hasReceive == 0 {
                    chooseImageView?.isHidden = true
                    let getTime = model.duration * 60
                    if onlineTime >= getTime {
                        subTimeLabel?.text = "可领取"
                        bgImageView?.image = UIImage.init(named: "sign_online_img01")!
                        bgImageView?.layer.borderWidth = 0.uiX
                        bgImageView?.backgroundColor = .clear
                    }
                } else {
                    chooseImageView?.isHidden = false
                    subTimeLabel?.text = "已领取"
                    bgImageView?.image = UIImage.init(named: "sign_online_img01")!
                    bgImageView?.layer.borderWidth = 0.uiX
                    bgImageView?.backgroundColor = .clear
                }
                
            }
        

            
        }
    }
    
    private func setUpUI () {
        
        let bgImage = UIImage.init(named: "sign_online_img01")!
        let bgImageView = UIImageView()
        bgImageView.image = UIImage()
        bgImageView.backgroundColor = .init(hex: "#F9DAA8")
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.width.equalTo(bgImage.size.width.uiX)
            make.height.equalTo(bgImage.size.height.uiX)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        self.bgImageView = bgImageView
        bgImageView.layer.cornerRadius = bgImage.size.width.uiX/2
        bgImageView.layer.borderWidth = 1.5.uiX
        bgImageView.layer.borderColor = UIColor.init(hex: "#582C06").cgColor
        bgImageView.clipsToBounds = true
        
        let image = UIImage.init(named: "sign_online_coin")
        let imageView = UIImageView()
        imageView.image = image
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(image!.size)
            make.top.equalToSuperview().offset(5.uiX)
            make.centerX.equalToSuperview()
        }
        self.imageView = imageView
        
        let subLabel = UILabel()
        subLabel.textAlignment = .center
        subLabel.textColor = .init(hex: "#B08260")
        subLabel.font = UIFont.init(name: "DIN-Bold", size: 11.uiX)
        subLabel.text = "+100  "
        self.addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.top.equalToSuperview().offset(26.5.uiX)
            make.width.equalTo(40.uiX)
            make.height.equalTo(10.uiX)
        }
        self.subLabel = subLabel
        
        let subTimeLabel = UILabel()
        subTimeLabel.textAlignment = .center
        subTimeLabel.textColor = .init(hex: "#7A310C")
        subTimeLabel.font = UIFont.init(style: .medium, size: 11.uiX)
        subTimeLabel.text = "10分钟"
        self.addSubview(subTimeLabel)
        subTimeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.top.equalTo(bgImageView.snp_bottomMargin).offset(20.uiX)
            make.width.equalToSuperview()
            make.height.equalTo(10.uiX)
        }
        self.subTimeLabel = subTimeLabel
        
        let chooseImage = UIImage.init(named: "sign_login_choose")
        let chooseImageView = UIImageView()
        chooseImageView.image = chooseImage
        addSubview(chooseImageView)
        chooseImageView.snp.makeConstraints { (make) in
            make.width.equalTo(17.5.uiX)
            make.height.equalTo(16.5.uiX)
            make.centerY.equalTo(bgImageView.snp_bottomMargin).offset(5.uiX)
            make.centerX.equalToSuperview()
        }
        self.chooseImageView = chooseImageView
        
        let getOnlineButton = UIButton.init(frame: .zero)
        self.addSubview(getOnlineButton)
        getOnlineButton.snp.makeConstraints { (make) in
            make.center.equalTo(bgImageView)
            make.size.equalTo(bgImageView)
        }
        self.getOnlineButton = getOnlineButton
        
//        getOnlineButton.rx.tap.subscribe(onNext: {[weak self] _ in
//            guard let self = self else { return }
//            self.getOnlineButtonAction()
//        }).disposed(by: rx.disposeBag)
    }
    
    override init(frame: CGRect)  {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func getOnlineButtonAction() {
        requestGetOnlineReward().subscribe(onNext: { model in
//            UserManager.shared.updateUser()
            if let u = UserManager.shared.user, let m = model {
                u.redPacket = m.redPacket
                u.goldCoin = m.goldCoin
                UserManager.shared.login.accept((u, .change))
            }
        }, onError: { error in
            
        }).disposed(by: self.rx.disposeBag)
    }
    
    // MARK: - Request
    private func requestGetOnlineReward() -> Observable<HomeOnlineSignModel?> {
        return NetManager.requestObj(.rewardOnline(duration: "\(self.model?.duration ?? 0)", number: self.model?.number ?? "0"), type: HomeOnlineSignModel.self).asObservable()
        
    }
}

class HomeOnlineSignRewardView: UIView {
    
    private var sumLabel: UILabel?
    private var sureButton: UIButton?
    private var RedPacketImageView: UIImageView?
    private var titleImageView: UIImageView?
    private var ligntImageView: UIImageView?
    
    var model : HomeOnlineSignModel? {
        didSet {
            if (model?.addRedPacket)! > 0 {
                //红包
                YBPlayAudio.cashClick()
                titleImageView?.image = UIImage.init(named: "cash_reward_img_tl02")!
                RedPacketImageView?.image = UIImage.init(named: "reward_img01")!
                sumLabel?.text = "+\(model?.addRedPacket ?? 0)元"
            } else {
                //金币
                YBPlayAudio.coinClick()
                titleImageView?.image = UIImage.init(named: "cash_reward_img_tl")!
                RedPacketImageView?.image = UIImage.init(named: "task_reward_img02")!
                sumLabel?.text = "+\(model?.addGoldCoin ?? 0)"
            }
        }
    }
    
    override init(frame: CGRect)  {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        let titleImage = UIImage.init(named: "cash_reward_img_tl")!
        let titleImageView = UIImageView()
        titleImageView.image = titleImage
        addSubview(titleImageView)
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70.uiX+UIDevice.statusBarHeight)
            make.size.equalTo(titleImage.snpSize)
        }
        self.titleImageView = titleImageView
        
        let RedPacketImage = UIImage.init(named: "reward_img01")!
        let RedPacketImageView = UIImageView()
        RedPacketImageView.image = RedPacketImage
        addSubview(RedPacketImageView)
        RedPacketImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(160.uiX+UIDevice.statusBarHeight)
            make.size.equalTo(RedPacketImage.snpSize)
        }
        self.RedPacketImageView = RedPacketImageView
        
        let ligntImage = UIImage.init(named: "img_lignt_all")!
        let ligntImageView = UIImageView()
        ligntImageView.image = ligntImage
        insertSubview(ligntImageView, belowSubview: RedPacketImageView)
        ligntImageView.snp.makeConstraints { (make) in
            make.center.equalTo(RedPacketImageView)
            make.size.equalTo(ligntImage.snpSize)
        }
        self.ligntImageView = ligntImageView
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        ligntImageView.layer.removeAllAnimations()
        ligntImageView.layer.add(ro, forKey: "rotationAnimation")
        
        let sumLabel = UILabel.init()
        sumLabel.font = UIFont.init(style: .regular, size: 22.uiX)
        sumLabel.textColor = .init(hex: "#F6D938")
        sumLabel.textAlignment = .center
        sumLabel.text = "+0.5元"
        addSubview(sumLabel)
        sumLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(20.uiX)
            make.top.equalTo(RedPacketImageView.snp_bottomMargin).offset(15.uiX)
        }
        self.sumLabel = sumLabel
        
        let sureImage = UIImage.init(named: "reward_img_btn")
        let sureButton = MusicButton.init(frame: .zero)
//        sureButton.setImage(sureImage, for: .normal)
        addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) in
            make.top.equalTo(sumLabel.snp_bottomMargin).offset(32.uiX)
            make.size.equalTo(sureImage!.snpSize)
            make.centerX.equalToSuperview()
        }
        sureButton.startCountDown(time: 3) { (time, btn) in
            let attr: [NSAttributedString.Key : Any] = [
                .font: UIFont(style: .medium, size: 16.uiX),
                .foregroundColor: UIColor(hex: "#ffffff"),
                .strokeColor: UIColor(hex: "#582C06"),
                .strokeWidth: -6.uiX]
            btn.setAttributedTitle(.init(string: "\(time)s", attributes: attr), for: .normal)
            btn.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
            btn.titleLabel?.font = .init(style: .regular, size: 16.uiX)
            btn.setBackgroundImage(.create("reward_img_btn_empty"), for: .normal)
        } completion: { btn in
            btn.setBackgroundImage(sureImage, for: .normal)
            btn.setAttributedTitle(nil, for: .normal)
        }
        self.sureButton = sureButton
        
        sureButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.close ()
        }).disposed(by: rx.disposeBag)
        
        let bgImg = UIImage.create("hongbao_open_img_bgd")
        let adView = ListAdAnimationView(slotId: nil, w: bgImg.snpSize.width)
        adView.x = 0
        adView.y = 0
        
        let adBgView = UIView()
        addSubview(adBgView)
        adBgView.snp.makeConstraints { make in
            make.top.equalTo(sureButton.snp.bottom).offset(20.uiX)
            make.centerX.equalToSuperview()
            make.height.equalTo(adView.height)
            make.width.equalTo(adView.width)
        }
        
        adBgView.addSubview(adView)
        
    }
    
    @objc private func close () {
        if let sup = self.parentViewController as? PopView {
            sup.hide()
        }
    }
    
}
