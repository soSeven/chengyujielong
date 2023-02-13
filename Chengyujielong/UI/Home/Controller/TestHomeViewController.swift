//
//  TestHomeViewController.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/25.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol TestHomeViewControllerDelegate: AnyObject {
    
    func homeDidGetCash(controller: TestHomeViewController)
    func homeDidOpenRedBag(controller: TestHomeViewController)
    func homeDidSign(controller: TestHomeViewController)
    func homeDidLottery(controller: TestHomeViewController)
    func homeDidHowPlay(controller: TestHomeViewController)
  
}

class TestHomeViewController: ViewController {
    
    weak var delegate: TestHomeViewControllerDelegate?
    
    private let contentView = UIView()
    private let playBgView = UIView()
    
    private let topView = HomeTopView()
    private let bottomView = HomeBottomView()
    private let levellbl = UILabel()
    private let levelTitlelbl = UILabel()
    private let totalLevelLbl = UILabel()
    private let redBagBtn = MusicButton()
    private let lightImgView = UIImageView()
    private let markShowImgView = UIImageView()
    private let progressView = UIView()
    private let progressBgView = UIView()
    
    private var playAnswerView: PlayAnswerView?
    private var playView: PlayView?
    
    private var maxHeight: CGFloat = 0
    private var maxWidth: CGFloat = 0
    
    private var currentLevel = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        self.currentLevel = UserManager.shared.user?.currentLevel.value ?? 1
        setupUI()
        setupBinding()
        
        if let u = UserManager.shared.user, u.isNew ?? false {
            PopView.show(view: HomeNewUserView())
        }
        
