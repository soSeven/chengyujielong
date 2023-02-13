//
//  HomeNewUserView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/14.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeNewUserView: UIView {
    
    var action: (()->())?
    
    init() {
        
        let bgImg = UIImage.create("package_guide_img")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 0
        addSubview(bgImgView)
        
        let textLbl1 = UILabel()
        textLbl1.textColor = .init(hex: "#7A320D")
        textLbl1.font = .init(style: .medium, size: 34.uiX)
        textLbl1.text = "闯10关"
        addSubview(textLbl1)
        textLbl1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50.uiX)
        }
        
        let textLbl2 = UILabel()
        textLbl2.textColor = .init(hex: "#7A320D")
        textLbl2.font = .init(style: .medium, size: 23.uiX)
        textLbl2.text = "即可提现"
        addSubview(textLbl2)
        textLbl2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textLbl1.snp.bottom).offset(0.uiX)
        }
        
        let btnImg = UIImage.create("package_guide_img_btn")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-19.uiX)
            make.size.equalTo(btnImg.snpSize)
        }
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
            MobClick.event("Start_idiom")
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
}
