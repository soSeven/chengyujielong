//
//  AuthPopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/20.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import YYText

class AuthPopView: UIView {
    
    init(action: @escaping ()->()) {
        
        let bgImg = UIImage.create("home_privacy_img_frame")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = bounds
        addSubview(bgImgView)
        
        let text = NSMutableAttributedString(string: "欢迎进入成语大神！我们非常重视您的个人信息和隐私保护。为了更好地保障您的个人权益，在您使用我们的产品前，请认真阅读")
        text.yy_font = .init(style: .regular, size: 13.uiX)
        text.yy_color = .init(hex: "#7A320D")
        let a = NSMutableAttributedString(string: "《用户服务协议》")
        a.yy_font = .init(style: .regular, size: 13.uiX)
        a.yy_color = .init(hex: "#E53A1E")
        let hi = YYTextHighlight()
        hi.tapAction =  {[weak self] containerView, text, range, rect in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView, let nav = sup.navigationController {
                let web = WebViewController()
                web.url = NetAPI.getHtmlProtocol(type: .user)
                nav.pushViewController(web)
            }
        }
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        text.append(a)
        let b = NSMutableAttributedString(string: "与")
        b.yy_font = .init(style: .regular, size: 13.uiX)
        b.yy_color = .init(hex: "#7A320D")
        text.append(b)
        let d = NSMutableAttributedString(string: "《隐私政策》")
        d.yy_font = .init(style: .regular, size: 13.uiX)
        d.yy_color = .init(hex: "#E53A1E")
        let hid = YYTextHighlight()
        hid.tapAction =  {[weak self] containerView, text, range, rect in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView, let nav = sup.navigationController {
                let web = WebViewController()
                web.url = NetAPI.getHtmlProtocol(type: .privacy)
                nav.pushViewController(web)
            }
        }
        d.yy_setTextHighlight(hid, range: d.yy_rangeOfAll())
        text.append(d)
        let e = NSMutableAttributedString(string: "的全部内容，点击同意并接受全部条款后开始使用我们的产品和服务。")
        e.yy_font = .init(style: .regular, size: 13.uiX)
        e.yy_color = .init(hex: "#7A320D")
        text.append(e)
        
        let textLbl1 = YYLabel()
        textLbl1.font = .init(style: .regular, size: 13.uiX)
        textLbl1.textColor = .init(hex: "#7A320D")
        textLbl1.attributedText = text
        textLbl1.frame = CGRect(x: 35.uiX, y: 58.uiX, width: 235.uiX, height: 120.uiX)
        textLbl1.numberOfLines = 0
        addSubview(textLbl1)
        
        let img = UIImage.create("home_privacy_img_save")
        let markImgView = UIImageView(image: img)
        markImgView.size = img.snpSize
        markImgView.x = 35.uiX
        markImgView.y = 200.uiX
        addSubview(markImgView)
        
        let tLbl1 = UILabel()
        tLbl1.text = "存储空间、设备信息"
        tLbl1.textColor = .init(hex: "#7A320D")
        tLbl1.font = .init(style: .medium, size: 15.uiX)
        tLbl1.x = markImgView.frame.maxX + 12.uiX
        tLbl1.y = 200.uiX
        tLbl1.width = 200.uiX
        tLbl1.height = 14.5.uiX
        addSubview(tLbl1)
        
        let tLbl2 = UILabel()
        tLbl2.textColor = .init(hex: "#7A320D")
        tLbl2.text = "必要权限，用于缓存相关文件"
        tLbl2.font = .init(style: .regular, size: 13.uiX)
        tLbl2.x = markImgView.frame.maxX + 12.uiX
        tLbl2.y = 220.5.uiX
        tLbl2.width = 200.uiX
        tLbl2.height = 13.uiX
        addSubview(tLbl2)
        
        let btnImg = UIImage.create("home_privacy_img_btn")
        let btn = UIButton()
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.size = btnImg.snpSize
        btn.y = 257.5.uiX
        btn.x = (width - btn.width)/2.0
        btn.rx.tap.subscribe(onNext: { _ in
            if let sup = self.parentViewController as? PopView {
                sup.hide(completion: action)
            }
            MobClick.event("Main_PermissionsGranted")
        }).disposed(by: rx.disposeBag)
        addSubview(btn)
        
        let nextbtn = UIButton()
        nextbtn.titleLabel?.font = .init(style: .regular, size: 13.uiX)
        nextbtn.setTitle("不同意并退出", for: .normal)
        nextbtn.setTitleColor(.init(hex: "#CDA77F"), for: .normal)
        nextbtn.width = 90.uiX
        nextbtn.height = 15.uiX
        nextbtn.y = 10.uiX + btn.frame.maxY
        nextbtn.x = (width - nextbtn.width)/2.0
        nextbtn.rx.tap.subscribe(onNext: {_ in
            MobClick.event("Main_PermissionsDenied")
            exit(0)
        }).disposed(by: rx.disposeBag)
        addSubview(nextbtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
