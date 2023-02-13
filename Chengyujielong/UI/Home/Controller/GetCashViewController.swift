//
//  GetCashViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/12.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import YYText

protocol GetCashViewControllerDelegate: AnyObject {
    
    func cashSelectedProtocol(controller: GetCashViewController)
    func cashSelectedRecord(controller: GetCashViewController)
    func cashSelectedPlayMusic(controller: GetCashViewController)
}

class GetCashViewController: ViewController {
    
    var viewModel: CashViewModel!
    
    weak var delegate: GetCashViewControllerDelegate?
    
    var tableView: UITableView!
    
    var currentLevel = 0
    
    private var lbl1: UILabel!
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private var items = [CashPriceModel]()
    
    private var playDisposeBag = DisposeBag()
    
    private var currentIndex = 0
    private let priceView = GetCashPriceSubView()
    
    private var isSelectedProtocol = true
    
    private let weChatHeaderView = GetCashHeaderSubView()
    
    private let cashLevelView = GetCashLevelView()
    
    private let cashPublisher = PublishSubject<CashPriceModel>()
    
    private let moneyCardView = GetCashMoneySubView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "提现"
        view.backgroundColor = .init(hex: "#FFFFFF")
        
        hbd_barTintColor = .clear
        hbd_barAlpha = 0
        setupUI()
        setupBinding()
        
