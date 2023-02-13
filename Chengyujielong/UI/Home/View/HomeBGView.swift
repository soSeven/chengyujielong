//
//  HomeBGView.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/14.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import UIKit
import Hue
import SnapKit
import RxSwift
import RxCocoa

class HomeBGView: UIView  {
    
    weak var delegate: HomeViewController?
    
    //mark:Label
    private lazy var titleLabel: UILabel =  {
        
        let titleLabel = UILabel.init()
        
        titleLabel.font = UIFont.init(style: .regular, size: 8)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "暂无头衔"
        
        titleLabel.x = 22.uiX
        titleLabel.y = 1.uiX
        titleLabel.width = 36.uiX
        titleLabel.height = 8.uiX
        
        return titleLabel
    }()
    
    lazy var tixianLabel: UILabel =  {
        
        let tixianLabel = UILabel.init()
        
        tixianLabel.font = UIFont.init(name: "DIN-Bold", size: 15.uiX)
        tixianLabel.textColor = .init(hex: "#7A310C")
        tixianLabel.textAlignment = .left
        tixianLabel.text = "199.99元"
        
        tixianLabel.x = 20.uiX
        tixianLabel.y = 1.uiX
        tixianLabel.width = 65.uiX
        tixianLabel.height = 20.uiX
        
        return tixianLabel
    }()
    
    lazy var hongbaoLabel: UILabel =  {
        
        let hongbaoLabel = UILabel.init()
        
        hongbaoLabel.font = UIFont.init(name: "DIN-Bold", size: 15.uiX)
        hongbaoLabel.textColor = .init(hex: "#7A310C")
        hongbaoLabel.textAlignment = .left
        hongbaoLabel.text = "9999"
        
        hongbaoLabel.x = 22.uiX
        hongbaoLabel.y = 1.uiX
        hongbaoLabel.width = 60.uiX
        hongbaoLabel.height = 20.uiX
        
        return hongbaoLabel
    }()
    
    lazy var gameTitleLabel: UILabel =  {
        
        let gameTitleLabel = UILabel.init()
        
        gameTitleLabel.font = UIFont.init(name: "HYa9gj", size: 14)
        gameTitleLabel.textColor = .init(hex: "#7A310C")
        gameTitleLabel.textAlignment = .center
        gameTitleLabel.text = "第1关"
        
        gameTitleLabel.width = self.gameTitleImageView.width
        gameTitleLabel.height = 16.uiX
        gameTitleLabel.x = 0
        gameTitleLabel.y = (self.gameTitleImageView.height - gameTitleLabel.height)/2 - 4.uiX
        
        return gameTitleLabel
    }()

    //mark :UIButton
    lazy var tixianButton: UIButton =  {
        let tixianButton = UIButton.init(frame: .zero)
        
        tixianButton.setBackgroundImage(UIImage.init(named: "home_img_btn01"), for: .normal)
        tixianButton.width = 32.uiX
        tixianButton.height = 20.uiX
        tixianButton.y = (self.tixianView.height - tixianButton.height)/2 + 0.5.uiX
        tixianButton.x = self.tixianView.width - tixianButton.width - 2.uiX
        
        return tixianButton
    }()
    
    lazy var hongbaoButton: UIButton =  {
        let hongbaoButton = UIButton.init(frame: .zero)
        let image = UIImage.init(named: "home_img_btn02")
        hongbaoButton.setBackgroundImage(image , for: .normal)
        hongbaoButton.size = image!.snpSize
        hongbaoButton.y = (self.hongbaoView.height - hongbaoButton.height)/2 + 0.5.uiX
        hongbaoButton.x = self.hongbaoView.width - hongbaoButton.width - 2.uiX
        
        return hongbaoButton
    }()
    
    lazy var taskButton: UIButton =  {
        let button = UIButton.init(frame: .zero)
        let image = UIImage.init(named: "home_icon_task")
        
        button.setBackgroundImage(image, for: .normal)
        button.width = image!.size.width.uiX
        button.height = image!.size.height.uiX
        button.y = (self.height - button.height) - 20.uiX - UIDevice.safeAreaBottom
        button.x = 20.uiX
        
        return button
    }()
    
