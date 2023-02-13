//
//  PlaySuccessCashView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/12.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxCocoa
import RxSwift

class PlaySuccessCashView: UIView {
    
    private let viewModel = PlaySuccessViewModel()
    
    var success: (()->())?
    var failure: (()->())?
    
    init(level: Int) {
        
        YBPlayAudio.cashClick()
        
        let frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 520.uiX)
        super.init(frame: frame)
        
        let rewardModel = UserManager.shared.configure?.checkpointReward.first(where: { $0.minCheckpoint <= level && $0.maxCheckpoint >= level })
        var singleReward: String = "0"
        if let r = rewardModel {
            singleReward = String(format: "%.2f", Float.random(in: r.min...r.max))
        }
        
        let redHeartImg = UIImage.create("task_reward_img01")
        let redHeartView = UIImageView(image: redHeartImg)
        redHeartView.size = redHeartImg.snpSize
        redHeartView.y = 0
        redHeartView.x = (width - redHeartView.width)/2.0
        
        let lightImg = UIImage.create("img_lignt_all")
        let lightView = UIImageView(image: lightImg)
        lightView.size = lightImg.snpSize
        lightView.center = redHeartView.center
        
        addSubview(lightView)
        addSubview(redHeartView)
        
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        lightView.layer.add(ro, forKey: "rotationAnimation")
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#FFE03A")
        textLbl.font = .init(style: .medium, size: 21.uiX)
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 20.uiX
        textLbl.y = redHeartView.frame.maxY + 32.uiX
        textLbl.attributedText = getCurrentAttributedText(n: singleReward)
        addSubview(textLbl)
        
        let btnImg = UIImage.create("reward_img_btn_double")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 22.5.uiX + textLbl.frame.maxY
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        
        let nextImg = UIImage.create("home_next_img_txt")
        let nextBtn = MusicButton()
        nextBtn.size = nextImg.snpSize
        nextBtn.y = 15.uiX + btn.frame.maxY
        nextBtn.x = (width - nextBtn.width)/2.0
        addSubview(nextBtn)
        
        let relay = PublishRelay<(Int, Int, String)>()
        
        nextBtn.rx.tap.subscribe(onNext: { _ in
            MobClick.event("pass_ordinary")
            relay.accept((level, 0, singleReward))
        }).disposed(by: rx.disposeBag)
        
        nextBtn.startCountDown(time: 3) { (time, btn) in
            btn.setTitle("\(time)s", for: .normal)
            btn.setTitleColor(.init(hex: "#FFDEB0"), for: .normal)
            btn.titleLabel?.font = .init(style: .regular, size: 12.uiX)
        } completion: { btn in
            btn.setBackgroundImage(nextImg, for: .normal)
            btn.setTitle(nil, for: .normal)
        }

        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            MobClick.event("pass_envelope")
            if let sup = self.parentViewController as? PopView {
//                let ad = RewardVideoSingleAd.shared
//                ad.showAd(vc: sup)
//                ad.completion = {
                    let doubleView = PlayDoubleCashView(level: level)
                    doubleView.success = self.success
                    doubleView.failure = self.failure
                    PopView.show(view: doubleView)
//                }
            }
        }).disposed(by: rx.disposeBag)
        
        let bgImg = UIImage.create("hongbao_open_img_bgd")
        let adView = ListAdAnimationView(slotId: nil, w: bgImg.snpSize.width)
        adView.x = (width - bgImg.snpSize.width)/2.0
        adView.y = nextBtn.frame.maxY + 20.uiX
        addSubview(adView)
        
        let input = PlaySuccessViewModel.Input(request: relay.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
            guard let m = m else { return }
            if let u = UserManager.shared.user {
                u.redPacket = m.redPacket
                u.taskStatus.accept(m.taskStatus)
                UserManager.shared.login.accept((u, .change))
            }
            self.success?()
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        output.failure.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.isUserInteractionEnabled = false
            Observable.just(()).delay(.milliseconds(1500), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.failure?()
                if let sup = self.parentViewController as? PopView {
                    sup.hide()
                }
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getCurrentAttributedText(n: String) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 22.uiX),
            .foregroundColor: UIColor(hex: "#F5D937")
        ]
        
        let a1 = NSMutableAttributedString(string: "+\(n)元", attributes: att1)
        return a1
    }
    
}
