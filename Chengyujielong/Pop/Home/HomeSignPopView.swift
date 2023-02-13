//
//  HomeSignPopView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/15.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit
import KTCenterFlowLayout
import RxSwift
import RxCocoa
import YYText

class HomeSignPopView: UIView {
    
    let viewModel =  SignViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = KTCenterFlowLayout()
        layout.estimatedItemSize = .init(width: 100.uiX, height: 100.uiX)
//        layout.itemSize =
        layout.minimumLineSpacing = 8.uiX
        layout.minimumInteritemSpacing = 8.uiX
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(cellType: SignPopCell.self)
        
        return collectionView
    }()
    
    init() {
        
        let bgImg = UIImage.create("sign_img_frame01")
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
        
        let signLabel = UILabel()
        signLabel.textAlignment = .left
        signLabel.textColor = .init(hex: "#7A310C")
        signLabel.font = UIFont.init(name: "HYa9gj", size: 16.uiX)
        signLabel.text = "登录奖励"
        bgImgView.addSubview(signLabel)
        signLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(34.uiX)
            make.top.equalToSuperview().offset(74.uiX)
        }
        
        let getSignButton = MusicButton()
        let getSignImage = UIImage.init(named: "sign_img_btn01")!
        getSignButton.setBackgroundImage(getSignImage, for: .normal)
        bgImgView.addSubview(getSignButton)
        getSignButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-32.uiX)
            make.centerY.equalTo(signLabel)
            make.size.equalTo(getSignImage.snpSize)
        }
        
        let getSignDisableView = UIView()
        let getSignDisableImage = UIImage.init(named: "sign_img_btn02")!
        let getSignDisableImgView = UIImageView(image: getSignDisableImage)
        let getSignDisableLbl = YYLabel()
        getSignDisableLbl.textAlignment = .center
        bgImgView.addSubview(getSignDisableView)
        getSignDisableView.addSubview(getSignDisableImgView)
        getSignDisableView.addSubview(getSignDisableLbl)
        getSignDisableImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(getSignDisableImage.snpSize.height)
        }
        getSignDisableLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10.uiX)
            make.right.equalToSuperview().offset(-10.uiX)
        }
        getSignDisableView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-32.uiX)
            make.centerY.equalTo(signLabel)
        }
        
        bgImgView.addSubview(collectionView)
        collectionView.width = 300.uiX
        collectionView.x = (width - collectionView.width)/2.0
        collectionView.y = 118.uiX
        collectionView.height = 200.uiX
        
        let onlineLabel = UILabel()
        onlineLabel.textAlignment = .left
        onlineLabel.textColor = .init(hex: "#7A310C")
        onlineLabel.font = UIFont.init(name: "HYa9gj", size: 16.uiX)
        onlineLabel.text = "在线奖励"
        bgImgView.addSubview(onlineLabel)
        onlineLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(34.uiX)
            make.top.equalToSuperview().offset(330.uiX)
        }
        
        let onlineButton = MusicButton()
        let onlinenImage = UIImage.init(named: "sign_img_btn01")!
        onlineButton.setBackgroundImage(onlinenImage, for: .normal)
        bgImgView.addSubview(onlineButton)
        onlineButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-32.uiX)
            make.centerY.equalTo(onlineLabel)
            make.size.equalTo(onlinenImage.snpSize)
        }
        
        let onlineDisableButton = MusicButton()
        let onlineDisableImage = UIImage.init(named: "sign_img_btn02")!
        onlineDisableButton.setBackgroundImage(onlineDisableImage, for: .normal)
        bgImgView.addSubview(onlineDisableButton)
        onlineDisableButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-32.uiX)
            make.centerY.equalTo(onlineLabel)
            make.size.equalTo(onlineDisableImage.snpSize)
        }
        onlineDisableButton.isUserInteractionEnabled = false
        
        let onlineBgView = UIView()
        onlineBgView.width = 281.uiX
        onlineBgView.x = (width - onlineBgView.width)/2.0
        onlineBgView.y = 375.uiX
        onlineBgView.height = 70.uiX
        bgImgView.addSubview(onlineBgView)
        
        let onlineRequest = PublishRelay<OnlineRewardCellViewModel>()
        let signRequest = PublishRelay<SignReward>()
        
        let input = SignViewModel.Input(clickOnline: onlineButton.rx.tap.asObservable(), requestOnline: onlineRequest.asObservable(), clickSign: getSignButton.rx.tap.asObservable(), requestSign: signRequest.asObservable())
        let output = viewModel.transform(input: input)
        
        output.list.bind(to: collectionView.rx.items(cellIdentifier: SignPopCell.reuseIdentifier, cellType: SignPopCell.self)) { (row, element, cell) in
            cell.bind(to: element, index: row)
        }.disposed(by: rx.disposeBag)
        
        output.signBtnState.subscribe(onNext: { (state, nextModel) in
            
            if state == 0 {
                getSignButton.isHidden = false
                getSignDisableView.isHidden = true
            } else {
                getSignButton.isHidden = true
                getSignDisableView.isHidden = false
                if let next = nextModel {
                    let attrString = NSMutableAttributedString(string: "明天领 ")
                    let attr: [NSAttributedString.Key : Any] = [
                        .font: UIFont(style: .regular, size: 13.uiX),
                        .foregroundColor: UIColor(hex: "#E8E7E6")]
                    attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
                    
                    let img = UIImage.create(next.type == 1 ? "sign_login_honbao" : "sign_login_coin")
                    let imgAtt = NSMutableAttributedString.yy_attachmentString(withContent: img, contentMode: .center, attachmentSize: img.size, alignTo: UIFont(style: .regular, size: 13.uiX), alignment: .center)
                    attrString.append(imgAtt)
                    
                    let n = NumberFormatter()
                    n.maximumFractionDigits = 2
                    n.minimumFractionDigits = 0
                    let s = n.string(from: NSNumber(value: next.number)) ?? "0"
                    let numberAtt = NSMutableAttributedString(string: next.type == 1 ? " +\(s)元" : " +\(s)")
                    numberAtt.yy_color = .init(hex: "#7A310C")
                    numberAtt.yy_font = UIFont.init(name: "DIN-Bold", size: 12.5.uiX)
                    attrString.append(numberAtt)
                    
                    getSignDisableLbl.attributedText = attrString
                } else {
                    let attrString = NSMutableAttributedString(string: "明天继续领取")
                    let attr: [NSAttributedString.Key : Any] = [
                        .font: UIFont(style: .regular, size: 13.uiX),
                        .foregroundColor: UIColor(hex: "#E8E7E6")]
                    attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
                    attrString.yy_alignment = .center
                    getSignDisableLbl.attributedText = attrString
                }
            }
        }).disposed(by: rx.disposeBag)
        
        output.signClick.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
