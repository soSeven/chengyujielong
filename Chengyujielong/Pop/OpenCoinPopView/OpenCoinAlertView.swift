//
//  OpenCoinAlertView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/28.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class OpenCoinAlertView: UIView {
    
    init() {
        
        let bgImg = UIImage.create("shortage_img_frame")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let titleLbl = UILabel()
        titleLbl.textColor = .init(hex: "#7A320D")
        titleLbl.font = .init(style: .medium, size: 14.uiX)
        titleLbl.text = "您的金币不足3000个，还不能\n拆红包哦~"
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .center
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75.uiX)
            make.left.right.equalToSuperview()
        }
        
        let btnImg = UIImage.create("shortage_img_btn")
        let btn = MusicButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 131.uiX
        btn.x = (width - btn.width)/2.0
        addSubview(btn)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            MobClick.event("split_insufficient")
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