    lazy var signButton: UIButton =  {
        let button = UIButton.init(frame: .zero)
        let image = UIImage.init(named: "home_icon_sign")
        
        button.setBackgroundImage(image, for: .normal)
        button.width = image!.size.width.uiX
        button.height = image!.size.height.uiX
        button.y = self.taskButton.y
        button.x = 20.uiX + self.taskButton.width + 10.uiX
        
        return button
    }()

    lazy var drawButton: UIButton =  {
        let button = UIButton.init(frame: .zero)
        let image = UIImage.init(named: "home_icon_draw")
        
        button.setBackgroundImage(image, for: .normal)
        button.width = image!.size.width.uiX
        button.height = image!.size.height.uiX
        button.y = self.taskButton.y
        button.x = 20.uiX + (self.taskButton.width + 10.uiX)*2
        return button
    }()
    
    lazy var replayButton: UIButton =  {
        let button = UIButton.init(frame: .zero)
        
        let image: UIImage = UIImage.init(named: "home_icon_return")!
        button.setBackgroundImage(image, for: .normal)
        
        button.width = image.size.width.uiX
        button.height = image.size.height.uiX
        button.y = self.height - button.height - 20.uiX - UIDevice.safeAreaBottom
        button.x = self.width - button.width - 20.uiX
        return button
    }()
    
    lazy var tipButton: UIButton =  {
        let button = UIButton.init(frame: .zero)
        
        let image: UIImage = UIImage.init(named: "home_icon_tip")!
        button.setBackgroundImage(image, for: .normal)
        button.width = image.size.width.uiX
        button.height = image.size.height.uiX
        button.y = self.replayButton.y
        button.x = self.replayButton.x - button.width - 5.uiX
        return button
    }()
    
    lazy var howPlayButton: UIButton =  {
        let button = UIButton.init(frame: .zero)
        
        let image: UIImage = UIImage.init(named: "home_icon_play")!
        button.setBackgroundImage(image, for: .normal)
        button.width = image.size.width.uiX
        button.height = image.size.height.uiX
        button.y = self.replayButton.y
        button.x = self.tipButton.x - button.width - 5.uiX
        return button
    }()

    
    //mark :ImageView
    private lazy var lelImageView: UIImageView =  {
        
        let imageView = UIImageView.init(frame: self.bounds)
        
        imageView.image = UIImage.init(named: "home_img_level")
        imageView.width = 68.uiX
        imageView.height = 12.uiX
        imageView.y = UIDevice.statusBarHeight + 45.uiX
        imageView.x = 28.uiX
        
        return imageView
    }()
    
    private lazy var BGImageView: UIImageView =  {
        
        let imageView = UIImageView.init(frame: self.bounds)
        imageView.image = UIImage.init(named: "home_img_bgd")
        
        return imageView
    }()
    
    private lazy var palyImageView: UIImageView =  {
        
        let imageView = UIImageView.init(frame: .zero)
        
        imageView.image = UIImage.init(named: "home_img_frame01")
        
        imageView.width = self.width - 22.uiX
        imageView.height = 514.uiX
        imageView.y = UIDevice.statusBarHeight + 78.uiX
        imageView.x = 11.uiX
        
        return imageView
    }()
    
