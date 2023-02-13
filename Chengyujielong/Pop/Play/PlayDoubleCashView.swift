//
//  PlayDoubleCashView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/12.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxCocoa
import RxSwift

class PlayDoubleCashView: UIView {
    
    private let viewModel = PlaySuccessViewModel()
    
    var success: (()->())?
    var failure: (()->())?
    
    init(level: Int) {
        
        YBPlayAudio.cashClick()
        
        let frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 520.uiX)
        super.init(frame: frame)
        
        let rewardModel = UserManager.shared.configure?.checkpointReward.first(where: { $0.minCheckpoint <= level && $0.maxCheckpoint >= level })
        var doubleReward: String = "0"
        if let r = rewardModel {
            doubleReward = String(format: "%.2f", Float.random(in: r.videoMin...r.videoMax) * 2)
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
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFDEB0")
        titleLbl.font = .init(style: .regular, size: 13.uiX)
        titleLbl.textAlignment = .center
        titleLbl.text = "获得双倍奖励"
        titleLbl.width = width
        titleLbl.height = 13.uiX
        titleLbl.y = redHeartView.frame.maxY + 30.uiX
        addSubview(titleLbl)
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#FFE03A")
        textLbl.font = .init(style: .medium, size: 21.uiX)
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 20.uiX
        textLbl.y = titleLbl.frame.maxY + 19.uiX
        textLbl.attributedText = getCurrentAttributedText(n: doubleReward)
        addSubview(textLbl)
        
        let btnImg = UIImage.create("reward_img_btn")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 22.5.uiX + textLbl.frame.maxY
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        
        btn.startCountDown(time: 3) { (time, btn) in
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
            btn.setBackgroundImage(btnImg, for: .normal)
            btn.setAttributedTitle(nil, for: .normal)
        }
        
        let relay = PublishRelay<(Int, Int, String)>()
        
        btn.rx.tap.subscribe(onNext: { _ in
            relay.accept((level, 1, doubleReward))
        }).disposed(by: rx.disposeBag)
        
        let bgImg = UIImage.create("hongbao_open_img_bgd")
        let adView = ListAdAnimationView(slotId: nil, w: bgImg.snpSize.width)
        adView.x = (width - bgImg.snpSize.width)/2.0
        adView.y = btn.frame.maxY + 20.uiX
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