//            if m.watchVideos > 0 {
//                if let sup = self.parentViewController {
//                    let ad = RewardVideoSingleAd.shared
//                    ad.showAd(vc: sup)
//                    ad.completion = {
//                        signRequest.accept(m)
//                    }
//                    ad.failure = {
//                        signRequest.accept(m)
//                    }
//                }
//            } else {
                signRequest.accept(m)
//            }
        }).disposed(by: rx.disposeBag)
        
        output.signSuccess.subscribe(onNext: {[weak self] s in
            guard let self = self else { return }
            self.collectionView.reloadData()
            let view = HomeSignAwardView.init(frame: UIScreen.main.bounds)
            view.model = s
            PopView.show(view: view)
        }).disposed(by: rx.disposeBag)
        
        output.onlineList.subscribe(onNext: { models in
            onlineBgView.removeSubviews()
            for (i, model) in models.enumerated() {
                let item = HomeSignOnlineItem(frame: .init(x: 79.uiX * CGFloat(i), y: 0, width: 44.uiX, height: 70.uiX), model: model, isFirst: i == 0)
                onlineBgView.insertSubview(item, at: 0)
            }
        }).disposed(by: rx.disposeBag)
        
        output.onlineClick.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
//            if m.watchVideos > 0 {
//                if let sup = self.parentViewController {
//                    let ad = RewardVideoSingleAd.shared
//                    ad.showAd(vc: sup)
//                    ad.completion = {
//                        onlineRequest.accept(m)
//                    }
//                    ad.failure = {
//                        onlineRequest.accept(m)
//                    }
//                }
//            } else {
                onlineRequest.accept(m)
//            }
        }).disposed(by: rx.disposeBag)
        
        output.onlineSuccess.subscribe(onNext: { s in
            
            let view = HomeOnlineSignRewardView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            view.model = s
            PopView.show(view:view)
            
        }).disposed(by: rx.disposeBag)
        
        output.onlineBtnState.subscribe(onNext: { (state, time) in
            switch state {
            case 1:
                onlineButton.isHidden = false
                onlineDisableButton.isHidden = true
            case 2:
                onlineButton.isHidden = true
                onlineDisableButton.isHidden = false
                let m = time / 60
                let s = time % 60
                let timeStr = String(format: "%.2d:%.2d", m, s)
                let attrString = NSMutableAttributedString(string: "\(timeStr)后可领取")
                let attr: [NSAttributedString.Key : Any] = [
                    .font: UIFont(style: .regular, size: 13.uiX),
                    .foregroundColor: UIColor(hex: "#E8E7E6")]
                attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
                onlineDisableButton.setAttributedTitle(attrString, for: .normal)
            default:
                onlineButton.isHidden = true
                onlineDisableButton.isHidden = true
            }
            
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self)")
    }
}