    lazy var iconImageView: UIImageView =  {
        
        let imageView = UIImageView.init(frame: .zero)
        
        imageView.backgroundColor = UIColor.green
        imageView.width = 44.uiX
        imageView.height = 44.uiX
        imageView.y = UIDevice.statusBarHeight + 14.uiX
        imageView.x = 8.uiX
        
        imageView.image = UIImage.init(named: "icon")
        imageView.cornerRadius = imageView.height/2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.uiX
        let color : UIColor = .init(hex: "#6A370B")
        imageView.layer.borderColor = color.cgColor
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var hongbaoImageView: UIImageView =  {
        let image = UIImage.init(named: "home_icon_coin")
        let imageView = UIImageView.init(frame: .zero)
        
        imageView.width = 32.uiX
        imageView.height = 32.uiX
        imageView.y = UIDevice.statusBarHeight + 20.uiX
        imageView.x = 160.uiX
        
        imageView.image = UIImage.init(named: "home_icon_coin")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
     lazy var topTipView: UIImageView =  {
        
        let topTipView = UIImageView.init(frame: .zero)
        let image = UIImage.init(named: "home_img_bgd_float")
        topTipView.size = image!.snpSize
        topTipView.y = UIDevice.statusBarHeight
        topTipView.x = 284.uiX
        
        topTipView.image = UIImage.init(named: "home_img_bgd_float")
        topTipView.isUserInteractionEnabled = true
        return topTipView
    }()
    
    private lazy var gameTitleImageView: UIImageView =  {
        
        let imageView = UIImageView.init(frame: .zero)
        
        imageView.width = 120.uiX
        imageView.height = 47.uiX
        imageView.y = 62.uiX + UIDevice.statusBarHeight
        imageView.x = (self.width
             - imageView.width)/2
        
        imageView.image = UIImage.init(named: "home_img_title")
        
        return imageView
    }()
    
    private lazy var topTipLightImageView: UIImageView =  {
        
        let topTipLightImageView = UIImageView.init(frame: .zero)
        
        topTipLightImageView.width = 80.uiX
        topTipLightImageView.height = 80.uiX
        topTipLightImageView.y = self.topTipView.y - (topTipLightImageView.height - self.topTipView.height)/2
        topTipLightImageView.x = 284.uiX
        
        topTipLightImageView.image = UIImage.init(named: "home_img_light")
        
        return topTipLightImageView
    }()
    
    lazy var progressView : HomeProgressViewView =  {
        
        let progressView = HomeProgressViewView.init(frame: .zero)
        
        progressView.width = 282.uiX
        progressView.height = 48.uiX
        progressView.y = 35.uiX
        progressView.x = 38.uiX
        
        progressView.image = UIImage.init(named: "home_img_frame02")
        
        return progressView
    }()
    
    //mark:View
    private lazy var tixianView: UIView =  {
        
        let tixianView = UIView.init(frame: .zero)
        
        tixianView.backgroundColor = .init(hex: "#FCDEAD")
        
        tixianView.width = 120.uiX
        tixianView.height = 24.uiX
        tixianView.y = 22.uiX + UIDevice.statusBarHeight
        tixianView.x = 32.uiX
        
        tixianView.cornerRadius = tixianView.height/2
        tixianView.clipsToBounds = true
        tixianView.layer.borderWidth = 2.uiX
        let color : UIColor = .init(hex: "#6A370B")
        tixianView.layer.borderColor = color.cgColor
        
        return tixianView
    }()
    
    private lazy var hongbaoView: UIView =  {
        
        let hongbaoView = UIView.init(frame: .zero)
        
        hongbaoView.backgroundColor = .init(hex: "#FCDEAD")
        
        hongbaoView.width = 106.uiX
        hongbaoView.height = 24.uiX
        hongbaoView.y = 22.uiX + UIDevice.statusBarHeight
        hongbaoView.x = 170.uiX
        
        hongbaoView.cornerRadius = hongbaoView.height/2
        hongbaoView.clipsToBounds = true
        hongbaoView.layer.borderWidth = 2.uiX
        let color : UIColor = .init(hex: "#6A370B")
        hongbaoView.layer.borderColor = color.cgColor
        
        return hongbaoView
    }()
    
    override init(frame: CGRect)  {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        self.addSubview(self.BGImageView)
        self.addSubview(self.palyImageView)
        self.addSubview(self.tixianView)
    
        self.tixianView.addSubview(self.tixianLabel)
        
        self.tixianView.addSubview(self.tixianButton)
        
        self.addSubview(self.lelImageView)
        self.lelImageView.addSubview(self.titleLabel)
        self.addSubview(self.iconImageView)
        self.addSubview(self.hongbaoView)
        
        self.hongbaoView.addSubview(self.hongbaoLabel)
        self.addSubview(self.hongbaoImageView)
        
        hongbaoView.addSubview(self.hongbaoButton)
        
//        self.addSubview(self.topTipLightImageView)

//        self.addSubview(self.topTipView)
        self.addSubview(self.gameTitleImageView)
        self.gameTitleImageView.addSubview(self.gameTitleLabel)
        
        self.palyImageView.addSubview(self.progressView)
        palyImageView.isUserInteractionEnabled = true
        self.addSubview(self.taskButton)
        self.addSubview(self.signButton)
        self.addSubview(self.drawButton)
        self.addSubview(self.replayButton)
        self.addSubview(self.tipButton)
        self.addSubview(self.howPlayButton)
        
        self.addSubview(self.tipDot)
        self.addSubview(self.reSetDot)
        
        self.tipDot.snp.makeConstraints { (make) in
            make.width.height.equalTo(16.uiX)
            make.top.equalTo(self.tipButton).offset(-8.uiX)
            make.right.equalTo(self.tipButton).offset(6.uiX)
        }
        
        self.reSetDot.snp.makeConstraints { (make) in
            make.width.height.equalTo(16.uiX)
            make.top.equalTo(self.replayButton).offset(-8.uiX)
            make.right.equalTo(self.replayButton).offset(6.uiX)
        }
        
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let u = u else { return }
            self.tipDot.label!.text = "\(u.tipsNum ?? 0)"
            self.reSetDot.label!.text = "\(u.playAgainNum ?? 0)"
        }).disposed(by: rx.disposeBag)
        
    }
    
