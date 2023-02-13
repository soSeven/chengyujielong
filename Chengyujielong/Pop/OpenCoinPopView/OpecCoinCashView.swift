//
//  OpecCoinCashView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/28.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxCocoa
import RxSwift

class OpecCoinCashView: UIView {
    
    let cashLbl = UILabel()
    let btn = MusicButton()
    let titleLbl1 = UILabel()
    
    init(num: String) {
        
        YBPlayAudio.coinClick()
        
        let bgImg = UIImage.create("hongbao_open_img_bgd")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 290.uiX)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.x = 0
        bgImgView.y = 30.uiX
        bgImgView.size = bgImg.snpSize
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#7A320D")
        titleLbl.font = .init(style: .medium, size: 19.uiX)
        titleLbl.text = "恭喜您获得红包"
        titleLbl.textAlignment = .center
        titleLbl.width = width
        titleLbl.height = 19.5.uiX
        titleLbl.y = 59.5.uiX
        addSubview(titleLbl)
        
        titleLbl1.textColor = .init(hex: "#984C25")
        titleLbl1.font = .init(style: .regular, size: 12.uiX)
        titleLbl1.text = "已存入余额，可提现"
        titleLbl1.textAlignment = .center
        titleLbl1.width = width
        titleLbl1.height = 12.uiX
        titleLbl1.y = titleLbl.frame.maxY + 8.5.uiX
        addSubview(titleLbl1)
        
        cashLbl.attributedText = getCashStr(num: num)
        cashLbl.textAlignment = .center
        cashLbl.width = width
        cashLbl.height = 35.uiX
        cashLbl.y = 15.uiX + titleLbl1.frame.maxY
        addSubview(cashLbl)
        
        let titleLbl2 = UILabel()
        titleLbl2.textColor = .init(hex: "#F25543")
        titleLbl2.font = .init(style: .regular, size: 11.5.uiX)
        let cash = UserManager.shared.user?.redPacket ?? "0"
        titleLbl2.text = "当前余额：\(cash)元"
        titleLbl2.textAlignment = .center
        titleLbl2.width = width
        titleLbl2.height = 11.5.uiX
        titleLbl2.y = 8.uiX + cashLbl.frame.maxY
        addSubview(titleLbl2)
        
//        let closeImg = UIImage.create("hongbao_open_img_circle")
//        let closeBtn = MusicButton()
//        closeBtn.setBackgroundImage(closeImg, for: .normal)
//        closeBtn.size = closeImg.snpSize
//        closeBtn.y = 0
//        closeBtn.x = (width - closeBtn.width)
//        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
//            guard let self = self else { return }
//            if let sup = self.parentViewController as? PopView {
//                sup.hide()
//            }
//        }).disposed(by: rx.disposeBag)
//        closeBtn.isUserInteractionEnabled = false
//        addSubview(closeBtn)
        
        let btnImg = UIImage.create("hongbao_open_img_btn")
        btn.size = btnImg.snpSize
        btn.y = 209.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        btn.isUserInteractionEnabled = false
        addSubview(btn)
        btn.startCountDown(time: 3) { (time, btn) in
            btn.setTitle("\(time)s", for: .normal)
            btn.setTitleColor(.init(hex: "#FFFFFF"), for: .normal)
            btn.titleLabel?.font = .init(style: .medium, size: 18.uiX)
        } completion: { btn in
            btn.setBackgroundImage(btnImg, for: .normal)
            btn.setTitle(nil, for: .normal)
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
        
        let adView = ListAdAnimationView(slotId: nil, w: width)
        adView.x = 0
        adView.y = bgImgView.frame.maxY + 20.uiX
        addSubview(adView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getCashStr(num: String) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#E53A1F")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 38.uiX)!,
            .foregroundColor: UIColor(hex: "#E53A1F")
        ]
        let s = NSMutableAttributedString(string: num, attributes: a2)
        let s2 = NSAttributedString(string: "元", attributes: a1)
        s.append(s2)
        return s
    }
    
}
