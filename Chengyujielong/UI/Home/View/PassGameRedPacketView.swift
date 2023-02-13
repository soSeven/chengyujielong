//
//  PassGameRedPacketView.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/27.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import YYText
import RxSwift

enum PassGameRedPacketViewType {
    case noAD
    case haveDoubleAD
    case hadWatchAD
}

class PassGameRedPacketView: UIView {
    
    private var checkpoint : Int?
    private var video : Int = 0
    private var rangeModel: ConfigureCheckpointReward?
    private var redPacket : Float?
    private var doubleLabel : UILabel?
    private var sumLabel : UILabel?
    private var doubleButton : UIButton?
    private var sureButton : UIButton?
    private var nextLabel : UILabel?
    weak var delegate: HomeViewController?
    var type:PassGameRedPacketViewType? {
        didSet {
            switch type {
            case .noAD:
                self.doubleButton?.isHidden = true
                self.sureButton?.isHidden = false
                self.nextLabel?.isHidden = true
                break
            case .haveDoubleAD:
                
                break
            case .hadWatchAD:
                self.doubleButton?.isHidden = true
                self.doubleLabel?.isHidden = false
                self.nextLabel?.isHidden = true
                self.sureButton?.isHidden = false
                self.doubleLabel?.height = 13.uiX
                break
            default:
                break
            }
            
        }
    }
    
    override init(frame: CGRect)  {
        let newFrame = CGRect.init(x: 0, y: 0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
        super.init(frame: newFrame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
  
        let RedPacketImage = UIImage.init(named: "reward_img01")!
        let RedPacketImageView = UIImageView()
        RedPacketImageView.image = RedPacketImage
        addSubview(RedPacketImageView)
        RedPacketImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100.uiX+UIDevice.statusBarHeight)
            make.size.equalTo(RedPacketImage.snpSize)
        }
        
        let ligntImage = UIImage.init(named: "img_lignt_all")!
        let ligntImageView = UIImageView()
        ligntImageView.image = ligntImage
        insertSubview(ligntImageView, belowSubview: RedPacketImageView)
        ligntImageView.snp.makeConstraints { (make) in
            make.center.equalTo(RedPacketImageView)
            make.size.equalTo(ligntImage.snpSize)
        }
        let ro = CABasicAnimation(keyPath: "transform.rotation.z")
        ro.toValue = Double.pi*2.0
        ro.duration = 5
        ro.repeatCount = HUGE
        ro.isRemovedOnCompletion = true
        ro.fillMode = .forwards
        ligntImageView.layer.add(ro, forKey: "rotationAnimation")
        
        let doubleLabel = UILabel.init()
        doubleLabel.font = UIFont.init(style: .regular, size: 13.uiX)
        doubleLabel.textColor = .init(hex: "#FFDEB0")
        doubleLabel.textAlignment = .center
        doubleLabel.text = "获得双倍奖励"
        addSubview(doubleLabel)
        doubleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(13.uiX)
            make.top.equalTo(RedPacketImageView.snp_bottomMargin).offset(37.uiX)
        }
        self.doubleLabel = doubleLabel
        doubleLabel.isHidden = true
        