    lazy var howPlayView: HomeHowPlayView =  {
        let howPlayView = HomeHowPlayView(frame: self.bounds)
        
        return howPlayView
        
    }()
    
    lazy var homeUserView: HomeUserView =  {
        let homeUserView = HomeUserView(frame: self.bounds)
        
        return homeUserView
        
    }()
    
    private lazy var tipDot: HomeDotView =  {
        let v = HomeDotView.init(frame: .zero)
        
        return v
        
    }()
    private lazy var reSetDot: HomeDotView =  {
        let v = HomeDotView.init(frame: .zero)
        
        return v
        
    }()
    
}

class HomeDotView: UIView {
    
    var label: UILabel?
    
    override init(frame: CGRect)  {
           
           super.init(frame: frame)
           
           setUpUI()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func setUpUI() {
        
        self.backgroundColor = .init(hex: "#FF0000")
        self.width = 16.uiX
        self.height = 16.uiX
        
        let label = UILabel.init()
        label.font = UIFont.init(style: .medium, size: 13.uiX)
        label.textColor = .init(hex: "#FFFFFF")
        label.textAlignment = .center
        label.text = "0"
        self.label = label
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        addSubview(label)
        
        layer.cornerRadius = self.width/2
        clipsToBounds = true
        borderWidth = 2.uiX
        borderColor = .init(hex: "#582C06")
        
    }
}


class HomeHowPlayView : UIView {
    
    private var num :BehaviorRelay<Int> = BehaviorRelay.init(value: 0)
    private let stringArray = ["点击将字填入空白，点击填的字可以将它取下来","点击其他空白格子可以替换选择的空白格子","完成所有成语即可过关！"]
    private var CtImageView: UIImageView?
    private var label: UILabel?
    private var pgControl : UIPageControl?
    private var rightImageView : UIImageView?
    private var leftImageView : UIImageView?
    
