//
//  SignPopCell.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignPopCell: CollectionViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#7A310C")
        lbl.font = .init(style: .medium, size: 10.uiX)
        return lbl
    }()
    
    lazy var priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#7A320D")
        lbl.font = UIFont.init(name: "DIN-Bold", size: 12.5.uiX)
        return lbl
    }()
    
    lazy var bgImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("sign_login_img02"))
        return v
    }()
    
    lazy var markImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("sign_login_choose"))
        return v
    }()
    
    lazy var redBagImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("sign_login_honbao"))
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().priority(900)
            make.size.equalTo(bgImgView.image!.snpSize).priority(900)
        }
        
        bgImgView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.uiX)
            make.left.right.equalToSuperview()
        }
        
        bgImgView.addSubview(redBagImgView)
        
        bgImgView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.centerX.equalTo(redBagImgView)
            make.bottom.equalToSuperview().offset(-10.uiX)
        }
        
        redBagImgView.snp.makeConstraints { make in
            make.bottom.equalTo(priceLbl.snp.top).offset(0.uiX)
            make.centerX.equalToSuperview()
            make.size.equalTo(redBagImgView.image!.snpSize)
        }
        
//        bgImgView.alpha = 0.4
        
        contentView.addSubview(markImgView)
        markImgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(1.uiX)
            make.right.equalToSuperview().offset(3.uiX)
            make.size.equalTo(markImgView.image!.snpSize)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: SignReward, index: Int) {
        cellDisposeBag = DisposeBag()
        let day = index + 1
        model.day = day
        
        titleLbl.text = "第\(day)天"
        
        let n = NumberFormatter()
        n.maximumFractionDigits = 2
        n.minimumFractionDigits = 0
        let s = n.string(from: NSNumber(value: model.number)) ?? "0"
        
        if model.type == 1 {
            redBagImgView.image = UIImage.create("sign_login_honbao")
            priceLbl.text = "+\(s)元"
        } else {
            redBagImgView.image = UIImage.create("sign_login_coin")
            priceLbl.text = "+\(s)"
        }
        
        markImgView.isHidden = true
        if model.hasReceive > 0 {
            if day == 7 {
                bgImgView.image = UIImage.create("sign_login_img03")
            } else {
                bgImgView.image = UIImage.create("sign_login_img02")
            }
            bgImgView.alpha = 0.4
            markImgView.isHidden = false
        } else {
            bgImgView.alpha = 1
            if model.canReceive > 0 {
                if day == 7 {
                    bgImgView.image = UIImage.create("sign_login_img04")
                } else {
                    bgImgView.image = UIImage.create("sign_login_img_choose")
                }
            } else {
                if day == 7 {
                    bgImgView.image = UIImage.create("sign_login_img03")
                } else {
                    bgImgView.image = UIImage.create("sign_login_img02")
                }
            }
        }
        
        redBagImgView.snp.updateConstraints { make in
            make.size.equalTo(redBagImgView.image!.snpSize)
        }
        
        bgImgView.snp.remakeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().priority(900)
            make.size.equalTo(bgImgView.image!.snpSize).priority(900)
        }
        
    }
    
    private func getAttributedText(n: Int, isActive: Bool) -> NSAttributedString {
        let img = UIImage.create("qdtx-jbjl-jb-icon")
        let att = NSTextAttachment()
        att.image = img
        att.bounds = .init(x: 0, y: -2.uiX, width: 10.uiX, height: 10.uiX)
        let a = NSAttributedString(attachment: att)
        
        let att1: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 9.uiX),
            .foregroundColor: UIColor(hex: "#ffffff")
        ]
        
        let a1 = NSMutableAttributedString(string: isActive ? "已领 \(n) " : "+\(n) ", attributes: att1)
        a1.append(a)
        return a1
    }
    
}
