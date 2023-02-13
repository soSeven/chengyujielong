//
//  LotteryRuleView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/24.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxCocoa
import RxSwift

class LotteryRuleView: UIView {
    
    var action: (()->())?
    
    init() {
        
        let bgImg = UIImage.create("cash_draw_rules_frame")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 0
        addSubview(bgImgView)
        
        let textLbl1 = UILabel()
        textLbl1.textColor = .init(hex: "#7A320D")
        textLbl1.font = .init(style: .medium, size: 13.uiX)
        textLbl1.textAlignment = .left
        textLbl1.width = width
        textLbl1.height = 55.uiX
        textLbl1.x = 37.uiX
        textLbl1.y = 55.uiX
        textLbl1.numberOfLines = 0
        textLbl1.text =
            """
            1、在您不断闯关的过程中每当通过一些
            特殊关卡时(20、60、80...)，将获得一次
            抽奖机会；
            """
        addSubview(textLbl1)
        
        let textLbl2 = UILabel()
        textLbl2.textColor = .init(hex: "#7A320D")
        textLbl2.font = .init(style: .medium, size: 13.uiX)
        textLbl2.textAlignment = .left
        textLbl2.width = width
        textLbl2.height = 110.uiX
        textLbl2.y = textLbl1.frame.maxY + 8.uiX
        textLbl2.x = 37.uiX
        textLbl2.numberOfLines = 0
        textLbl2.text =
            """
            2、每次抽奖结果可获得提现奖励、现金
            奖励和金币奖励中的任意一种；如果抽中
            提现奖励，需要您在提现有效期内进行提
            现；如果抽中金币的现金奖励，则会直接
            放入您的账户，可通过常规提现到您的微
            信钱包；
            """
        addSubview(textLbl2)
        
        let textLbl = UILabel()
        textLbl.textColor = .init(hex: "#7A320D")
        textLbl.font = .init(style: .medium, size: 13.uiX)
        textLbl.textAlignment = .left
        textLbl.width = width
        textLbl.height = 40.uiX
        textLbl.y = textLbl2.frame.maxY + 8.uiX
        textLbl.x = 37.uiX
        textLbl.numberOfLines = 0
        textLbl.text =
            """
            3、如发现有作弊行为，我们有权取消您
            的中奖资格。
            """
        addSubview(textLbl)
        
        let btnImg = UIImage.create("shortage_img_btn")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = height - 30.uiX - btn.height
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let ac = self.action {
                ac()
            } else {
                if let sup = self.parentViewController as? PopView {
                    sup.hide()
                }
            }
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
}
