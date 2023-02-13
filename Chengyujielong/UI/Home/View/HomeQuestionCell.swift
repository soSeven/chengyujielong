//
//  HomeQuestionCell.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/8.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Hue

class HomeQuestionCell: UICollectionViewCell {
    
    var model : HomeQuestionCellModel {
        
        didSet {
            
            self.textLabel.text = model.showWord
            self.selectView.isHidden = !model.isSelected
            if model.word.count < 1 {
                //没有数据
                self.bgView.image = UIImage.init(named: "home_img_txt00")
                
            } else {
                //普通字
                self.bgView.image = UIImage.init(named: "home_img_txt02")
                textLabel.textColor = .init(hex: "#7A310C")
                
                //答案未填字
                if (model.isAnswer) && (model.showWord!.count<1) {
                    self.bgView.image = UIImage.init(named: "home_img_txt04")
                    
                } else if (model.isAnswer) && (model.showWord!.count>0) {
                    //答案已填字
                    self.bgView.image = UIImage.init(named: "home_img_txt03")                    
                }
                
                //成语已经完成
                if model.isEnd && (model.word.count>0){
                    self.bgView.image = UIImage.init(named: "home_img_txt01")
                    textLabel.textColor = .init(hex: "#FFFFFF")
                    textLabel.text = model.word
                } else if !model.isRight && model.isAnswer {
                    //填的字为错误的字
                    self.bgView.image = UIImage.init(named: "home_img_txt03")
                    textLabel.textColor = .init(hex: "#E11818")
                    textLabel.text = model.showWord
                    //填的错误字被下掉
                    if model.showWord.count<1 {
                        self.bgView.image = UIImage.init(named: "home_img_txt04")
                    }
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
    
    lazy var selectView: UIView = {
        let view = UIView()
        view.borderColor = .init(hex: "#8DDB46")
        view.borderWidth = 2.uiX
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        model = HomeQuestionCellModel()
        
        super.init(frame: frame)
        
        setUpUI()
        
    }
    
    func setUpUI () {
        
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
        
        
        bgView.addSubview(selectView)
        
        selectView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-1.uiX)
            make.top.equalToSuperview().offset(-1.uiX)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(1.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

