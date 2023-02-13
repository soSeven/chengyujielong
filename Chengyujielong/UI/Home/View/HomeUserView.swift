//
//  HomeUserView.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/18.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import UIKit
import Hue
import SnapKit
import YYText
import MBProgressHUD

class HomeUserView: UIView {
    
    var fwButton :UIButton?
    var ysButton :UIButton?
    var zxButton :UIButton?
    private var adLabel :UILabel?
    private var num = 1
    private var nameLabel :UILabel?
    private var userIDLabel :UILabel?
    private var cashLabel :UILabel?
    private var iconUserImageView :UIImageView?
    var getCashButton :UIButton?
    
    override init(frame: CGRect)  {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        let bgImage = UIImage.init(named: "mine_img_frame")!
                
        
        let BGImageView = UIImageView()
        BGImageView.image = bgImage
        
        self.addSubview(BGImageView)
        BGImageView.width = bgImage.size.width.uiX
        BGImageView.height = bgImage.size.height.uiX
        BGImageView.y = (self.height - BGImageView.height)/2
        BGImageView.x = (self.width - BGImageView.width)/2
        BGImageView.isUserInteractionEnabled = true
        
        let closeImage = UIImage.init(named: "task_img_close")!
        let closeImageView = UIButton()
        closeImageView.setBackgroundImage(closeImage, for: .normal)
        
        self.addSubview(closeImageView)
        closeImageView.width = closeImage.size.width.uiX
        closeImageView.height = closeImage.size.height.uiX
        closeImageView.y = BGImageView.y - closeImageView.height
        closeImageView.x = 330.uiX
        
        closeImageView.rx.tap.subscribe(onNext: { _ in
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        let iconImage = UIImage.init(named: "mine_img_user")!
        
        let iconUserImage = UIImage.init(named: "icon")!
        let iconUserImageView = UIImageView()
        iconUserImageView.image = iconUserImage
        BGImageView.addSubview(iconUserImageView)
        iconUserImageView.width = 58.uiX
        iconUserImageView.height = 58.uiX
        iconUserImageView.y = 45.uiX
        iconUserImageView.x = 35.uiX
        self.iconUserImageView = iconUserImageView
        
        let iconImageView = UIImageView()
        iconImageView.image = iconImage
        BGImageView.addSubview(iconImageView)
        iconImageView.width = iconImage.size.width.uiX
        iconImageView.height = iconImage.size.height.uiX
        iconImageView.y = 45.uiX
        iconImageView.x = 35.uiX - (iconImage.size.width.uiX - iconUserImageView.width)
        iconImageView.isUserInteractionEnabled = true
  
        
        let nameLabel = UILabel.init()
        
        nameLabel.font = UIFont.init(style: .bold, size: 16.uiX)
        nameLabel.textColor = .init(hex: "#7A320D")
        nameLabel.textAlignment = .left
        nameLabel.text = "用户名"
        
        nameLabel.x = iconImageView.x + iconImageView.width + 12.5.uiX
        nameLabel.y = iconImageView.y + 12.5.uiX
        nameLabel.width = 100.uiX
        nameLabel.height = 16.uiX
        BGImageView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        
        let userIDLabel = UILabel.init()
        userIDLabel.font = UIFont.init(style: .medium, size: 13.uiX)
        userIDLabel.textColor = .init(hex: "#B08260")
        userIDLabel.textAlignment = .left
        userIDLabel.text = ""
        BGImageView.addSubview(userIDLabel)
        userIDLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(nameLabel)
            make.height.equalTo(12.uiX)
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(15.uiX)
        }
        self.userIDLabel = userIDLabel
        
        
        let lxLabel = UILabel.init()
        lxLabel.font = UIFont.init(style: .bold, size: 16.uiX)
        lxLabel.textColor = .init(hex: "#7A320D")
        lxLabel.textAlignment = .center
        lxLabel.text = "联系我们"
        
        lxLabel.x = 0
        lxLabel.y = 412.uiX
        lxLabel.width = BGImageView.width
        lxLabel.height = 16.uiX
        BGImageView.addSubview(lxLabel)
        
        let adLabel = UILabel.init()
        adLabel.font = UIFont.init(style: .medium, size: 14.uiX)
        adLabel.textColor = .init(hex: "#B08260")
        adLabel.textAlignment = .center
        adLabel.text = "308179672@qq.com"
        self.adLabel = adLabel
        
        adLabel.height = 16.uiX
        adLabel.width = BGImageView.width
        adLabel.x = 0
        adLabel.y = lxLabel.frame.maxY + 9.uiX
        BGImageView.addSubview(adLabel)
        
        
        let fwButton = UIButton.init(frame: .zero)
        fwButton.setTitle("服务协议", for: .normal)
        fwButton.titleLabel?.font = .init(style: .medium, size: 12.uiX)
        fwButton.setTitleColor(.init(hex: "#87A7BF"), for: .normal)
        let fw = NSMutableAttributedString(string: "服务协议")
        fw.yy_setUnderlineStyle(.single, range: fw.yy_rangeOfAll())
        fwButton.titleLabel?.attributedText = fw
                
        fwButton.width = 50.uiX
        fwButton.height = 16.uiX
        fwButton.y = adLabel.frame.maxY + 15.uiX
        fwButton.x = 50.uiX
        BGImageView.addSubview(fwButton)
        
        self.fwButton = fwButton
        
        
        let ysButton = UIButton.init(frame: .zero)
        ysButton.setTitle("隐私政策", for: .normal)
        ysButton.titleLabel?.font = .init(style: .medium, size: 12.uiX)
        ysButton.setTitleColor(.init(hex: "#87A7BF"), for: .normal)
        let ys = NSMutableAttributedString(string: "隐私政策")
        ys.yy_setUnderlineStyle(.single, range: ys.yy_rangeOfAll())
        ysButton.titleLabel?.attributedText = ys
        
        ysButton.width = 50.uiX
        ysButton.height = 16.uiX
        ysButton.y = adLabel.frame.maxY + 15.uiX
        ysButton.x = fwButton.x + fwButton.width + 20.uiX
        BGImageView.addSubview(ysButton)
        
        self.ysButton = ysButton
        
        
        let zxButton = UIButton.init(frame: .zero)
        zxButton.setTitle("账号注销", for: .normal)
        zxButton.titleLabel?.font = .init(style: .medium, size: 12.uiX)
        zxButton.setTitleColor(.init(hex: "#87A7BF"), for: .normal)
        let zx = NSMutableAttributedString(string: "账号注销")
        zx.yy_setUnderlineStyle(.single, range: zx.yy_rangeOfAll())
        zxButton.titleLabel?.attributedText = zx
        
        zxButton.width = 50.uiX
        zxButton.height = 16.uiX
        zxButton.y = adLabel.frame.maxY + 15.uiX
        zxButton.x = ysButton.x + ysButton.width + 20.uiX
        BGImageView.addSubview(zxButton)
        self.zxButton = zxButton
    
        
        let versionLabel = UILabel.init()
        versionLabel.font = UIFont.init(style: .medium, size: 12.uiX)
        versionLabel.textColor = .init(hex: "#87A7BF")
        versionLabel.textAlignment = .right
        versionLabel.text = "v1.0.0"
        
        versionLabel.height = 12.uiX
        versionLabel.width = 50.uiX
        versionLabel.x = zxButton.x + zxButton.width
        versionLabel.y = zxButton.y + 2.uiX
        BGImageView.addSubview(versionLabel)
        
        
        let getCashImage = UIImage.init(named: "mine_img_frame02")!
        let getCashImageView = UIImageView()
        getCashImageView.image = getCashImage
        BGImageView.addSubview(getCashImageView)
        getCashImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(getCashImage.snpSize)
            make.top.equalToSuperview().offset(132.uiX)
        }
        
        let cashTitleLabel = UILabel.init()
        cashTitleLabel.font = UIFont.init(style: .medium, size: 14.uiX)
        cashTitleLabel.textColor = .init(hex: "#7A320D")
        cashTitleLabel.textAlignment = .left
        cashTitleLabel.text = "红包余额(元)"
        getCashImageView.addSubview(cashTitleLabel)
        cashTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15.uiX)
            make.width.equalTo(100.uiX)
            make.height.equalTo(14.uiX)
            make.top.equalToSuperview().offset(12.5.uiX)
        }
        
        let cashLabel = UILabel.init()
        cashLabel.font = UIFont.init(name: "DIN-Bold", size: 27.5.uiX)
        cashLabel.textColor = .init(hex: "#7A320D")
        cashLabel.textAlignment = .left
        let text = NSMutableAttributedString(string: "¥")
        text.yy_font = UIFont.init(name: "DIN-Bold", size: 17.5.uiX)
        text.yy_color = .init(hex: "#7A320D")
        let a = NSMutableAttributedString(string: "0")
        a.yy_font = UIFont.init(name: "DIN-Bold", size: 27.5.uiX)
        a.yy_color = .init(hex: "#7A320D")
        text.append(a)
        cashLabel.attributedText = text
        getCashImageView.addSubview(cashLabel)
        cashLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cashTitleLabel)
            make.width.equalTo(150.uiX)
            make.height.equalTo(24.uiX)
            make.top.equalTo(cashTitleLabel.snp_bottomMargin).offset(16.uiX)
        }
        self.cashLabel = cashLabel
        
        let getCashBtnImage = UIImage.init(named: "mine_img_btn")
        let getCashButton = UIButton.init(frame: .zero)
        getCashButton.setImage(getCashBtnImage, for: .normal)
        getCashImageView.addSubview(getCashButton)
        getCashButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-13.5.uiX)
            make.size.equalTo(getCashBtnImage!.snpSize)
            make.centerY.equalToSuperview()
        }
        self.getCashButton = getCashButton
        getCashImageView.isUserInteractionEnabled = true
        
        let inviteImage = UIImage.init(named: "mine_img_title_invite")!
        let inviteImageView = UIImageView()
        inviteImageView.image = inviteImage
        BGImageView.addSubview(inviteImageView)
        inviteImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(inviteImage.snpSize)
            make.top.equalTo(getCashImageView.snp_bottomMargin).offset(26.uiX)
        }
        
        let wxBtnImage = UIImage.init(named: "mine_img_vx")
        let wxButton = UIButton.init(frame: .zero)
        wxButton.setImage(wxBtnImage, for: .normal)
        BGImageView.addSubview(wxButton)
        wxButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100.uiX)
            make.size.equalTo(wxBtnImage!.snpSize)
            make.top.equalTo(inviteImageView.snp_bottomMargin).offset(19.uiX)
        }
        
        let qqBtnImage = UIImage.init(named: "mine_img_qq")
        let qqButton = UIButton.init(frame: .zero)
        qqButton.setImage(qqBtnImage, for: .normal)
        BGImageView.addSubview(qqButton)
        qqButton.snp.makeConstraints { (make) in
            make.left.equalTo(wxButton.snp_rightMargin).offset(68.uiX)
            make.size.equalTo(qqBtnImage!.snpSize)
            make.top.equalTo(wxButton)
        }
        
        let lineImage = UIImage.init(named: "mine_img_line")!
        let lineImageView = UIImageView()
        lineImageView.image = lineImage
        BGImageView.addSubview(lineImageView)
        lineImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(lineImage.snpSize)
            make.top.equalTo(wxButton.snp_bottomMargin).offset(19.uiX)
        }
        
        let lineImageView2 = UIImageView()
        lineImageView2.image = lineImage
        BGImageView.addSubview(lineImageView2)
        lineImageView2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(lineImage.snpSize)
            make.top.equalTo(wxButton.snp_bottomMargin).offset(78.5.uiX)
        }
        
        let soundLabel = UILabel.init()
        soundLabel.font = UIFont.init(name: "HYa9gj", size: 15.uiX)
        soundLabel.textColor = .init(hex: "#7A320D")
        soundLabel.textAlignment = .left
        soundLabel.text = "音效"
        getCashImageView.addSubview(soundLabel)
        soundLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(43.5.uiX)
            make.width.equalTo(32.uiX)
            make.height.equalTo(14.uiX)
            make.top.equalTo(lineImageView.snp_bottomMargin).offset(26.uiX)
        }
        
        let musicLabel = UILabel.init()
        musicLabel.font = UIFont.init(name: "HYa9gj", size: 15.uiX)
        musicLabel.textColor = .init(hex: "#7A320D")
        musicLabel.textAlignment = .left
        musicLabel.text = "音乐"
        getCashImageView.addSubview(musicLabel)
        musicLabel.snp.makeConstraints { (make) in
            make.left.equalTo(soundLabel.snp_rightMargin).offset(100.uiX)
            make.width.equalTo(32.uiX)
            make.height.equalTo(14.uiX)
            make.top.equalTo(soundLabel)
        }
        
        let soundImage = UIImage.init(named: "mine_img_open")
        let soundButton = UIButton.init(frame: .zero)
        soundButton.setImage(soundImage, for: .normal)
        BGImageView.addSubview(soundButton)
        soundButton.snp.makeConstraints { (make) in
            make.left.equalTo(soundLabel.snp_rightMargin).offset(9.uiX)
            make.size.equalTo(soundImage!.snpSize)
            make.centerY.equalTo(soundLabel)
        }
        
        let musicButton = UIButton.init(frame: .zero)
        musicButton.setImage(soundImage, for: .normal)
        BGImageView.addSubview(musicButton)
        musicButton.snp.makeConstraints { (make) in
            make.left.equalTo(musicLabel.snp_rightMargin).offset(9.uiX)
            make.size.equalTo(soundImage!.snpSize)
            make.centerY.equalTo(musicLabel)
        }
        
        let copyImage = UIImage.init(named: "mine_img_copy")
        let copyButton = UIButton.init(frame: .zero)
        copyButton.setImage(copyImage, for: .normal)
        BGImageView.addSubview(copyButton)
        copyButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-55.uiX)
            make.size.equalTo(copyImage!.snpSize)
            make.centerY.equalTo(adLabel)
        }
        copyButton.addTarget(self, action: #selector(copyEmail), for: .touchUpInside)
        
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let u = u else { return }
            self.changeUI(user : u)
        }).disposed(by: rx.disposeBag)
    }
    
    private func changeUI (user : UserModel) {
        self.nameLabel?.text = user.nickname
        let text = NSMutableAttributedString(string: "¥")
        text.yy_font = UIFont.init(name: "DIN-Bold", size: 17.5.uiX)
        text.yy_color = .init(hex: "#7A320D")
        let a = NSMutableAttributedString(string:user.redPacket)
        a.yy_font = UIFont.init(name: "DIN-Bold", size: 27.5.uiX)
        a.yy_color = .init(hex: "#7A320D")
        text.append(a)
        self.cashLabel?.attributedText = text
        self.userIDLabel?.text = "ID:\(user.id ?? "0")"
    }
    
    @objc func close () {
        
        if let sup = self.parentViewController as? PopView {
            sup.hide()
        }
    }
    
    @objc private func copyEmail () {
        let pastboard = UIPasteboard.general
        pastboard.string = self.adLabel?.text
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .text
        hud.label.text = "已复制到粘贴板"
        hud.bezelView.style = .solidColor
        hud.bezelView.color = .init(white: 0, alpha: 0.8)
        hud.contentColor = .white
        hud.hide(animated: true, afterDelay: 1.5)
    }
    

       
    
}
