//
//  LotteryGetCashView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/18.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation

class LotteryGetCashView: UIView {
    
    var laterAction: (()->())?
    var action: (()->())?
    
    init(cash: String) {
        
        YBPlayAudio.cashClick()
        
        let bgImg = UIImage.create("cash_reward_img_frame")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 40.uiX)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 40.uiX
        bgImgView.isUserInteractionEnabled = true
        addSubview(bgImgView)
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#79310C")
        textLbl.font = .init(style: .medium, size: 17.uiX)
        textLbl.textAlignment = .center
        textLbl.width = width
        textLbl.height = 18.uiX
        textLbl.y = 72.5.uiX
        textLbl.text = "获得一次提现机会"
        bgImgView.addSubview(textLbl)
        
        let lbl1 = UILabel()
        lbl1.textColor = .init(hex: "#E1DAE6")
        lbl1.font = .init(style: .regular, size: 14.uiX)
        lbl1.y = 17.uiX + textLbl.frame.maxY
        lbl1.x = 0
        lbl1.height = 14.uiX
        lbl1.width = width
        lbl1.attributedText = getAttributedText(n: cash)
        lbl1.textAlignment = .center
        bgImgView.addSubview(lbl1)
        
        let closeBtnImg = UIImage.create("task_img_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeBtnImg, for: .normal)
        closeBtn.size = closeBtnImg.snpSize
        closeBtn.y = 0
        closeBtn.x = width - closeBtn.width - 15.uiX
        addSubview(closeBtn)
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            self.laterAction?()
        }).disposed(by: rx.disposeBag)
        
        let btnImg = UIImage.create("cash_reward_img_btn")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 155.5.uiX
        btn.x = (width - btn.width)/2.0
        bgImgView.addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            MobClick.event("withdrawal_immediately")
            self.action?()
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
    private func getAttributedText(n: String) -> NSAttributedString {
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#815533")
        ]
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#E5391E")
        ]
        
        let a1 = NSMutableAttributedString(string: "可提现：", attributes: att1)
        let a2 = NSAttributedString(string: n, attributes: att2)
        let a3 = NSAttributedString(string: "元", attributes: att1)
        a1.append(a2)
        a1.append(a3)
        return a1
    }
    
}
