//
//  HomeTopView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/10.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit

class HomeTopView: UIView {
    
    lazy var imgView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .init(hex: "#EBB862")
        v.borderColor = .init(hex: "#7E4614")
        v.borderWidth = 1.5.uiX
        return v
    }()
    
    lazy var cashLbl: UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: "DIN-Bold", size: 15.uiX)
        l.textColor = .init(hex: "#7A320D")
        l.text = "0元"
        l.textAlignment = .center
        return l
    }()
    
    lazy var coinLbl: UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: "DIN-Bold", size: 15.uiX)
        l.textColor = .init(hex: "#7A320D")
        l.text = "0"
        l.textAlignment = .center
        return l
    }()
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.font = .init(style: .medium, size: 8.uiX)
        l.textColor = .init(hex: "#FFFFFF")
        l.text = "落魄书生"
        return l
    }()
    
    let cashBtn = MusicButton()
    let coinBtn = MusicButton()
    let avatarBtn = MusicButton()
    
    let cashBgView = UIView()
    let coinBgView = UIView()
    let coinImgView = UIImageView()
    let levelBgImgView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(imgView)
        imgView.cornerRadius = 42.uiX/2.0
        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5.uiX)
            make.width.equalTo(42.uiX)
            make.height.equalTo(42.uiX)
        }
        
        addSubview(avatarBtn)
        avatarBtn.snp.makeConstraints { make in
            make.edges.equalTo(imgView)
        }
        
        cashBgView.backgroundColor = .init(hex: "#FCDEAD")
        cashBgView.borderWidth = 1.5.uiX
        cashBgView.borderColor = .init(hex: "#7E4614")
        cashBgView.cornerRadius = 22.4.uiX/2.0
        insertSubview(cashBgView, at: 0)
        cashBgView.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.top).offset(8.5.uiX)
            make.left.equalTo(imgView.snp.left).offset(26.uiX)
            make.height.equalTo(22.4.uiX)
            make.width.greaterThanOrEqualTo(120.uiX)
        }
        
        let cashBtnImg = UIImage.create("home_img_btn01")
        cashBtn.setImage(cashBtnImg, for: .normal)
        cashBgView.addSubview(cashBtn)
        cashBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(1.uiX)
            make.right.equalToSuperview()
            make.size.equalTo(cashBtnImg.snpSize)
        }
        
        let coinImg = UIImage.create("home_icon_coin")
        coinImgView.image = coinImg
        addSubview(coinImgView)
        coinImgView.snp.makeConstraints { make in
            make.centerY.equalTo(cashBgView)
            make.left.equalTo(cashBgView.snp.right).offset(9.uiX)
            make.size.equalTo(coinImg.snpSize)
        }
        
        coinBgView.backgroundColor = .init(hex: "#FCDEAD")
        coinBgView.borderWidth = 1.5.uiX
        coinBgView.borderColor = .init(hex: "#7E4614")
        coinBgView.cornerRadius = 22.4.uiX/2.0
        insertSubview(coinBgView, at: 0)
        coinBgView.snp.makeConstraints { make in
            make.centerY.equalTo(cashBgView)
            make.left.equalTo(coinImgView.snp.left).offset(11.uiX)
            make.height.equalTo(22.4.uiX)
            make.width.greaterThanOrEqualTo(107.uiX)
        }
        
        let coinBtnImg = UIImage.create("home_img_btn02")
        coinBtn.setImage(coinBtnImg, for: .normal)
        coinBgView.addSubview(coinBtn)
        coinBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(0.5.uiX)
            make.right.equalToSuperview()
            make.size.equalTo(coinBtnImg.snpSize)
        }
        
        let levelImg = UIImage.create("home_img_level")
        levelBgImgView.image = levelImg
        insertSubview(levelBgImgView, at: 0)
        levelBgImgView.snp.makeConstraints { make in
            make.bottom.equalTo(imgView.snp.bottom)
            make.left.equalTo(imgView.snp.centerX)
            make.size.equalTo(levelImg.snpSize)
        }
        
        cashBgView.addSubview(cashLbl)
        cashLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18.uiX)
            make.right.equalTo(cashBtn.snp.left).offset(2.uiX)
        }
        
        coinBgView.addSubview(coinLbl)
        coinLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(22.uiX)
            make.right.equalTo(coinBtn.snp.left).offset(-2.uiX)
        }
        
        levelBgImgView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(1.uiX)
            make.left.equalToSuperview().offset(22.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
    