       _ = OnlineTimeManager.shared
        
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let bgImg = UIImage.create("home_img_bgd")
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.clipsToBounds = true
        view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.cashBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            MobClick.event("idiom_topCash")
            self.delegate?.homeDidGetCash(controller: self)
        }).disposed(by: rx.disposeBag)
        topView.coinBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            MobClick.event("idiom_splitPackage")
            self.delegate?.homeDidOpenRedBag(controller: self)
        }).disposed(by: rx.disposeBag)
        topView.avatarBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            MobClick.event("idiom_portrait")
            let setting = HomeSettingView()
            setting.cashAction = { [weak self] in
                guard let self = self else { return }
                self.delegate?.homeDidGetCash(controller: self)
            }
            PopView.show(view: setting, needNav: true)
        }).disposed(by: rx.disposeBag)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(52.uiX)
        }
        
        bottomView.retry.btn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            guard let u = UserManager.shared.user else { return }
            MobClick.event("idiom_replay")
            if u.retryRelay.value > 0 {
                self.addPlayView()
                u.retryRelay.accept(u.retryRelay.value - 1)
            } else {
//                let ad = RewardVideoSingleAd.shared
//                ad.showAd(vc: self)
//                ad.completion = {
                    u.retryRelay.accept(2)
//                }
            }
        }).disposed(by: rx.disposeBag)
        
        bottomView.tip.btn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            guard let u = UserManager.shared.user else { return }
            MobClick.event("idiom_prompt")
            if u.tipRelay.value > 0 {
                self.showTip()
                u.tipRelay.accept(u.tipRelay.value - 1)
            } else {
//                let ad = RewardVideoSingleAd.shared
//                ad.showAd(vc: self)
//                ad.completion = {
                    u.tipRelay.accept(3)
//                }
            }
        }).disposed(by: rx.disposeBag)
        
        bottomView.how.btn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            MobClick.event("idiom_play")
            self.delegate?.homeDidHowPlay(controller: self)
        }).disposed(by: rx.disposeBag)
        
        bottomView.task.btn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            MobClick.event("idiom_task")
            let task = AllTaskView()
            task.goToCash = { [weak self] in
                guard let self = self else { return }
                self.delegate?.homeDidGetCash(controller: self)
            }
            PopView.show(view: task)
        }).disposed(by: rx.disposeBag)
        
        bottomView.sign.btn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            MobClick.event("idiom_sign")
            self.delegate?.homeDidSign(controller: self)
        }).disposed(by: rx.disposeBag)
        
        bottomView.lottery.btn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            MobClick.event("idiom_luckyDraw")
            self.delegate?.homeDidLottery(controller: self)
        }).disposed(by: rx.disposeBag)
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(70.uiX)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top)
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        let playBgImg = UIImage.create("home_img_frame01")
        let playBgImgView = UIImageView(image: playBgImg)
        contentView.addSubview(playBgImgView)
        playBgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15.uiX, left: 3.uiX, bottom: 0, right: 3.uiX))
        }
        
        let levelImg = UIImage.create("home_img_title")
        let levelImgView = UIImageView(image: levelImg)
        contentView.addSubview(levelImgView)
        levelImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(levelImg.snpSize)
        }
        
        levellbl.textColor = .init(hex: "#7A310C")
        levellbl.font = UIFont.init(name: "HYa9gj", size: 14.uiX)
        levelImgView.addSubview(levellbl)
        levellbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-3.uiX)
        }
        
        let rewardImg = UIImage.create("home_img_frame02")
        let rewardImgView = UIImageView(image: rewardImg)
        rewardImgView.isUserInteractionEnabled = true
        contentView.addSubview(rewardImgView)
        rewardImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelImgView.snp.bottom).offset(8.uiX)
            make.size.equalTo(rewardImg.snpSize)
        }
        
        rewardImgView.addSubview(levelTitlelbl)
        levelTitlelbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25.uiX)
            make.top.equalToSuperview().offset(10.uiX)
        }
        levelTitlelbl.attributedText = getLevelTitleAttStr(num: 20)
        
        progressBgView.borderColor = .init(hex: "#DA862D")
        progressBgView.backgroundColor = .init(hex: "#F4E5BE")
        progressBgView.borderWidth = 1.uiX
        rewardImgView.addSubview(progressBgView)
        progressBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25.uiX)
            make.top.equalToSuperview().offset(32.uiX)
            make.height.equalTo(9.uiX)
            make.width.equalTo(189.uiX)
        }
        
        progressView.clipsToBounds = true
        let titleGradientLayer = [UIColor(hex: "#FDDF14"), UIColor(hex: "#E57C00")].gradient()
        titleGradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        titleGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        titleGradientLayer.frame = .init(x: 1.uiX, y: 1.uiX, width: 187.uiX, height: 7.uiX)
        progressView.layer.addSublayer(titleGradientLayer)
        progressBgView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.bottom.top.equalTo(progressBgView)
            make.width.equalTo(progressBgView).multipliedBy(0)
        }
        
        let redBagImg = UIImage.create("home_img_package")
        redBagBtn.setImage(redBagImg, for: .normal)
        rewardImgView.addSubview(redBagBtn)
        redBagBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5.uiX)
            make.left.equalTo(progressBgView.snp.right).offset(22.uiX)
            make.size.equalTo(redBagImg.snpSize)
        }
        
        let markShowImg = UIImage.create("home_img_label")
        markShowImgView.image = markShowImg
        rewardImgView.addSubview(markShowImgView)
        markShowImgView.snp.makeConstraints { make in
            make.bottom.equalTo(redBagBtn.snp.top)
            make.centerX.equalTo(redBagBtn)
            make.size.equalTo(markShowImg.snpSize)
        }
        
        let lightImg = UIImage.create("home_img_light01")
        lightImgView.image = lightImg
        rewardImgView.insertSubview(lightImgView, at: 0)
        lightImgView.snp.makeConstraints { make in
            make.center.equalTo(redBagBtn)
            make.size.equalTo(lightImg.snpSize)
        }
        
        rewardImgView.addSubview(totalLevelLbl)
        totalLevelLbl.snp.makeConstraints { make in
            make.top.equalTo(redBagBtn.snp.bottom)
            make.centerX.equalTo(redBagBtn)
        }
        totalLevelLbl.attributedText = getTotalLevelTitleAttStr(num: 20, total: 20)
        
        maxHeight = UIDevice.screenHeight - UIDevice.safeAreaBottom - UIDevice.statusBarHeight - 52.uiX - 70.uiX - 115.uiX - 27.uiX
        maxWidth = UIDevice.screenWidth - 39.uiX * 2
        
        playBgView.height = maxHeight
        playBgView.width = maxWidth
        playBgView.x = 39.uiX
        playBgView.y = 115.uiX
        contentView.addSubview(playBgView)
        
        addPlayView()
        
        if UserManager.shared.isCheck {
            topView.cashBgView.isHidden = true
            topView.coinBgView.isHidden = true
            topView.coinImgView.isHidden = true
            topView.levelBgImgView.isHidden = true
            rewardImgView.isHidden = true
            bottomView.task.isHidden = true
            bottomView.sign.isHidden = true
            
        }
    }
    
    private func getLevelTitleAttStr(num: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#7A310C")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#E53A1E")
        ]
        if num == 0 {
            return NSAttributedString(string: "获得一次抽奖机会", attributes: a1)
        } else {
            let s = NSMutableAttributedString(string: "距离下次提现还差", attributes: a1)
            let s2 = NSAttributedString(string: "\(num)", attributes: a2)
            let s3 = NSAttributedString(string: "关", attributes: a1)
            s.append(s2)
            s.append(s3)
            return s
        }
        
    }
    
    private func getTotalLevelTitleAttStr(num: Int, total: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 10.uiX),
            .foregroundColor: UIColor(hex: "#E71A00")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 10.uiX),
            .foregroundColor: UIColor(hex: "#7A310C")
        ]
        let s = NSMutableAttributedString(string: "\(num)", attributes: a1)
        let s2 = NSAttributedString(string: "/\(total)", attributes: a2)
        s.append(s2)
        return s
    }
    
    private func addPlayView() {
        
        UserManager.shared.user?.currentLevel.accept(self.currentLevel)
        
        playBgView.removeSubviews()
        
        levellbl.text = "第\(currentLevel)关"
        
        //99
        //10 15
        let playModel = PlayModel(level: self.currentLevel)
        playModel.maxWidth = maxWidth
        playModel.maxHeight = maxHeight
        playModel.setupScale()
        
        let playAnswerView = PlayAnswerView(playModel: playModel)
        
        playModel.maxHeight = maxHeight - playAnswerView.height - 5.uiX
        let playView = PlayView(playModel: playModel)
        
        playBgView.addSubview(playView)
        playBgView.addSubview(playAnswerView)

        playAnswerView.didClickItem = { model in
            playView.accept(answer: model)
        }
        
        playView.pushAction = { model in
            playAnswerView.accept(model: model)
        }
        
        playView.successAction = { [weak self] in
            guard let self = self else { return }
//            if UserManager.shared.isCheck {
                self.currentLevel += 1
                self.addPlayView()
//                return
//            }
            
//            let successBlock = { [weak self] in
//                guard let self = self else { return }
//                let successView = PlaySuccessCashView(level: self.currentLevel)
//                successView.failure = { [weak self] in
//                    guard let self = self else { return }
//                    self.addPlayView()
//                }
//                successView.success = { [weak self] in
//                    guard let self = self else { return }
//                    self.currentLevel += 1
//                    self.addPlayView()
//                }
//                PopView.show(view: successView)
//            }
//
//            let adStartLevel = UserManager.shared.configure?.constField.videoAfterCheckpoint ?? 0
//            let adMargin = UserManager.shared.configure?.constField.videoPerCheckpoint ?? 0
//            let needAD = [3, 6, 9]
//            var isNeedAd = false
//            if needAD.contains(self.currentLevel) {
//                isNeedAd = true
//            }
//            if self.currentLevel == adStartLevel {
//                isNeedAd = true
//            }
//            let dif = self.currentLevel - adStartLevel
//            if dif > 0, dif % adMargin == 0 {
//                isNeedAd = true
//            }
            
//            if isNeedAd {
////                let ad = RewardVideoSingleAd.shared
////                ad.showAd(vc: self)
////                ad.completion = {
//                    let successView = PlayDoubleCashView(level: self.currentLevel)
//                    successView.failure = { [weak self] in
//                        guard let self = self else { return }
//                        self.addPlayView()
//                    }
//                    successView.success = { [weak self] in
//                        guard let self = self else { return }
//                        self.currentLevel += 1
//                        self.addPlayView()
//                    }
//                    PopView.show(view: successView)
//                }
//                ad.failure = successBlock
//            } else {
//                successBlock()
//            }
        }
        
        self.playView = playView
        self.playAnswerView = playAnswerView
    }
    
    private func showTip() {
        
        guard let playView = self.playView else { return }
        guard let playAnswerView = self.playAnswerView else { return }
        
        playView.clearWrongs()
        if let rightText = playView.getCurrentRightText() {
            if let vm = playAnswerView.item(with: rightText) {
                playView.accept(answer: vm)
            }
        }
        
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        var userDisposeBag = DisposeBag()
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let u = u else { return }
            
            userDisposeBag = DisposeBag()
            
            self.topView.imgView.kf.setImage(with: URL(string: u.avatar))
            self.topView.cashLbl.text = "\(u.redPacket ?? "0")元"
            let goldCoin = u.goldCoin ?? 0
            self.topView.coinLbl.text = "\(goldCoin)"
            self.topView.titleLbl.text = u.titleName ?? "暂无头衔"
            
            var clickDisposeBag = DisposeBag()
            u.difRelay.subscribe(onNext: {[weak self] (total, current, dif, progress, show) in
                guard let self = self else { return }
                
                clickDisposeBag = DisposeBag()
                
                self.levelTitlelbl.attributedText = self.getLevelTitleAttStr(num: dif)
                self.totalLevelLbl.attributedText = self.getTotalLevelTitleAttStr(num: current, total: total)
                self.progressView.snp.remakeConstraints { make in
                    make.left.bottom.top.equalTo(self.progressBgView)
                    make.width.equalTo(self.progressBgView).multipliedBy(progress)
                }
                self.lightImgView.layer.removeAllAnimations()
                self.markShowImgView.layer.removeAllAnimations()
                if show {
                    self.lightImgView.isHidden = false
                    self.markShowImgView.isHidden = false
                    let ro = CABasicAnimation(keyPath: "transform.rotation.z")
                    ro.toValue = Double.pi*2.0
                    ro.duration = 5
                    ro.repeatCount = HUGE
                    ro.isRemovedOnCompletion = false
                    ro.fillMode = .forwards
                    self.lightImgView.layer.add(ro, forKey: "rotationAnimation")
                    
                    let roScale = CABasicAnimation(keyPath: "transform.scale")
                    roScale.fromValue = 0.9
                    roScale.toValue = 1
                    roScale.duration = 0.5
                    roScale.repeatCount = HUGE
                    roScale.isRemovedOnCompletion = false
                    roScale.autoreverses = true
                    roScale.fillMode = .forwards
                    self.markShowImgView.layer.add(roScale, forKey: "rotationAnimation")
                    
                    self.redBagBtn.rx.tap.subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        MobClick.event("idiom_withdrawal")
                        self.delegate?.homeDidGetCash(controller: self)
                    }).disposed(by: clickDisposeBag)
                } else {
                    self.lightImgView.isHidden = true
                    self.markShowImgView.isHidden = true
                    self.redBagBtn.rx.tap.subscribe(onNext: {
                        Observable.just("距离下次提现还差\(dif)关").bind(to: self.view.rx.toastText()).disposed(by: self.rx.disposeBag)
                    }).disposed(by: clickDisposeBag)
                }
                
                u.retryRelay.subscribe(onNext: {[weak self] n in
                    guard let self = self else { return }
                    self.bottomView.retry.setupNumber(n)
                }).disposed(by: userDisposeBag)
                
                u.tipRelay.subscribe(onNext: {[weak self] n in
                    guard let self = self else { return }
                    self.bottomView.tip.setupNumber(n)
                }).disposed(by: userDisposeBag)
                
                u.taskStatus.subscribe(onNext: { [weak self] isShow in
                    guard let self = self else { return }
                    self.bottomView.task.light.isHidden = !isShow
                    self.bottomView.task.dot.isHidden = !isShow
                }).disposed(by: userDisposeBag)
                
                u.signDotRelay.subscribe(onNext: {[weak self] s in
                    guard let self = self else { return }
                    self.bottomView.sign.dot.isHidden = !s
                }).disposed(by: userDisposeBag)
                
            }).disposed(by: userDisposeBag)
            
        }).disposed(by: rx.disposeBag)
        
    }
}
