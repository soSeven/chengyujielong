//
//  GetCashSubView.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/16.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import YYText
import RxCocoa
import RxSwift

class GetCashHeaderSubView: UIView {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .medium, size: 13.uiX)
        lbl.textColor = .init(hex: "#7A310C")
        lbl.text = "去绑定"
        return lbl
    }()
    
    lazy var imgView: UIImageView = {
        return UIImageView(image: .create("cash_img_vx"))
    }()
    
    lazy var arrowImgView: UIImageView = {
        return UIImageView(image: UIImage.create("cash_img_arrow"))
    }()
    
    let btn = MusicButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImg = UIImage.create("cash_img_frame02")
        let bgImgView = UIImageView(image: bgImg)
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.size.equalTo(bgImg.snpSize)
            make.edges.equalToSuperview()
        }
        
        let lbl = UILabel()
        lbl.font = .init(style: .medium, size: 15.uiX)
        lbl.textColor = .init(hex: "#7A310C")
        lbl.text = "提现微信"
        
        addSubview(lbl)
        addSubview(imgView)
        addSubview(arrowImgView)
        
        lbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10.5.uiX)
        }
        
        arrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10.uiX)
            make.size.equalTo(arrowImgView.image!.snpSize)
        }
        
        imgView.contentMode = .scaleAspectFill
        imgView.cornerRadius = 12.5.uiX
        imgView.borderColor = .init(hex: "#572B05")
        imgView.borderWidth = 1.5.uiX
        imgView.snp.makeConstraints { make in
            make.width.equalTo(25.uiX)
            make.height.equalTo(25.uiX)
        }
        
        let s = UIStackView(arrangedSubviews: [imgView, titleLbl], axis: .horizontal, spacing: 6.uiX, alignment: .center, distribution: .equalSpacing)
        addSubview(s)
        s.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.arrowImgView.snp.left).offset(-2.5.uiX)
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

