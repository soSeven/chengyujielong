//
//  TodayTaskCoinView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/29.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxCocoa
import RxSwift

class TodayTaskCoinView: UIView {
    
    private let viewModel = TodayTaskPopViewModel()
    
    init(model: TodayTaskCellViewModel) {
        
        YBPlayAudio.coinClick()
        
        let frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 540.uiX)
        super.init(frame: frame)

        let titleImg = UIImage.create("task_reward_img_title")
        let titleImgView = UIImageView(image: titleImg)
        titleImgView.size = titleImg.snpSize
        titleImgView.y = 0
        titleImgView.x = (width - titleImgView.width)/2.0
        addSubview(titleImgView)
        
        let redHeartImg = UIImage.create("task_reward_img02")
        let redHeartView = UIImageView(image: redHeartImg)
        redHeartView.size = redHeartImg.snpSize
        redHeartView.y = titleImgView.frame.maxY + 45.uiX
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
        textLbl.attributedText = getCurrentAttributedText(n: model.goldCoin ?? 0)
        addSubview(textLbl)
        
        let btnImg = UIImage.create("task_reward_img_btn")
        let btn = MusicButton()
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
        
        let relay = PublishRelay<Int>()
        
        btn.rx.tap.subscribe(onNext: { _ in
            relay.accept(model.id)
        }).disposed(by: rx.disposeBag)
        
        let bgImg = UIImage.create("hongbao_open_img_bgd")
        let adView = ListAdAnimationView(slotId: nil, w: bgImg.snpSize.width)
        adView.x = (width - bgImg.snpSize.width)/2.0
        adView.y = btn.frame.maxY + 20.uiX
        addSubview(adView)
        
        let input = TodayTaskPopViewModel.Input(request: relay.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
            guard let m = m else { return }
            if let u = UserManager.shared.user {
                u.goldCoin = m.goldCoinLatest
                u.redPacket = m.redPacketLatest
                u.taskStatus.accept(m.taskStatus)
                UserManager.shared.login.accept((u, .change))
            }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        output.failure.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            Observable.just(()).delay(.milliseconds(1500), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
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
    
    private func getCurrentAttributedText(n: Int) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 22.uiX),
            .foregroundColor: UIColor(hex: "#F5D937")
        ]
        
        let a1 = NSMutableAttributedString(string: "+\(n)", attributes: att1)
        return a1
    }
    
}