        currentLevel = UserManager.shared.user?.lastCheckpointRewardNum ?? 0
    }
    
    // MARK: - Event
    
    private func showLotteryView() {
        let pop = LotteryPopView()
        pop.cashNext = { [weak self] in
            guard let self = self else { return }
            self.delegate?.cashSelectedPlayMusic(controller: self)
        }
        pop.coinNext = { [weak self] in
            guard let self = self else { return }
            self.delegate?.cashSelectedPlayMusic(controller: self)
        }
        PopView.show(view: pop)
    }
    
    private func onClickGetCash() {

        if !priceView.isAgreeProtocol {
            Observable.just("请先阅读并同意结算协议").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }
        
        if currentIndex >= items.count {
            return
        }
        
        if let u = UserManager.shared.user?.openid, u.isEmpty {
            Observable.just("请先绑定微信").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }
        
        let item = items[currentIndex]
        
        let cash = Float(UserManager.shared.user?.redPacket ?? "0") ?? 0
        if cash < (Float(item.cash)/10000) {
            Observable.just("提现金额不足").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }

        let level = currentLevel - 1
        if level < item.level {
            Observable.just("要达到\(item.level)关才能提现").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }

        cashPublisher.onNext(item)

    }
    
    private func onClickGetCash(_ cashStr: String) {

        if !priceView.isAgreeProtocol {
            Observable.just("请先阅读并同意结算协议").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }
        
        if let u = UserManager.shared.user?.openid, u.isEmpty {
            Observable.just("请先绑定微信").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }
        
        let totalCash = Float(UserManager.shared.user?.redPacket ?? "0") ?? 0
        let cash = Float(cashStr) ?? 0
        if totalCash < cash {
            Observable.just("提现金额不足").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }
        
        let level = currentLevel - 1
        if level < 3500 {
            Observable.just("要达到\(3500)关才能提现").bind(to: view.rx.toastText()).disposed(by: rx.disposeBag)
            return
        }

    }
    
    // MARK: - UI

    func setupUI() {

        let backBtn = MusicButton()
        backBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        backBtn.setImage(UIImage(named: "cash_img_return"), for: .normal)
        backBtn.frame = .init(x: 0, y: 0, width: 40, height: 40)
        backBtn.contentHorizontalAlignment = .left
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)

        let rightBtn = MusicButton()
        rightBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            MobClick.event("withdrawal_record")
            self.delegate?.cashSelectedRecord(controller: self)
        }).disposed(by: rx.disposeBag)
        rightBtn.setTitle("提现记录", for: .normal)
        rightBtn.setTitleColor(.init(hex: "#572C05"), for: .normal)
        rightBtn.titleLabel?.font = .init(style: .medium, size: 14)
        rightBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        let bgImg = UIImage.create("home_img_bgd")
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.clipsToBounds = true
        view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1000.uiX)
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(15.uiX)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let infoView = GetCashInfoSubView()
        
        weChatHeaderView.btn.rx.tap.subscribe(onNext: {
            MobClick.event("withdrawal_pinless")
        }).disposed(by: rx.disposeBag)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15.uiX
        stackView.addArrangedSubviews([moneyCardView, weChatHeaderView, cashLevelView, priceView, infoView])
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
    }
    
    private func getCashStr(num: String) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .bold, size: 20.uiX),
            .foregroundColor: UIColor(hex: "#7A310C")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "DIN-Medium", size: 35.uiX)!,
            .foregroundColor: UIColor(hex: "#7A310C")
        ]
        let s = NSMutableAttributedString(string: "¥", attributes: a1)
        let s2 = NSAttributedString(string: num, attributes: a2)
        s.append(s2)
        return s
    }
    
    private func getCashLevelStr(num: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#7A310C")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#E53A1E")
        ]
        let s = NSMutableAttributedString(string: "距离下次提现还差", attributes: a1)
        let s2 = NSAttributedString(string: " \(num)关", attributes: a2)
        s.append(s2)
        return s
    }
    
    private func getCashLevelTimeStr(time: Int) -> NSAttributedString {
        
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#7A310C")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#E53A1E")
        ]
        
        let h = time / 60 / 60
        let m = (time - (h * 60 * 60)) / 60
        let s = (time - (h * 60 * 60)) % 60
        
        let timeStr = String(format: "%.2d:%.2d:%.2d", h, m, s)
        
        let sAtt = NSMutableAttributedString(string: "提现机会即将失效 ", attributes: a1)
        let s2 = NSAttributedString(string: timeStr, attributes: a2)
        sAtt.append(s2)
        return sAtt
    }
    
    // MARK: - Binding
    
    private func setupBinding() {

        viewModel.controller = self
        if let u = UserManager.shared.user, u.hasDraw.value > 0 {
            u.hasDrawTime.accept(10 * 60)
            u.hasDrawTimeShowStart.accept(true)
            u.hasDraw.accept(0)
        }
        
        var timeDisposeBag = DisposeBag()
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let u = u else { return }
            
            self.moneyCardView.titleLbl.attributedText = self.getCashStr(num:u.redPacket)
            
            if !u.openid.isEmpty {
                self.weChatHeaderView.isUserInteractionEnabled = false
                self.weChatHeaderView.titleLbl.text = u.nickname
                self.weChatHeaderView.imgView.kf.setImage(with: URL(string: u.avatar))
                self.weChatHeaderView.arrowImgView.isHidden = true
            }

            timeDisposeBag = DisposeBag()
            
            let lastw = u.lastWithdrawalChanceResult.int ?? 0
            if lastw > 0 {
                u.withdrawalChanceCountdown.subscribe(onNext: {[weak self] time in
                    guard let self = self else { return }
                    self.priceView.setupTimeCard(cash: u.lastWithdrawalChanceResult, time: time, isHidden: false)
                }).disposed(by: timeDisposeBag)
            } else {
                self.priceView.setupTimeCard(cash: u.lastWithdrawalChanceResult, time: 0, isHidden: true)
            }
            
            var btnDisposeBag = DisposeBag()
            u.hasDrawTime.subscribe(onNext: {[weak self] time in
                guard let self = self else { return }
                btnDisposeBag = DisposeBag()
                if time > 0 {
                    self.cashLevelView.levelLbl.attributedText = self.getCashLevelTimeStr(time: time)
                    self.cashLevelView.btn.rx.tap.subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        MobClick.event("withdrawal_extracting")
                        self.showLotteryView()
                    }).disposed(by: btnDisposeBag)
                } else {
                    self.cashLevelView.levelLbl.attributedText = self.getCashLevelStr(num: u.difRelay.value.2)
                    self.cashLevelView.btn.rx.tap.subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        MobClick.event("withdrawal_opportunity")
                        Observable.just("距离下次提现还差\(u.difRelay.value.2)关").bind(to: self.view.rx.toastText()).disposed(by: timeDisposeBag)
                    }).disposed(by: btnDisposeBag)
                }
            }).disposed(by: timeDisposeBag)
            
            self.cashLevelView.setupProgress(u.difRelay.value.3)

        }).disposed(by: rx.disposeBag)

        let input = CashViewModel.Input(request: errorBtnTap.asObservable().startWith(()),
                                        cash: cashPublisher.asObserver(),
                                        requestWeChat: weChatHeaderView.btn.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        output.items.bind(to: priceView.collectionView.rx.items(cellIdentifier: PayListCell.reuseIdentifier, cellType: PayListCell.self)) { [weak self] (row, element, cell) in
            guard let self = self else { return }
            if self.currentIndex == row {
                cell.bgView.borderColor = .init(hex: "#D9852D")
                cell.bgView.borderWidth = 1.uiX
                cell.bgView.backgroundColor = .init(hex: "#FFE1B0")
                cell.chooseImgView.isHidden = false
            } else {
                cell.bgView.borderColor = .init(hex: "#572B05")
                cell.bgView.borderWidth = 1.uiX
                cell.bgView.backgroundColor = .clear
                cell.chooseImgView.isHidden = true
            }
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)

        output.items.bind {[weak self] items in
            guard let self = self else { return }
            self.items = items
            self.priceView.collectionView.reloadData()
        }.disposed(by: rx.disposeBag)

        output.success.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
            Observable.just("申请成功，将于3日内审核到帐").bind(to: self.view.rx.toastText()).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        priceView.collectionView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            if self.items.count > index.row {
                let i = self.items[index.row]
                MobClick.event("withdrawal_wechat", attributes: ["price": i.cash])
            }
            self.currentIndex = index.row
            self.priceView.collectionView.reloadData()
        }).disposed(by: rx.disposeBag)

        priceView.protocolAction = { [weak self] in
            guard let self = self else { return }
            self.delegate?.cashSelectedProtocol(controller: self)
        }
        priceView.cashAction = { [weak self] in
            guard let self = self else { return }
            MobClick.event("withdrawal_conventional")
            self.onClickGetCash()
        }

        priceView.timeCardView.btn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let u = UserManager.shared.user else { return }
            self.onClickGetCash(u.lastWithdrawalChanceResult)
        }).disposed(by: rx.disposeBag)
        
        cashLevelView.helpBtn.rx.tap.subscribe(onNext: { _ in
            MobClick.event("withdrawal_rule")
            PopView.show(view: LotteryRuleView())
        }).disposed(by: rx.disposeBag)
        
        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView()).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)

        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)

    }
    

}
