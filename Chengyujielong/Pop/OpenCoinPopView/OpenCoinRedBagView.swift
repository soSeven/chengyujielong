//
//  OpenCoinRedBagView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/28.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class OpenCoinRedBagView: UIView {
    
    let viewModel =  OpenCoinRedBagViewModel()
    
    init(action: @escaping ()->()) {
        
        let bgImg = UIImage.create("hongbao_img")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#FFECC5")
        titleLbl.font = .init(style: .medium, size: 20.uiX)
        titleLbl.text = "每3000金币开1个红包"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 20.uiX
        titleLbl.y = 118.uiX
        addSubview(titleLbl)
        
        let titleLbl2 = UILabel()
        titleLbl2.textColor = .init(hex: "#FED5A5")
        titleLbl2.font = .init(style: .regular, size: 17.uiX)
        titleLbl2.text = "我的金币：\(UserManager.shared.user?.goldCoin ?? 0)"
        titleLbl2.textAlignment = .center
        titleLbl2.width = width
        titleLbl2.height = 17.uiX
        titleLbl2.y = 64.uiX
        addSubview(titleLbl2)
        
        let closeImg = UIImage.create("hongbao_img_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeImg, for: .normal)
        closeBtn.size = closeImg.snpSize
        closeBtn.y = 12.uiX
        closeBtn.x = width - closeBtn.width - 12.5.uiX
        addSubview(closeBtn)
        
        var showAd = false
        let dayKey = "open_redbag_dayKey"
        let dayStr = Date().string(withFormat: "dd/MM/yyyy")
        if let v = UserDefaults.standard.string(forKey: dayKey), v == dayStr {
            showAd = true
        }
        
        let pub = PublishRelay<Void>()
        let btnImg = UIImage.create("hongbao_img_open")
        let btn = UIButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 218.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: { _ in
            
            MobClick.event("split_open")
            
            if let u = UserManager.shared.user, u.goldCoin < 3000 {
                PopView.show(view: OpenCoinAlertView())
                return
            }
            if let sup = self.parentViewController {
//                if showAd {
//
//                    MobClick.event("split_mandatory")
//
//                    let ad = RewardVideoSingleAd.shared
//                    ad.showAd(vc: sup)
//                    ad.completion = {
//                        pub.accept(())
//                    }
//                    ad.failure = {
//                        pub.accept(())
//                    }
//                } else {
                    UserDefaults.standard.setValue(dayStr, forKey: dayKey)
                    pub.accept(())
//                }
            }
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        if showAd {
            let titleLbl3 = UILabel()
            titleLbl3.textColor = .init(hex: "#FED5A5")
            titleLbl3.font = .init(style: .medium, size: 14.uiX)
            titleLbl3.text = "看视频领取"
            titleLbl3.textAlignment = .center
            titleLbl3.width = width
            titleLbl3.height = 14.uiX
            titleLbl3.y = 10.uiX + btn.frame.maxY
            addSubview(titleLbl3)
        }
        
        let ro = CABasicAnimation(keyPath: "transform.scale")
        ro.fromValue = 0.9
        ro.toValue = 1
        ro.duration = 0.5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.autoreverses = true
        ro.fillMode = .forwards
        btn.layer.add(ro, forKey: "rotationAnimation")
        
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        let input = OpenCoinRedBagViewModel.Input(request: pub.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: { s in
            if let s = s, let u = UserManager.shared.login.value.0 {
                u.redPacket = s.redPacket
                u.goldCoin = s.goldCoin
                UserManager.shared.login.accept((u, .change))
                let cash = OpecCoinCashView(num: s.addRedPacket)
                cash.btn.rx.tap.subscribe(onNext: { _ in
                    action()
                }).disposed(by: cash.rx.disposeBag)
                PopView.show(view: cash)
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