class GetCashInfoSubView: UIView {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .medium, size: 15.uiX)
        lbl.textColor = .init(hex: "#7A310C")
        lbl.text = "提现说明"
        return lbl
    }()
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        let text =
        """
        1.由于微信支付需要实名制，非实名用户账户无法支持提现，请务必将提现的微信号进行实名认证。
        2.提现申请将在3个工作日内审核，审核通过即可到账请耐心等待。
        3.每日只可申请提现一次，再次提现请于次日申请。
        4.新人专享福利每个账号仅可享受一次。
        5.更多提现详情请见《用户协议》。
        """
        let p = NSMutableParagraphStyle()
        p.lineSpacing = 2.uiX
        let att: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#AB774F"),
            .paragraphStyle: p
        ]
        lbl.attributedText = .init(string: text, attributes: att)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImg = UIImage.create("cash_img_frame05")
        let bgImgView = UIImageView(image: bgImg)
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.size.equalTo(bgImg.snpSize)
            make.edges.equalToSuperview()
        }
        
        addSubview(titleLbl)
        addSubview(textLbl)
        
        titleLbl.snp.makeConstraints { make in
            make.top.right.equalToSuperview().offset(13.uiX)
            make.left.equalToSuperview().offset(10.5.uiX)
        }
        
        textLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(10.uiX)
            make.left.equalToSuperview().offset(10.5.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GetCashLevelView: UIView {
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 12.uiX)
        lbl.textColor = .init(hex: "#AC784F")
        lbl.text = "猜成语即可提现！机会多多，金额不限！"
        return lbl
    }()
    
    lazy var levelLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .medium, size: 15.uiX)
        lbl.textColor = .init(hex: "#7A310C")
        return lbl
    }()
    
    private let progressBgView = UIView()
    let progressView = UIView()
    
    let btn = MusicButton()
    let helpBtn = MusicButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImg = UIImage.create("cash_img_frame03")
        let bgImgView = UIImageView(image: bgImg)
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.size.equalTo(bgImg.snpSize)
            make.edges.equalToSuperview()
        }
        
        addSubview(levelLbl)
        levelLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.uiX)
            make.left.equalToSuperview().offset(10.5.uiX)
        }
        
        progressBgView.borderColor = .init(hex: "#DA862D")
        progressBgView.borderWidth = 1.uiX
        addSubview(progressBgView)
        progressBgView.snp.makeConstraints { make in
            make.top.equalTo(levelLbl.snp.bottom).offset(12.uiX)
            make.left.equalToSuperview().offset(10.5.uiX)
            make.height.equalTo(8.uiX)
            make.width.equalTo(202.uiX)
        }
        
        addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.bottom.top.equalTo(progressBgView)
            make.width.equalTo(progressBgView).multipliedBy(0)
        }
        
        addSubview(textLbl)
        textLbl.snp.makeConstraints { make in
            make.top.equalTo(progressBgView.snp.bottom).offset(10.uiX)
            make.left.equalToSuperview().offset(10.5.uiX)
        }
        
        let btnImg = UIImage.create("cash_img_btn01")
        btn.setImage(btnImg, for: .normal)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(btnImg.snpSize)
            make.right.equalToSuperview().offset(-14.uiX)
        }
        
        let helpImg = UIImage.create("cash_img_mask")
        helpBtn.setImage(helpImg, for: .normal)
        addSubview(helpBtn)
        helpBtn.snp.makeConstraints { make in
            make.centerY.equalTo(levelLbl)
            make.left.equalTo(levelLbl.snp.right).offset(2.uiX)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleGradientLayer = [UIColor(hex: "#FDDF14"), UIColor(hex: "#E57C00")].gradient()
        titleGradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        titleGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        titleGradientLayer.frame = .init(x: 1.uiX, y: 1.uiX, width: progressView.width - 2.uiX, height: progressView.height - 2.uiX)
        progressView.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        progressView.layer.addSublayer(titleGradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProgress(_ progress: CGFloat) {
        progressView.snp.remakeConstraints { make in
            make.left.bottom.top.equalTo(progressBgView)
            make.width.equalTo(progressBgView).multipliedBy(progress)
        }
        progressView.isHidden = (progress == 0)
    }
    
}

class GetCashCardSubView: UIView {
    
    let btn = MusicButton()
    let pricelbl = UILabel()
    let timeLbl = UILabel()
    
    private let bgImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImg = UIImage.create("cash_img_limit")
        
        bgImgView.image = bgImg
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.size.equalTo(bgImg.snpSize)
            make.edges.equalToSuperview()
        }
        
        pricelbl.font = .init(style: .regular, size: 14.uiX)
        pricelbl.textColor = .init(hex: "#FF4444")

        addSubview(pricelbl)
        pricelbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14.uiX)
            make.top.equalToSuperview().offset(12.uiX)
        }

        timeLbl.font = .init(style: .medium, size: 13.uiX)
        timeLbl.textColor = .init(hex: "#BB5D0F")
        timeLbl.text = "00:00:00"

        let btnImg = UIImage.create("cash_img_limit_btn")
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.snp.makeConstraints { make in
            make.size.equalTo(btnImg.snpSize)
        }

        let s3 = UIStackView()
        s3.axis = .vertical
        s3.spacing = 5.uiX
        s3.alignment = .center
        s3.addArrangedSubviews([timeLbl, btn])
        addSubview(s3)
        s3.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10.5.uiX)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(cash: String, time: Int) {
        
        let h = time / 60 / 60
        let m = (time - (h * 60 * 60)) / 60
        let s = (time - (h * 60 * 60)) % 60
        
        timeLbl.text = String(format: "%.2d:%.2d:%.2d", h, m, s)
        
        if time > 0 {
            bgImgView.image = UIImage.create("cash_img_limit")
            timeLbl.textColor = .init(hex: "#BB5D0F")
            let btnImg = UIImage.create("cash_img_limit_btn")
            btn.setBackgroundImage(btnImg, for: .normal)
            btn.isUserInteractionEnabled = true
        } else {
            bgImgView.image = UIImage.create("cash_img_expired")
            timeLbl.textColor = .init(hex: "#7F7F7F")
            let btnImg = UIImage.create("cash_img_expired_btn")
            btn.setBackgroundImage(btnImg, for: .normal)
            btn.isUserInteractionEnabled = false
        }
        pricelbl.attributedText = getTimeCashStr(num: cash, enable: time > 0)
    }
    
    private func getTimeCashStr(num: String, enable: Bool) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .bold, size: 12.uiX),
            .foregroundColor: UIColor(hex: enable ? "#E53A1E" : "#898989")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 30.uiX)!,
            .foregroundColor: UIColor(hex: enable ? "#E53A1E" : "#898989")
        ]
        let s = NSAttributedString(string: "元", attributes: a1)
        let s2 = NSMutableAttributedString(string: num, attributes: a2)
        s2.append(s)
        return s2
    }
}

