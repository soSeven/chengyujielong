//
//  LotteryCashView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import RxCocoa
import RxSwift

class LotteryCashView: UIView {
    
    var action: (()->())?
    
    init(cash: String) {
        
        YBPlayAudio.cashClick()
        
        let frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 380.uiX)
        super.init(frame: frame)
        
        let closeImg = UIImage.create("task_img_close")
        let closeBtn = MusicButton()
        closeBtn.size = closeImg.snpSize
        closeBtn.x = width - 65.uiX - closeBtn.width
        closeBtn.y = 0.uiX
        closeBtn.setImage(closeImg, for: .normal)
        addSubview(closeBtn)
        
        let titleImg = UIImage.create("cash_reward_img_tl02")
        let titleImgView = UIImageView(image: titleImg)
        titleImgView.size = titleImg.snpSize
        titleImgView.y = closeBtn.frame.maxY + 14.uiX
        titleImgView.x = (width - titleImgView.width)/2.0
        addSubview(titleImgView)
        
        let redHeartImg = UIImage.create("task_reward_img01")
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
        textLbl.attributedText = getCurrentAttributedText(n: cash)
        addSubview(textLbl)
        
        let lbl1 = UILabel()
        lbl1.textColor = .init(hex: "#E1DAE6")
        lbl1.font = .init(style: .regular, size: 14.uiX)
        lbl1.y = 25.uiX + textLbl.frame.maxY
        lbl1.x = 0
        lbl1.height = 14.uiX
        lbl1.width = width
        lbl1.attributedText = getAttributedText(n: UserManager.shared.user?.difRelay.value.2 ?? 0)
        lbl1.textAlignment = .center
        addSubview(lbl1)
        
        let btnImg = UIImage.create("cash_reward_img_btn02")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 15.uiX + lbl1.frame.maxY
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            self.action?()
        }).disposed(by: rx.disposeBag)
        
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            self.action?()
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
    private func getCurrentAttributedText(n: String) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .medium, size: 22.uiX),
            .foregroundColor: UIColor(hex: "#F5D937")
        ]
        
        let a1 = NSMutableAttributedString(string: "+\(n)元", attributes: att1)
        return a1
    }
    
    private func getAttributedText(n: Int) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#FFDDAF")
        ]
        let att2: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#F5D937")
        ]
        
        let a1 = NSMutableAttributedString(string: "距离下次提现机会还差", attributes: att1)
        let a2 = NSAttributedString(string: "\(n)", attributes: att2)
        let a3 = NSAttributedString(string: "关", attributes: att1)
        a1.append(a2)
        a1.append(a3)
        return a1
    }
    
}