        let sumLabel = UILabel.init()
        sumLabel.font = UIFont.init(style: .regular, size: 22.uiX)
        sumLabel.textColor = .init(hex: "#F6D938")
        sumLabel.textAlignment = .center
        sumLabel.text = "+0.5元"
        addSubview(sumLabel)
        sumLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(20.uiX)
            make.top.equalTo(doubleLabel.snp_bottomMargin).offset(19.uiX)
        }
        self.sumLabel = sumLabel
        
        let doubleImage = UIImage.init(named: "reward_img_btn_double")
        let doubleButton = UIButton.init(frame: .zero)
        doubleButton.setImage(doubleImage, for: .normal)
        addSubview(doubleButton)
        doubleButton.snp.makeConstraints { (make) in
            make.top.equalTo(sumLabel.snp_bottomMargin).offset(25.uiX)
            make.size.equalTo(doubleImage!.snpSize)
            make.centerX.equalToSuperview()
        }
        self.doubleButton = doubleButton
        
        let sureImage = UIImage.init(named: "reward_img_btn")
        let sureButton = UIButton.init(frame: .zero)
        sureButton.setImage(sureImage, for: .normal)
        addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) in
            make.top.equalTo(sumLabel.snp_bottomMargin).offset(32.uiX)
            make.size.equalTo(sureImage!.snpSize)
            make.centerX.equalToSuperview()
        }
        self.sureButton = sureButton
        sureButton.isHidden = true
        
        let nextLabel = UILabel.init()
        nextLabel.font = UIFont.init(style: .regular, size: 12.uiX)
        nextLabel.textColor = .init(hex: "#FFDEB0")
        nextLabel.textAlignment = .center
        addSubview(nextLabel)
        nextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(150.uiX)
            make.height.equalTo(20.uiX)
            make.top.equalTo(doubleButton.snp_bottomMargin).offset(17.uiX)
        }
        let text = NSMutableAttributedString(string: "领奖，开始下一关")
        text.yy_font = .init(style: .regular, size: 12.uiX)
        text.yy_color = .init(hex: "#FFDEB0")
        text.yy_setUnderlineStyle(.single, range: text.yy_rangeOfAll())
        nextLabel.attributedText = text
        self.nextLabel = nextLabel
        
        layoutIfNeeded()
        let adView = ListAdAnimationView(slotId: nil, w: UIScreen.main.bounds.size.width)
        adView.x = 0
        adView.y = UIScreen.main.bounds.size.height - UIDevice.safeAreaBottom - adView.height
        addSubview(adView)
        
        doubleButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(addPointReward))
        nextLabel.addGestureRecognizer(tap)
        nextLabel.isUserInteractionEnabled = true
        
        sureButton.addTarget(self, action: #selector(addPointReward), for: .touchUpInside)
    }
    
    func showWithLevel(level : Int) {
        self.checkpoint = level
        let array = UserManager.shared.configure?.checkpointReward
        var rangeModel: ConfigureCheckpointReward?
        for item in array! {
            let model = item
            if (level >= model.minCheckpoint) && (level <= model.maxCheckpoint) {
                rangeModel = model
                break
            }
        }
        if rangeModel == nil {return}
        let random = Float.random(in: rangeModel!.min...rangeModel!.max)
        let randomStr = String(format: "%.2f", random)
        let randomNum = randomStr.float()!
        self.redPacket = randomNum
        self.sumLabel?.text = "+\(randomNum)元"
        
    }
    
    @objc private func playVideo () {
        
    }
    
    @objc func close () {
        if let sup = self.parentViewController as? PopView {
            sup.hide()
        }
        self.delegate?.nextGame()
    }
    
    func errorClose (error : NetError) {
        if let sup = self.parentViewController as? PopView {
            sup.hide()
        }
        self.delegate?.rebuildGmae()
        let text : String?
        switch error {
                    case let .error(code: _, msg: m):
                        text = m
                    }
        self.delegate?.showHUD(text: text ?? "")
    }
    
    @objc func addPointReward () {
        self.requestGetCheckpointReward().subscribe(onNext: {[weak self] result in
            guard let self = self else { return }
            guard let user = UserManager.shared.user else { return }
            guard let result = result else { return }
            user.currentLevel.accept(result.lastCheckpointRewardNum + 1)
            user.redPacket = result.redPacket
            UserManager.shared.login.accept((user, .change))
            self.close()
            
        }, onError: { error in
            self.errorClose(error: error as! NetError)
        }).disposed(by: self.rx.disposeBag)
    }
    
    // MARK: - Request
    private func requestGetCheckpointReward() -> Observable<PassGameBackModel?> {
        return NetManager.requestObj(.passGameAward(checkpoint: self.checkpoint!,video : video,red_packet: "\(self.redPacket!)"), type: PassGameBackModel.self).asObservable()
        
    }
}
