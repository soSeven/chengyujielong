//
//  HomeTitleLevelView.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/25.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import UIKit


class HomeTitleLevelView: UIView {
    
        init(action: @escaping ()->()) {
            
            let bgImg = UIImage.create("level_img_frame")
            let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height+26.uiX)
            super.init(frame: frame)
            let bgImgView = UIImageView(image: bgImg)
            bgImgView.size = bgImg.snpSize
            bgImgView.y = 26.uiX
            addSubview(bgImgView)
            
            let btnImg = UIImage.create("task_img_close")
            let btn = UIButton()
            btn.setBackgroundImage(btnImg, for: .normal)
            btn.rx.tap.subscribe(onNext: { _ in
                if let sup = self.parentViewController as? PopView {
                    sup.hide()
                }
                action()
            }).disposed(by: rx.disposeBag)
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.width.equalTo(btnImg.size.width.uiX)
                make.height.equalTo(btnImg.size.height.uiX)
                make.right.equalTo(bgImgView).offset(-5.uiX)
                make.bottom.equalTo(bgImgView.snp_topMargin).offset(3.uiX)
            }
            
            let margin = 16.uiX
            let starY = 96.uiX
            let bgImage = UIImage.init(named: "level_img_frame02")!
            var count = 0
            let imageName = ["1","2","3","4"]
            let desArray = ["获得“一品宰相”头衔","获得“四品知府”头衔","获得“七品知县”头衔","获得“九品主薄”头衔"]
            let hongbaoArray = ["30元","8元","6元","5元"]
            let coinArray = ["80000","40000","20000","10000"]
            for _ in 0..<4 {
                let view = TitleViewCellView.init(frame: .zero)
                view.y = starY + (margin+bgImage.snpSize.height)*CGFloat(count)
                view.x = 42.uiX
                view.titleImageView?.image = UIImage.init(named: "level_img0\(imageName[count])")
                view.desLabel?.text = desArray[count]
                view.hongbaoLabel?.text = hongbaoArray[count]
                view.coinLabel?.text = coinArray[count]
                bgImgView.addSubview(view)
                count += 1
            }
            
            
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}

class TitleViewCellView: UIView {
    
    var titleImageView :UIImageView?
    var desLabel :UILabel?
    var hongbaoLabel :UILabel?
    var coinLabel :UILabel?
    
    override init(frame: CGRect)  {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        
        let bgImage = UIImage.init(named: "level_img_frame02")!
        let bgImageView = UIImageView()
        bgImageView.image = bgImage
        self.addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(bgImage.size.width.uiX)
            make.height.equalTo(bgImage.size.height.uiX)
        }
        
        self.size = bgImage.size

        let titleImage = UIImage.init(named: "level_img01")!
        let titleImageView = UIImageView()
        titleImageView.image = titleImage
        self.addSubview(titleImageView)
        titleImageView.isUserInteractionEnabled = true
        titleImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18.uiX)
            make.width.equalTo(titleImage.size.width.uiX)
            make.height.equalTo(titleImage.size.height.uiX)
        }
        self.titleImageView = titleImageView

        let desLabel = UILabel()
        desLabel.textAlignment = .left
        desLabel.textColor = .init(hex: "#7A320D")
        desLabel.font = UIFont.init(style: .medium, size: 14)
        desLabel.text = "获得“一品宰相”头衔"
        self.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(95.uiX)
            make.top.equalToSuperview().offset(20.uiX)
            make.width.equalTo(140.uiX)
            make.height.equalTo(14.uiX)
        }
        self.desLabel = desLabel
        
        let hongbaoImage = UIImage.init(named: "level_img_hongbao")!
        let hongbaoImageView = UIImageView()
        hongbaoImageView.image = hongbaoImage
        self.addSubview(hongbaoImageView)
        hongbaoImageView.isUserInteractionEnabled = true
        hongbaoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(desLabel.snp_bottomMargin).offset(16.uiX)
            make.left.equalTo(desLabel)
            make.width.equalTo(hongbaoImage.size.width.uiX)
            make.height.equalTo(hongbaoImage.size.height.uiX)
        }
        
        let coinImage = UIImage.init(named: "level_img_coin")!
        let coinImageView = UIImageView()
        coinImageView.image = coinImage
        self.addSubview(coinImageView)
        coinImageView.isUserInteractionEnabled = true
        coinImageView.snp.makeConstraints { (make) in
            make.top.equalTo(hongbaoImageView)
            make.left.equalTo(hongbaoImageView.snp_rightMargin).offset(42.uiX)
            make.width.equalTo(coinImage.size.width.uiX)
            make.height.equalTo(coinImage.size.height.uiX)
        }
        
        let hongbaoLabel = UILabel()
        hongbaoLabel.textAlignment = .left
        hongbaoLabel.textColor = .init(hex: "#7A320D")
        hongbaoLabel.font = UIFont.init(style: .medium, size: 14)
        hongbaoLabel.text = "30元"
        self.addSubview(hongbaoLabel)
        hongbaoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(hongbaoImageView.snp_rightMargin).offset(5.uiX)
            make.centerY.equalTo(hongbaoImageView)
            make.width.equalTo(40.uiX)
            make.height.equalTo(11.uiX)
        }
        self.hongbaoLabel = hongbaoLabel
        
        let coinLabel = UILabel()
        coinLabel.textAlignment = .left
        coinLabel.textColor = .init(hex: "#7A320D")
        coinLabel.font = UIFont.init(style: .medium, size: 14)
        coinLabel.text = "80000"
        self.addSubview(coinLabel)
        coinLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coinImageView.snp_rightMargin).offset(5.uiX)
            make.centerY.equalTo(hongbaoImageView)
            make.width.equalTo(60.uiX)
            make.height.equalTo(11.uiX)
        }
        self.coinLabel = coinLabel
        
    }
}
