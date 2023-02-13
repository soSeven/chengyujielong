//
//  PayListCell.swift
//  Dingweibao
//
//  Created by LiQi on 2020/6/4.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class PayListCell: CollectionViewCell {
    
    lazy var priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#79310C")
        lbl.font = .init(style: .bold, size: 15.uiX)
        return lbl
    }()
    
    lazy var markLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 9.uiX)
        return lbl
    }()
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.cornerRadius = 5.uiX
        return v
    }()
    
    lazy var markImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("cash_img_label"))
        return v
    }()
    
    lazy var chooseImgView: UIImageView = {
        let v = UIImageView(image: UIImage.create("cash_img_frame_choose"))
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(3.5.uiX)
            make.top.equalToSuperview().offset(3.5.uiX)
            make.bottom.right.equalToSuperview()
        }
        
        bgView.addSubview(priceLbl)
        
        priceLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(markImgView)
        markImgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(markImgView.image!.snpSize)
        }
        
        markImgView.addSubview(markLbl)
        markLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-2.uiX)
            make.centerX.equalToSuperview()
        }
        
        bgView.addSubview(chooseImgView)
        chooseImgView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.size.equalTo(chooseImgView.image!.snpSize)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: CashPriceModel) {
        priceLbl.text = "\(model.cash.cashDigits)元"
        if let text = model.text{
            markLbl.text = text
            markImgView.isHidden = false
        } else {
            markImgView.isHidden = true
        }
    }
    
}
