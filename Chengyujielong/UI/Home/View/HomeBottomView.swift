//
//  HomeBottomView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/10.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit

class HomeBottomView: UIView {
    
    let retry = HomeBottomItemNumberView(imgName: "home_icon_return")
    let tip = HomeBottomItemNumberView(imgName: "home_icon_tip")
    let how = HomeBottomItemNumberView(imgName: "home_icon_play")
    
    let task = HomeBottomItemLightView(imgName: "home_icon_task")
    let sign = HomeBottomItemDotView(imgName: "home_icon_sign")
    let lottery = HomeBottomItemDotView(imgName: "home_icon_draw")
    
    init() {
        super.init(frame: .zero)
        
        addSubview(retry)
        retry.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16.uiX)
        }
        
        addSubview(tip)
        tip.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(retry.snp.left).offset(-12.uiX)
        }
        
        addSubview(how)
        how.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(tip.snp.left).offset(-10.uiX)
        }
        
        addSubview(task)
        task.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20.uiX)
        }
        
        addSubview(sign)
        sign.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(task.snp.right).offset(14.uiX)
        }
        
        addSubview(lottery)
        lottery.isHidden = true
        lottery.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(sign.snp.right).offset(18.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HomeBottomItemNumberView: UIView {
    
    private lazy var numLbl: UILabel = {
        let l = UILabel()
        l.font = .init(style: .medium, size: 13.uiX)
        l.textColor = .init(hex: "#FFFFFF")
        l.backgroundColor = .init(hex: "#FF0000")
        l.textAlignment = .center
        return l
    }()
    
    let btn = MusicButton()
    
    init(imgName: String) {
        super.init(frame: .zero)
        let img = UIImage.create(imgName)
        let imgView = UIImageView(image: img)
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        numLbl.borderColor = .init(hex: "#582C06")
        numLbl.borderWidth = 1.5.uiX
        numLbl.cornerRadius = 16.uiX/2
        addSubview(numLbl)
        numLbl.snp.makeConstraints { make in
            make.width.equalTo(16.uiX)
            make.height.equalTo(16.uiX)
            make.centerX.equalTo(imgView.snp.right)
            make.centerY.equalTo(imgView.snp.top)
        }
        
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNumber(0)
    }
    
    func setupNumber(_ n: Int) {
        if n == 0 {
            numLbl.isHidden = true
        } else {
            numLbl.isHidden = false
            numLbl.text = "\(n)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HomeBottomItemDotView: UIView {
    
    lazy var dot: UIImageView = {
        return UIImageView()
    }()
    
    let btn = MusicButton()
    
    init(imgName: String) {
        super.init(frame: .zero)
        let img = UIImage.create(imgName)
        let imgView = UIImageView(image: img)
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let dotImg = UIImage.create("home_img_dot")
        dot.image = dotImg
        dot.isHidden = true
        addSubview(dot)
        dot.snp.makeConstraints { make in
            make.size.equalTo(dotImg.snpSize)
            make.right.equalTo(imgView.snp.right)
            make.top.equalTo(imgView.snp.top)
        }
        
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HomeBottomItemLightView: UIView {
    
    lazy var light: UIImageView = {
        return UIImageView()
    }()
    
    lazy var dot: UIImageView = {
        return UIImageView()
    }()
    
    let btn = MusicButton()
    
    init(imgName: String) {
        super.init(frame: .zero)
        let img = UIImage.create(imgName)
        let imgView = UIImageView(image: img)
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let dotImg = UIImage.create("home_img_dot")
        dot.image = dotImg
        dot.isHidden = true
        addSubview(dot)
        dot.snp.makeConstraints { make in
            make.size.equalTo(dotImg.snpSize)
            make.right.equalTo(imgView.snp.right)
            make.top.equalTo(imgView.snp.top)
        }
        
        let lightImg = UIImage.create("home_img_light")
        light.image = lightImg
        insertSubview(light, at: 0)
        light.snp.makeConstraints { make in
            make.size.equalTo(lightImg.snpSize)
            make.center.equalToSuperview()
        }
        
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = false
        ro.fillMode = .forwards
        light.layer.add(ro, forKey: "rotationAnimation")
        
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