class GetCashMoneySubView: UIView {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .medium, size: 16.uiX)
        lbl.textColor = .init(hex: "#333333")
        lbl.text = "我的钱包"
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImg = UIImage.create("cash_img_frame01")
        let bgImgView = UIImageView(image: bgImg)
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.size.equalTo(bgImg.snpSize)
            make.edges.equalToSuperview()
        }
        
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 15.uiX)
        lbl.textColor = .init(hex: "#AB774F")
        lbl.text = "可提现余额(元)"
        
        addSubview(titleLbl)
        addSubview(lbl)
        
        let s = UIStackView(arrangedSubviews: [titleLbl, lbl], axis: .vertical, spacing: 5.uiX, alignment: .center, distribution: .equalCentering)
        addSubview(s)
        s.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GetCashMoneyItemSubView: UIView {
    
    enum MoneyItemType {
        case cash
        case coin
    }
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 13.uiX)
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.text = "可提现金额"
        return lbl
    }()
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    lazy var levelLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 13.uiX)
        lbl.textColor = .init(hex: "#4D4D4D")
        lbl.text = ""
        return lbl
    }()
    
    private var lightImgView: UIView?
    private var cashMarkImgView: UIView?
    private let progressView = UIView()
    let btn = UIButton()
    
    let type: MoneyItemType
    
    init(type: MoneyItemType) {
        
        self.type = type
        
        super.init(frame: .zero)
        
        let pBgView = UIView()
        pBgView.cornerRadius = 3.uiX
        pBgView.backgroundColor = .init(hex: "#FFC695")
        
        progressView.backgroundColor = .init(hex: "#FF491F")
        
        let imgView1 = UIImageView(image: .create(type == .cash ? "tx-wdqb-yebg" : "tx-jb-bg"))
        
        titleLbl.text = type == .cash ? "可提现金额" : "我的金币"
        
        addSubview(imgView1)
        addSubview(titleLbl)
        addSubview(textLbl)
        addSubview(levelLbl)
        addSubview(pBgView)
        
        pBgView.addSubview(progressView)
        
        imgView1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25.uiX)
        }
        
        textLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(45.uiX)
        }
        
        levelLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13.uiX)
            make.bottom.equalToSuperview().offset(-33.uiX)
        }
        
        pBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13.uiX)
            make.bottom.equalToSuperview().offset(-18.uiX)
            make.width.equalTo(260.uiX)
            make.height.equalTo(6.uiX)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0)
        }
        
        switch type {
        case .cash:
            
            let lightImgView = UIImageView(image: .create("tx-gx-icon"))
            addSubview(lightImgView)
            
            let redBagImgView = UIImageView(image: .create("tx-lh-icon"))
            addSubview(redBagImgView)
            
            let cashMarkImg = UIImage.create("tx-ktx-icon")
            let cashMarkImgView = UIButton()
            cashMarkImgView.setBackgroundImage(cashMarkImg, for: .normal)
            cashMarkImgView.titleLabel?.font = .init(style: .regular, size: 9.uiX)
            cashMarkImgView.setTitleColor(.white, for: .normal)
            cashMarkImgView.setTitle("可提现", for: .normal)
            cashMarkImgView.isUserInteractionEnabled = false
            addSubview(cashMarkImgView)
            
            redBagImgView.snp.makeConstraints { make in
                make.bottom.equalTo(pBgView.snp.bottom)
                make.centerX.equalTo(pBgView.snp.right)
                make.size.equalTo(redBagImgView.image!.snpSize)
            }
            
            redBagImgView.isUserInteractionEnabled = true
            redBagImgView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            cashMarkImgView.snp.makeConstraints { make in
                make.centerX.equalTo(redBagImgView)
                make.top.equalTo(redBagImgView.snp.bottom).offset(2.uiX)
            }
            
            lightImgView.snp.makeConstraints { make in
                make.size.equalTo(lightImgView.image!.snpSize)
                make.center.equalTo(redBagImgView)
            }
            
            lightImgView.isHidden = true
            cashMarkImgView.isHidden = true
            
            self.lightImgView = lightImgView
            self.cashMarkImgView = cashMarkImgView
            
        case .coin:
            let redBagImgView = UIImageView(image: .create("tx-jbye-hb-icon"))
            addSubview(redBagImgView)
            redBagImgView.snp.makeConstraints { make in
                make.bottom.equalTo(pBgView.snp.bottom)
                make.centerX.equalTo(pBgView.snp.right)
                make.size.equalTo(redBagImgView.image!.snpSize)
            }
            
            redBagImgView.isUserInteractionEnabled = true
            redBagImgView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        setupGetCash(enable: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(progress: CGFloat) {
        switch type {
        case .cash:
            progressView.snp.remakeConstraints { make in
                make.left.bottom.top.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(progress)
            }
            
        case .coin:
            progressView.snp.remakeConstraints { make in
                make.left.bottom.top.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(progress)
            }
        }
    }
    
    func setupGetCash(enable: Bool) {
        if enable {
            lightImgView?.isHidden = false
            cashMarkImgView?.isHidden = false
            lightImgView?.layer.removeAllAnimations()
            let ro = CABasicAnimation(keyPath: "transform.rotation.z")
            ro.toValue = Double.pi*2.0
            ro.duration = 5
            ro.repeatCount = HUGE
            ro.isRemovedOnCompletion = true
            ro.fillMode = .forwards
            lightImgView?.layer.add(ro, forKey: "rotationAnimation")
            btn.isUserInteractionEnabled = true
        } else {
            lightImgView?.isHidden = true
            cashMarkImgView?.isHidden = true
            lightImgView?.layer.removeAllAnimations()
            btn.isUserInteractionEnabled = false
        }
    }
    
    
}

class GetCashPriceSubView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 158.5.uiX, height: 47.5.uiX)
        layout.minimumLineSpacing = 7.5.uiX
        layout.minimumInteritemSpacing = 2.5.uiX
        layout.sectionInset = .init(top: 0, left: 9.5.uiX, bottom: 0, right: 9.5.uiX)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(cellType: PayListCell.self)
        
        return collectionView
    }()
    
    var isAgreeProtocol = true
    var protocolAction: (()->())?
    var cashAction: (()->())?
    
    let timeCardView = GetCashCardSubView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImg = UIImage.create("cash_img_frame04")
        let bgImgView = UIImageView(image: bgImg)
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(bgImg.snpSize.width)
        }
        
        let pBtn = MusicButton()
        pBtn.setImage(.create("cash_img_choose_nor"), for: .normal)
        pBtn.setImage(.create("cash_img_choose"), for: .selected)
        pBtn.isSelected = isAgreeProtocol
        pBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.isAgreeProtocol = !self.isAgreeProtocol
            pBtn.isSelected = self.isAgreeProtocol
        }).disposed(by: rx.disposeBag)
        
        let text = NSMutableAttributedString(string: "已阅读并同意")
        text.yy_font = .init(style: .regular, size: 14.uiX)
        text.yy_color = .init(hex: "#AB774F")
        let a = NSMutableAttributedString(string: "《用户结算协议》")
        a.yy_font = .init(style: .regular, size: 14.uiX)
        a.yy_color = .init(hex: "#7A310C")
        let hi = YYTextHighlight()
        hi.tapAction =  { [weak self] containerView, text, range, rect in
            guard let self = self else { return }
            self.protocolAction?()
        }
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        text.append(a)
        let protocolLbl = YYLabel()
        protocolLbl.attributedText = text
        
        addSubview(protocolLbl)
        addSubview(pBtn)
        protocolLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32.uiX)
        }
        
        pBtn.snp.makeConstraints { make in
            make.centerY.equalTo(protocolLbl)
            make.right.equalTo(protocolLbl.snp.left).offset(-6.uiX)
        }
        
        let btnImg = UIImage.create("cash_img_btn02")
        let cashBtn = MusicButton()
        cashBtn.setBackgroundImage(btnImg, for: .normal)
        cashBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.cashAction?()
        }).disposed(by: rx.disposeBag)
        addSubview(cashBtn)
        cashBtn.snp.makeConstraints { make in
            make.bottom.equalTo(protocolLbl.snp.top).offset(-16.uiX)
            make.centerX.equalToSuperview()
            make.size.equalTo(btnImg.snpSize)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(cashBtn.snp.top).offset(-20.uiX)
            make.height.equalTo(105.uiX)
        }
        
        let lbl = UILabel()
        lbl.font = .init(style: .medium, size: 15.uiX)
        lbl.textColor = .init(hex: "#7A310C")
        lbl.text = "微信提现"
        addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.right.equalToSuperview().offset(13.uiX)
            make.left.equalToSuperview().offset(10.5.uiX)
        }
        
        addSubview(timeCardView)
        timeCardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(49.5.uiX)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(395.uiX)
        }
        
    }
    
    func setupTimeCard(cash: String, time: Int, isHidden: Bool) {
        
        if isHidden {
            timeCardView.isHidden = true
            snp.updateConstraints { make in
                make.height.equalTo(285.uiX)
            }
        } else {
            timeCardView.isHidden = false
            snp.updateConstraints { make in
                make.height.equalTo(395.uiX)
            }
        }
        
        timeCardView.setup(cash: cash, time: time)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