    override init(frame: CGRect)  {
           
           super.init(frame: frame)
           
           setUpUI()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func setUpUI() {
        
        let bgImage = UIImage.init(named: "how_img_frame")!
        let BGImageView = UIImageView()
        BGImageView.image = bgImage
        
        self.addSubview(BGImageView)
        BGImageView.width = bgImage.size.width
        BGImageView.height = bgImage.size.height
        BGImageView.y = (self.height - BGImageView.height)/2
        BGImageView.x = (self.width - BGImageView.width)/2
        BGImageView.isUserInteractionEnabled = true
        
        let ctImage = UIImage.init(named: "how_img01")!
        let CtImageView = UIImageView()
        CtImageView.image = ctImage
        BGImageView.addSubview(CtImageView)
        CtImageView.width = ctImage.size.width
        CtImageView.height = ctImage.size.height
        CtImageView.y = 52.uiX
        CtImageView.x = (BGImageView.width - CtImageView.width)/2
        CtImageView.isUserInteractionEnabled = true
        self.CtImageView = CtImageView
        
        
        let closeImage = UIImage.init(named: "task_img_close")!
        let closeImageView = MusicButton()
        closeImageView.setBackgroundImage(closeImage, for: .normal)

        self.addSubview(closeImageView)
        closeImageView.width = closeImage.size.width
        closeImageView.height = closeImage.size.height
        closeImageView.y = BGImageView.y - closeImageView.height
        closeImageView.x = 300.uiX
        
        let leftImage = UIImage.init(named: "how_img_left_nor")!
        let leftBtn = MusicButton()
                 
        BGImageView.addSubview(leftBtn)
        leftBtn.width = leftImage.size.width + 10.uiX
        leftBtn.height = leftImage.size.height + 10.uiX
        leftBtn.y = BGImageView.height - 30.uiX - leftBtn.height
        leftBtn.x = 25.uiX
        
        let leftImageView = UIImageView()
        BGImageView.insertSubview(leftImageView, belowSubview: leftBtn)
        leftImageView.image = leftImage
        leftImageView.width = leftImage.size.width
        leftImageView.height = leftImage.size.height
        leftImageView.x = leftBtn.x + 5.uiX
        leftImageView.y = leftBtn.y + (leftBtn.height - leftImageView.height)/2
        
        
        let rightImage = UIImage.init(named: "how_img_right")!
        let rightBtn = MusicButton()
        
        BGImageView.addSubview(rightBtn)
        rightBtn.width = rightImage.size.width + 10.uiX
        rightBtn.height = rightImage.size.height + 10.uiX
        rightBtn.y = leftBtn.y
        rightBtn.x = BGImageView.width - rightBtn.width - 25.uiX
        
        let rightImageView = UIImageView()
        BGImageView.insertSubview(rightImageView, belowSubview: rightBtn)
        rightImageView.image = rightImage
        rightImageView.width = rightImage.size.width
        rightImageView.height = rightImage.size.height
        rightImageView.x = rightBtn.x + 5.uiX
        rightImageView.y = rightBtn.y + (rightBtn.height - rightImageView.height)/2
        
        let label = UILabel.init()
        label.font = UIFont.init(style: .regular, size: 11.uiX)
        label.textColor = .init(hex: "#7A320D")
        label.textAlignment = .center
        label.text = self.stringArray.first
        BGImageView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(11.uiX)
            make.top.equalTo(CtImageView.snp_bottomMargin).offset(16.uiX)
        }
        self.label = label
        self.num.subscribe(onNext: { [weak self](num) in
            guard let self = self else { return }
            self.numChange(num: num)
        }).disposed(by: rx.disposeBag)
        
        let pgControl = UIPageControl()
        pgControl.numberOfPages = 3
        pgControl.currentPage = 0
        pgControl.currentPageIndicatorTintColor = .init(hex: "#7A320C")
        pgControl.pageIndicatorTintColor = .init(hex: "#AA865E")
        BGImageView.addSubview(pgControl)
        pgControl.snp.makeConstraints { (make) in
            make.width.equalTo(5.uiX)
            make.centerX.equalToSuperview()
            make.height.equalTo(5.uiX)
            make.centerY.equalTo(rightBtn)
        }
        self.pgControl = pgControl
        pgControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        self.rightImageView = rightImageView
        self.leftImageView = leftImageView
        leftBtn.addTarget(self, action: #selector(goTop) , for:.touchUpInside )
        rightBtn.addTarget(self, action: #selector(goNext) , for:.touchUpInside )
        closeImageView.addTarget(self, action: #selector(close) , for:.touchUpInside )
    }
    
    func numChange (num : Int) {
        CtImageView?.image = UIImage.init(named: "how_img0\(self.num.value+1)")
        let string = stringArray[num]
        label?.text = string
        pgControl?.currentPage = num
        if num == 2 {
            self.rightImageView?.image = UIImage.init(named: "how_img_right_nor")
        } else {
            self.rightImageView?.image = UIImage.init(named: "how_img_right")
        }
        if num == 0 {
            self.leftImageView?.image = UIImage.init(named: "how_img_left_nor")
        } else {
            self.leftImageView?.image = UIImage.init(named: "how_img_left")
        }
    }
    
    @objc func goTop () {
        if self.num.value<1 {
            return
        } else {
            let num = self.num.value - 1
            self.num.accept(num)
            
        }
    }
    
    @objc func goNext () {
        if self.num.value>1 {
                   return
               } else {
                   let num = self.num.value + 1
            self.num.accept(num)
               }
    }
    
    @objc func close () {
        if let sup = self.parentViewController as? PopView {
            sup.hide()
        }
    }
          
}

class HomeProgressViewView : UIImageView {
    
    private lazy var progressTextLabel: UILabel =  {
        
        let progressTextLabel = UILabel.init()
        
        progressTextLabel.font = UIFont.init(style: .medium, size: 13.uiX)
        progressTextLabel.textColor = .init(hex: "#7A310C")
        progressTextLabel.textAlignment = .left
        progressTextLabel.text = "继续完成20关,再次提现哦~"
        
        progressTextLabel.x = 17.5.uiX
        progressTextLabel.y = 10.uiX
        progressTextLabel.width = 186.uiX
        progressTextLabel.height = 14.uiX
        
        return progressTextLabel
    }()
    
    private lazy var xiaohongbaoLabel: UILabel =  {
        
        let xiaohongbaoLabel = UILabel.init()
        
        xiaohongbaoLabel.font = UIFont.init(style: .medium, size: 11.uiX)
        xiaohongbaoLabel.textColor = .init(hex: "#7A310C")
        xiaohongbaoLabel.textAlignment = .center
        xiaohongbaoLabel.text = "1/20"
        
        xiaohongbaoLabel.x = 208 .uiX
        xiaohongbaoLabel.y = 26.uiX
        xiaohongbaoLabel.width = 50.uiX
        xiaohongbaoLabel.height = 12.uiX
        
        return xiaohongbaoLabel
    }()
    
      private lazy var progressLineView: UIView =  {
          
          let progressLineView = UIView.init(frame: .zero)
          
          progressLineView.backgroundColor = .init(hex: "#F4E5BE")
          
          progressLineView.width = 186.uiX
          progressLineView.height = 7.uiX
          progressLineView.y = 30.uiX
          progressLineView.x = 18.5.uiX
          
          progressLineView.layer.borderWidth = 1.uiX
          let color : UIColor = .init(hex: "#DA862D")
          progressLineView.layer.borderColor = color.cgColor
        progressLineView.backgroundColor = .clear
          
          return progressLineView
      }()
    
    lazy var xiaohongbaoButton: UIButton =  {
        
        let imageView = UIButton.init(frame: .zero)
        
        imageView.setBackgroundImage(UIImage.init(named: "home_img_package"), for: .normal)
        
        imageView.width = 26.uiX
        imageView.height = 26.uiX
        imageView.y = 0.uiX
        imageView.x = 226.uiX
        
        return imageView
    }()
    
    private lazy var lightImageView: UIImageView =  {
        
        let imageView = UIImageView.init(frame: .zero)
        let image = UIImage.init(named: "home_img_light01")
        imageView.image = image
        
        imageView.size = image!.snpSize
        imageView.y = 0.uiX
        imageView.x = 226.uiX
        
        return imageView
    }()
    
    private lazy var progressLineImageView: UIImageView =  {
        
        let imageView = UIImageView.init(frame: .zero)
        let image = UIImage.init(named: "home_img_schedule")
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var labelImageView: UIImageView =  {
        
        let imageView = UIImageView.init(frame: .zero)
        let image = UIImage.init(named: "home_img_label")
        imageView.image = image
        
        imageView.size = image!.snpSize
        imageView.y = -image!.size.height
        imageView.x = 226.uiX
        
        return imageView
    }()
    
    override init(frame: CGRect)  {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubview(self.progressTextLabel)
        addSubview(self.progressLineView)
        addSubview(self.lightImageView)
        addSubview(self.xiaohongbaoButton)
        addSubview(self.xiaohongbaoLabel)
        addSubview(self.labelImageView)
        insertSubview(self.progressLineImageView, belowSubview: self.progressLineView)
        isUserInteractionEnabled = true
        
        xiaohongbaoLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.xiaohongbaoButton)
            make.width.equalTo(50.uiX)
            make.height.equalTo(12.uiX)
            make.top.equalTo(self.lightImageView.snp_bottomMargin).offset(2.uiX)
        }
        
        self.layoutIfNeeded()
        progressLineImageView.frame = self.progressLineView.frame
        
        lightImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.xiaohongbaoButton)
            make.size.equalTo(self.lightImageView)
        }
        labelImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.xiaohongbaoButton)
            make.size.equalTo(self.labelImageView)
            make.bottom.equalTo(self.xiaohongbaoButton.snp_topMargin).offset(-5.uiX)
        }
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        lightImageView.layer.add(ro, forKey: "rotationAnimation")
        