class HomeSignOnlineItem: UIView {
    
    init(frame: CGRect, model: OnlineRewardCellViewModel, isFirst: Bool) {
        super.init(frame: frame)
        
        let circleBgView = UIView()
        circleBgView.borderColor = .init(hex: "#582C06")
        circleBgView.borderWidth = 1.5.uiX
        circleBgView.cornerRadius = 22.uiX
        circleBgView.backgroundColor = .init(hex: "#F9DAA8")
        addSubview(circleBgView)
        circleBgView.snp.makeConstraints { make in
            make.width.equalTo(44.uiX)
            make.height.equalTo(44.uiX)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        let progressBgView = UIView()
        progressBgView.borderColor = .init(hex: "#582C06")
        progressBgView.borderWidth = 1.5.uiX
        progressBgView.backgroundColor = .init(hex: "#F9DAA8")
        insertSubview(progressBgView, at: 0)
        progressBgView.snp.makeConstraints { make in
            make.right.equalTo(circleBgView.snp.centerX)
            make.centerY.equalTo(circleBgView)
            make.width.equalTo(60.uiX)
            make.height.equalTo(11.uiX)
        }
        progressBgView.isHidden = isFirst
        
        let progressView = UIView(frame: .init(x: 1.5.uiX, y: 1.5.uiX, width: 57.uiX, height: 8.uiX))
        let titleGradientLayer = [UIColor(hex: "#F9DC5B"), UIColor(hex: "#F2AA48")].gradient()
        titleGradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        titleGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        titleGradientLayer.frame = progressView.frame
        progressView.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        progressView.layer.addSublayer(titleGradientLayer)
        progressBgView.addSubview(progressView)
        
        let timeLbl = UILabel()
        timeLbl.text = "\(model.duration ?? 0)分钟"
        timeLbl.textColor = .init(hex: "#7A310C")
        timeLbl.font = .init(style: .medium, size: 11.uiX)
        addSubview(timeLbl)
        timeLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(circleBgView.snp.bottom).offset(7.uiX)
        }
        
        let yellowPopImg = UIImage.create("sign_online_img01")
        let yellowPopImgView = UIImageView(image: yellowPopImg)
        addSubview(yellowPopImgView)
        yellowPopImgView.snp.makeConstraints { make in
            make.center.equalTo(circleBgView)
            make.size.equalTo(yellowPopImg.snpSize)
        }
        
        let cashLbl = UILabel()
        cashLbl.textColor = .init(hex: "#B08260")
        cashLbl.text = "+\(model.number ?? "0")"
        cashLbl.font = UIFont.init(name: "DIN-Bold", size: 11.uiX)
        
        var cashImg: UIImage
        if model.type == 1 {
            cashImg = UIImage.create("sign_online_hongbao")
        } else {
            cashImg = UIImage.create("sign_online_coin")
        }
        
        let cashImgView = UIImageView(image: cashImg)
        cashImgView.snp.makeConstraints { make in
            make.size.equalTo(cashImg.snpSize)
        }
        
        let s = UIStackView(arrangedSubviews: [cashImgView, cashLbl], axis: .vertical)
        s.alignment = .center
        s.spacing = -2.uiX
        addSubview(s)
        s.snp.makeConstraints { make in
            make.center.equalTo(circleBgView)
        }
        
        let markImg = UIImage.create("sign_online_choose")
        let markImgView = UIImageView(image: markImg)
        addSubview(markImgView)
        markImgView.snp.makeConstraints { make in
            make.centerX.equalTo(yellowPopImgView)
            make.bottom.equalTo(yellowPopImgView.snp.bottom).offset(2.uiX)
        }
        
        Observable.combineLatest(model.hasReceive.asObservable(), model.canReceive.asObservable()).subscribe(onNext: { (hasReceive, canReceive) in
            if hasReceive > 0 {
                timeLbl.textColor = .init(hex: "#BC927D")
                timeLbl.text = "已领取"
                yellowPopImgView.isHidden = false
                cashLbl.textColor = .init(hex: "#7A310C")
                circleBgView.isHidden = true
                progressView.isHidden = false
                markImgView.isHidden = false
            } else {
                timeLbl.textColor = .init(hex: "#7A310C")
                markImgView.isHidden = true
                if canReceive > 0 {
                    timeLbl.text = "可领取"
                    yellowPopImgView.isHidden = false
                    cashLbl.textColor = .init(hex: "#7A310C")
                    circleBgView.isHidden = true
                    progressView.isHidden = false
                } else {
                    timeLbl.text = "\(model.duration ?? 0)分钟"
                    yellowPopImgView.isHidden = true
                    cashLbl.textColor = .init(hex: "#B08260")
                    circleBgView.isHidden = false
                    progressView.isHidden = true
                }
            }
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
