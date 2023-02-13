//
//  HomeSettingView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/14.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeSettingView: UIView {
    
    let shareViewModel = ShareViewModel()
    
    var cashAction: (() -> ())?
    
    init() {
        
        let bgImg = UIImage.create("mine_img_frame")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 30.uiX)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.x = 0
        bgImgView.y = 30.uiX
        bgImgView.isUserInteractionEnabled = true
        addSubview(bgImgView)
        
        let closeImg = UIImage.create("task_img_close")
        let closeBtn = MusicButton()
        closeBtn.setImage(closeImg, for: .normal)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.size.equalTo(closeImg.snpSize)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-12.uiX)
        }
        closeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        let avatarBgView = UIView()
        let avatarFrontImg = UIImage.create("mine_img_user")
        let avatarfrontImgView = UIImageView(image: avatarFrontImg)
        avatarBgView.addSubview(avatarfrontImgView)
        avatarfrontImgView.snp.makeConstraints { make in
            make.size.equalTo(avatarFrontImg.snpSize)
            make.edges.equalToSuperview()
        }
        bgImgView.addSubview(avatarBgView)
        avatarBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30.uiX)
            make.top.equalToSuperview().offset(50.uiX)
        }
        
        let avatarImgView = UIImageView()
        avatarImgView.borderColor = .init(hex: "#582C06")
        avatarImgView.borderWidth = 1.5.uiX
        avatarImgView.cornerRadius = 51.5.uiX/2
        avatarBgView.insertSubview(avatarImgView, at: 0)
        avatarImgView.snp.makeConstraints { make in
            make.width.equalTo(51.5.uiX)
            make.height.equalTo(51.5.uiX)
            make.centerX.equalToSuperview().offset(2.3.uiX)
            make.centerY.equalToSuperview()
        }
        
        let nameLbl = UILabel()
        nameLbl.textColor = .init(hex: "#7A320D")
        nameLbl.font = .init(style: .bold, size: 16.uiX)
        nameLbl.text = "用户名"
        bgImgView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(avatarBgView.snp.right).offset(17.uiX)
            make.centerY.equalTo(avatarBgView).offset(-10.uiX)
        }
        
        let idLbl = UILabel()
        idLbl.textColor = .init(hex: "#B08260")
        idLbl.font = .init(style: .medium, size: 13.uiX)
        idLbl.text = "ID:0"
        bgImgView.addSubview(idLbl)
        idLbl.snp.makeConstraints { make in
            make.left.equalTo(avatarBgView.snp.right).offset(17.uiX)
            make.centerY.equalTo(avatarBgView).offset(10.uiX)
        }
        
        let copyImage = UIImage.create("mine_img_copy")
        let copyIdButton = MusicButton()
        copyIdButton.setImage(copyImage, for: .normal)
        bgImgView.addSubview(copyIdButton)
        copyIdButton.snp.makeConstraints { (make) in
            make.left.equalTo(idLbl.snp.right).offset(8.uiX)
            make.size.equalTo(copyImage.snpSize)
            make.centerY.equalTo(idLbl)
        }
        
        let cashBgImg = UIImage.create("mine_img_frame02")
        let cashBgImgView = UIImageView(image: cashBgImg)
        cashBgImgView.isUserInteractionEnabled = true
        bgImgView.addSubview(cashBgImgView)
        cashBgImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarBgView.snp.bottom).offset(16.uiX)
            make.size.equalTo(cashBgImg.snpSize)
        }
        
        let cashTitleLbl = UILabel()
        cashTitleLbl.font = UIFont.init(style: .bold, size: 14.uiX)
        cashTitleLbl.textColor = .init(hex: "#7A320D")
        cashTitleLbl.textAlignment = .left
        cashTitleLbl.text = "红包余额(元)"
        
        let cashLbl = UILabel()
        
        let cashStack = UIStackView(arrangedSubviews: [cashTitleLbl, cashLbl], axis: .vertical)
        cashStack.alignment = .leading
        cashStack.spacing = 5.uiX
        cashBgImgView.addSubview(cashStack)
        cashStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16.uiX)
        }
        
        let cashBtnImage = UIImage.create("mine_img_btn")
        let cashBtn = MusicButton()
        cashBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            MobClick.event("accountSettings_topCash")
            self.cashAction?()
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        cashBtn.setImage(cashBtnImage, for: .normal)
        cashBgImgView.addSubview(cashBtn)
        cashBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-14.uiX)
        }
        
        if UserManager.shared.isCheck {
            cashBgImgView.isHidden = true
        }
        
        let inviteImg = UIImage.create("mine_img_title_invite")
        let inviteImageView = UIImageView(image: inviteImg)
        bgImgView.addSubview(inviteImageView)
        inviteImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cashBgImgView.snp.bottom).offset(22.uiX)
            make.size.equalTo(inviteImg.snpSize)
        }
        
        let wxBtnImg = UIImage.create("mine_img_vx")
        let wxBtn = MusicButton()
        wxBtn.setImage(wxBtnImg, for: .normal)
        bgImgView.addSubview(wxBtn)
        wxBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inviteImageView.snp.bottom).offset(18.uiX)
        }
        wxBtn.rx.tap.subscribe(onNext: {
            MobClick.event("accountSettings_wechat")
        }).disposed(by: rx.disposeBag)
        
        let emailTitleLbl = UILabel()
        emailTitleLbl.font = UIFont.init(name: "HYa9gj", size: 14.uiX)
        emailTitleLbl.textColor = .init(hex: "#7A320D")
        emailTitleLbl.textAlignment = .center
        emailTitleLbl.text = "联系我们"
        bgImgView.addSubview(emailTitleLbl)
        emailTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(wxBtn.snp.bottom).offset(30.uiX)
        }
        
        let emailLbl = UILabel.init()
        emailLbl.font = UIFont.init(style: .medium, size: 14.uiX)
        emailLbl.textColor = .init(hex: "#B08260")
        emailLbl.text = "308179672@qq.com"
        bgImgView.addSubview(emailLbl)
        emailLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTitleLbl.snp.bottom).offset(7.uiX)
        }
        
        let copyEmailButton = MusicButton()
        copyEmailButton.setImage(copyImage, for: .normal)
        bgImgView.addSubview(copyEmailButton)
        copyEmailButton.snp.makeConstraints { (make) in
            make.left.equalTo(emailLbl.snp.right).offset(8.uiX)
            make.size.equalTo(copyImage.snpSize)
            make.centerY.equalTo(emailLbl)
        }
        
        let privacyBtn = MusicButton()
        let privacyAtt = NSMutableAttributedString(string: "隐私政策")
        privacyAtt.yy_underlineStyle = .single
        privacyAtt.yy_font = .init(style: .medium, size: 12.uiX)
        privacyAtt.yy_color = .init(hex: "#87A7BF")
        privacyBtn.setAttributedTitle(privacyAtt, for: .normal)
        privacyBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if let nav = self.parentViewController?.navigationController {
                let web = WebViewController()
                web.url = NetAPI.getHtmlProtocol(type: .privacy)
                nav.pushViewController(web)
            }
        }).disposed(by: rx.disposeBag)
        
        let serviceBtn = MusicButton()
        let serviceAtt = NSMutableAttributedString(string: "服务协议")
        serviceAtt.yy_underlineStyle = .single
        serviceAtt.yy_font = .init(style: .medium, size: 12.uiX)
        serviceAtt.yy_color = .init(hex: "#87A7BF")
        serviceBtn.setAttributedTitle(serviceAtt, for: .normal)
        serviceBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if let nav = self.parentViewController?.navigationController {
                let web = WebViewController()
                web.url = NetAPI.getHtmlProtocol(type: .user)
                nav.pushViewController(web)
            }
        }).disposed(by: rx.disposeBag)
        
        let versionLbl = UILabel()
        versionLbl.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        versionLbl.textColor = .init(hex: "#87A7BF")
        versionLbl.font = .init(style: .medium, size: 12.uiX)
        
        let protocolStack = UIStackView(arrangedSubviews: [serviceBtn, privacyBtn, versionLbl], axis: .horizontal)
        protocolStack.alignment = .center
        protocolStack.spacing = 20.uiX
        bgImgView.addSubview(protocolStack)
        protocolStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailLbl.snp.bottom).offset(18.uiX)
        }
        
        let shareInput = ShareViewModel.Input(share: wxBtn.rx.tap.asObservable())
        let shareOutput = shareViewModel.transform(input: shareInput)
        shareOutput.hud.bind(to: rx.toastText()).disposed(by: rx.disposeBag)
        shareViewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let u = u else { return }
            
            nameLbl.text = u.nickname
            
            avatarImgView.kf.setImage(with: URL(string: u.avatar))
            
            let text = NSMutableAttributedString(string: "¥")
            text.yy_font = UIFont.init(name: "DIN-Bold", size: 17.5.uiX)
            text.yy_color = .init(hex: "#7A320D")
            let a = NSMutableAttributedString(string:u.redPacket)
            a.yy_font = UIFont.init(name: "DIN-Bold", size: 27.5.uiX)
            a.yy_color = .init(hex: "#7A320D")
            text.append(a)
            cashLbl.attributedText = text
            idLbl.text = "ID:\(u.id ?? "0")"
            
            copyIdButton.rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let pastboard = UIPasteboard.general
                pastboard.string = u.id
                self.makeToast("已复制到粘贴板")
            }).disposed(by: self.rx.disposeBag)
            
            copyEmailButton.rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let pastboard = UIPasteboard.general
                pastboard.string = emailLbl.text
                self.makeToast("已复制到粘贴板")
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
    
}
