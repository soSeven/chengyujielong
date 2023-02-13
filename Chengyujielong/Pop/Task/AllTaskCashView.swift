//
//  AllTaskCashView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/29.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxCocoa
import RxSwift

class AllTaskCashView: UIView {
    
    private let viewModel = AllTaskPopViewModel()
    
    init(model: AllTaskCellViewModel) {
        
        YBPlayAudio.cashClick()
        
        let frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 380.uiX)
        super.init(frame: frame)
        
        let closeImg = UIImage.create("task_img_close")
        let closeBtn = MusicButton()
        closeBtn.setImage(closeImg, for: .normal)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.size.equalTo(closeImg.snpSize)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-68.uiX)
        }
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#F9D8A6")
        textLbl.font = .init(style: .medium, size: 15.uiX)
        textLbl.textAlignment = .center
        textLbl.text = "恭喜获得新头衔"
        addSubview(textLbl)
        textLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(closeBtn.snp.bottom).offset(18.uiX)
        }
        
        let titleImgView = UIImageView()
        titleImgView.kf.setImage(with: URL(string: model.textImage))
        titleImgView.contentMode = .scaleAspectFit
        addSubview(titleImgView)
        titleImgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(textLbl.snp.bottom).offset(16.uiX)
            make.height.equalTo(60.uiX)
        }
        
        let item1 = AllTaskCashViewItem(imgName: "task_level_reward_hongbao", text: "+\(model.money ?? 0)元")
        let item2 = AllTaskCashViewItem(imgName: "task_level_reward_coin", text: "+\(model.goldCoin ?? 0)")
        let s = UIStackView(arrangedSubviews: [item1, item2])
        s.axis = .vertical
        s.spacing = 16.5.uiX
        s.alignment = .center
        addSubview(s)
        s.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleImgView.snp.bottom).offset(25.uiX)
        }
        
        let lightImg = UIImage.create("img_lignt_all")
        let lightView = UIImageView(image: lightImg)
        lightView.size = lightImg.snpSize
        insertSubview(lightView, at: 0)
        lightView.snp.makeConstraints { make in
            make.center.equalTo(s)
            make.size.equalTo(lightImg.snpSize)
        }

        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        lightView.layer.add(ro, forKey: "rotationAnimation")

        let btnImg = UIImage.create("task_reward_level_img_btn")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.size.equalTo(btnImg.snpSize)
            make.top.equalTo(s.snp.bottom).offset(37.uiX)
            make.centerX.equalToSuperview()
        }
        
        let relay = PublishRelay<Int>()

        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
//            if let sup = self.parentViewController as? PopView {
//                let ad = RewardVideoSingleAd.shared
//                ad.showAd(vc: sup)
//                ad.completion = {
                    relay.accept(model.id)
//                }
//            }
        }).disposed(by: rx.disposeBag)
        
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        let input = AllTaskPopViewModel.Input(request: relay.asObservable())
        let output = viewModel.transform(input: input)
        output.success.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
            guard let m = m else { return }
            if let u = UserManager.shared.user {
                u.goldCoin = m.goldCoinLatest
                u.redPacket = m.redPacketLatest
                u.titleName = m.titleNameLatest
                u.taskStatus.accept(m.taskStatus)
                UserManager.shared.login.accept((u, .change))
            }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }, onError: { error in
            
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private class AllTaskCashViewItem: UIView {
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#F6D938")
        lbl.font = .init(style: .medium, size: 18.uiX)
        return lbl
    }()
    
    let imgView = UIImageView()
    
    init(imgName: String, text: String) {
        super.init(frame: .zero)
        
        let img = UIImage.create(imgName)
        imgView.image = img
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.size.equalTo(img.snpSize)
        }
        
        textLbl.text = text
        addSubview(textLbl)
        textLbl.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(4.uiX)
            make.centerY.right.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
