//
//  HomeAnswerCell.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/10.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Hue

class HomeAnswerCell: UICollectionViewCell {
    
    var model : HomeAnswerCellModel {
        
        didSet {

            self.textLabel.text = model.word
            
            if model.isFill {
                self.bgView.image = UIImage()
                self.textLabel.isHidden = true
            } else {
                self.textLabel.isHidden = false
                if model.word.count>0 {
                    self.bgView.image = UIImage.init(named: "home_img_txt02")
                } else {
                    self.bgView.image = UIImage()
                }
            }
        }
      
    }
    
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.textColor = .init(hex: "#7A310C")
        textLabel.font = UIFont.init(name: "HYa9gj", size: 20.uiX)
        textLabel.text = ""
        return textLabel
    }()
    
    lazy var bgView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage.init(named: "home_img_txt02")
        return v
    }()
        
    
    override init(frame: CGRect) {
        model = HomeAnswerCellModel()
        
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(3.5.uiX)
            make.top.equalToSuperview().offset(3.5.uiX)
            make.bottom.right.equalToSuperview()
        }
        
        bgView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.width.equalToSuperview()
            make.height.equalToSuperview().offset(-2.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