        let scale = CAKeyframeAnimation.init(keyPath: "transform.scale")
        scale.fillMode = CAMediaTimingFillMode.backwards
        scale.isRemovedOnCompletion = true
        scale.values = [1,1.2,1]
        scale.duration = 1
        scale.autoreverses = false
        scale.repeatCount = HUGE
        labelImageView.layer.add(scale, forKey: nil)
        labelImageView.layer.fillMode = CAMediaTimingFillMode.backwards
        
    }
    
    /// 总关卡值  当前关卡值  差多少关  进度  是否显示提现
    func getCashChange (all: Int,now :Int,sub :Int,pr :CGFloat,isShow :Bool) {
        print(all,now,sub,pr,isShow)
        if !isShow {
            let progressText = NSMutableAttributedString(string: "距离下次提现还差")
            let progressA = NSMutableAttributedString(string: "\(sub)关")
            progressA.yy_color = .init(hex: "#E53A1F")
            progressText.append(progressA)
            self.progressTextLabel.attributedText = progressText

            let text = NSMutableAttributedString(string: "\(now)")
            text.yy_color = .init(hex: "#E53A1F")
            text.yy_font = UIFont.init(style: .medium, size: 11.uiX)
            let a = NSMutableAttributedString(string: "/\(all)")
            text.append(a)
            self.xiaohongbaoLabel.attributedText = text

            self.progressLineImageView.width = self.progressLineView.width * pr
            self.lightImageView.isHidden = true
            self.labelImageView.isHidden = true
        } else {
            self.lightImageView.isHidden = false
            self.labelImageView.isHidden = false
            let progressText = NSMutableAttributedString(string: "可以提现")
            self.progressTextLabel.attributedText = progressText

            let text = NSMutableAttributedString(string: "\(now)")
            text.yy_color = .init(hex: "#E53A1F")
            text.yy_font = UIFont.init(style: .medium, size: 11.uiX)
            let a = NSMutableAttributedString(string: "/\(all)")
            text.append(a)
            self.xiaohongbaoLabel.attributedText = text

            self.progressLineImageView.width = self.progressLineView.width * pr

            let ro = CABasicAnimation(keyPath: "transform.rotation.z")
            ro.toValue = Double.pi*2.0
            ro.duration = 5
            ro.repeatCount = HUGE
            ro.isRemovedOnCompletion = true
            ro.fillMode = .forwards
            self.lightImageView.layer.removeAllAnimations()
            self.lightImageView.layer.add(ro, forKey: "rotationAnimation")

            let scale = CAKeyframeAnimation.init(keyPath: "transform.scale")
            scale.fillMode = CAMediaTimingFillMode.backwards
            scale.isRemovedOnCompletion = true
            scale.values = [1,1.2,1]
            scale.duration = 1
            scale.autoreverses = false
            scale.repeatCount = HUGE
            self.labelImageView.layer.fillMode = CAMediaTimingFillMode.backwards
            self.labelImageView.layer.removeAllAnimations()
            self.labelImageView.layer.add(scale, forKey: nil)
        }
        
        
    }
    
}
