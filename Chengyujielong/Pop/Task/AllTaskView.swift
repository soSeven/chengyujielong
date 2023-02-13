//
//  AllTaskView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/28.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class AllTaskView: UIView {
    
    let viewModel = AllTaskViewModel()
    
    private let allTask = TaskTopItem(imgName: "task_title_img_nor01", selImgName: "task_title_img_choose01")
    private let todayTask = TaskTopItem(imgName: "task_title_img_nor02", selImgName: "task_title_img_choose02")
    
    private let allTaskTableView = UITableView(frame: .zero, style: .plain)
    private let todayTaskTableView = UITableView(frame: .zero, style: .plain)
    
    var goToCash: (()->())?
    
    init() {
        
        let bgImg = UIImage.create("task_img_frame01")
        let frame = CGRect(x: 0, y: 0, width: bgImg.snpSize.width, height: bgImg.snpSize.height + 30.uiX)
        super.init(frame: frame)
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.size = bgImg.snpSize
        bgImgView.y = 30.uiX
        addSubview(bgImgView)
        
        let closeBtnImg = UIImage.create("task_img_close")
        let closeBtn = MusicButton()
        closeBtn.setBackgroundImage(closeBtnImg, for: .normal)
        closeBtn.size = closeBtnImg.snpSize
        closeBtn.y = 0
        closeBtn.x = width - closeBtn.width - 15.uiX
        addSubview(closeBtn)
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let sup = self.parentViewController as? PopView {
                sup.hide()
            }
        }).disposed(by: rx.disposeBag)
        
        allTask.selected = true
        allTask.btn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.allTask.selected = true
            self.todayTask.selected = false
            self.allTaskTableView.isHidden = false
            self.todayTaskTableView.isHidden = true
        }).disposed(by: rx.disposeBag)
        
        todayTask.btn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.allTask.selected = false
            self.todayTask.selected = true
            self.allTaskTableView.isHidden = true
            self.todayTaskTableView.isHidden = false
        }).disposed(by: rx.disposeBag)
        
        let s = UIStackView(arrangedSubviews: [allTask, todayTask])
        s.spacing = 10.uiX
        addSubview(s)
        s.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30.uiX)
        }
        
        allTaskTableView.backgroundColor = .clear
        allTaskTableView.showsHorizontalScrollIndicator = false
        allTaskTableView.contentInset = .init(top: 15.uiX, left: 0, bottom: 0, right: 0)
        allTaskTableView.separatorStyle = .none
        allTaskTableView.tableFooterView = UIView()
        let headerBgView = UIView(frame: .init(x: 0, y: 0, width: width, height: 104.uiX))
        let headerView = AllTaskLevelView()
        headerBgView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
        }
        if let u = UserManager.shared.user {
            headerView.setupProgress(u.difRelay.value.3)
            if u.difRelay.value.2 == 0 {
                headerView.levelLbl.text = "获得一次抽奖机会"
                headerView.btn.rx.tap.subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.goToCash?()
                    if let sup = self.parentViewController as? PopView {
                        sup.hide()
                    }
                }).disposed(by: rx.disposeBag)
            } else {
                headerView.levelLbl.text = "距离下次提现还差\(u.difRelay.value.2)关"
                headerView.btn.rx.tap.subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    Observable.just("距离下次提现还差\(u.difRelay.value.2)关").bind(to: self.rx.toastText()).disposed(by: self.rx.disposeBag)
                }).disposed(by: rx.disposeBag)
            }
        }
        
        allTaskTableView.tableHeaderView = headerBgView
        if #available(iOS 11, *) {
            allTaskTableView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(allTaskTableView)
        allTaskTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 80.uiX, left: 0, bottom: 20.uiX, right: 0))
        }
        
        todayTaskTableView.backgroundColor = .clear
        todayTaskTableView.showsHorizontalScrollIndicator = false
        todayTaskTableView.contentInset = .init(top: 15.uiX, left: 0, bottom: 0, right: 0)
        todayTaskTableView.separatorStyle = .none
        todayTaskTableView.tableFooterView = UIView()
        todayTaskTableView.tableHeaderView = UIView()
        todayTaskTableView.isHidden = true
        if #available(iOS 11, *) {
            todayTaskTableView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(todayTaskTableView)
        todayTaskTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 80.uiX, left: 0, bottom: 20.uiX, right: 0))
        }
        
        todayTaskTableView.register(cellType: TodayTaskTableCell.self)
        allTaskTableView.register(cellType: AllTaskTableCell.self)
        
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = AllTaskViewModel.Input(request: Observable<Void>.just(()))
        let output = viewModel.transform(input: input)
        
        output.allTaskList.bind(to: allTaskTableView.rx.items(cellIdentifier: AllTaskTableCell.reuseIdentifier, cellType: AllTaskTableCell.self)) { (row, element, cell) in
                cell.bind(to: element)
        }.disposed(by: rx.disposeBag)
        
        output.openAllTaskReward.subscribe(onNext: { m in
            MobClick.event("achievement")
            if m.money > 0 {
                PopView.show(view: AllTaskCashView(model: m))
            } else {
                PopView.show(view: AllTaskCoinView(model: m))
            }
        }).disposed(by: rx.disposeBag)
        
        output.todayTaskList.bind(to: todayTaskTableView.rx.items(cellIdentifier: TodayTaskTableCell.reuseIdentifier, cellType: TodayTaskTableCell.self)) { (row, element, cell) in
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)
        
        output.openTodayTaskReward.subscribe(onNext: { m in
            PopView.show(view: TodayTaskCoinView(model: m))
        }).disposed(by: rx.disposeBag)
        
        output.allTaskRedDot.bind(to: allTask.dot.rx.isHidden).disposed(by: rx.disposeBag)
        output.todayTaskRedDot.bind(to: todayTask.dot.rx.isHidden).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.asObserver().bind(to: rx.toastError).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: rx.mbHudLoaing).disposed(by: rx.disposeBag)
    }
}

private class TaskTopItem: UIView {
    
    private let normalImgName: String
    private let selectedImgName: String
    private let imgView = UIImageView()
    let btn = MusicButton()
    let dot = UIImageView()
    
    init(imgName: String, selImgName: String) {
        
        normalImgName = imgName
        selectedImgName = selImgName
        
        let img = UIImage.create(imgName)
        super.init(frame: .init(x: 0, y: 0, width: img.snpSize.width, height: img.snpSize.height))
        
        imgView.image = img
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.size.equalTo(img.snpSize)
            make.edges.equalToSuperview()
        }
        
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let dotImg = UIImage.create("task_img_dot")
        dot.image = dotImg
        addSubview(dot)
        dot.snp.makeConstraints { make in
            make.size.equalTo(dotImg.snpSize)
            make.top.equalToSuperview().offset(9.uiX)
            make.right.equalToSuperview().offset(-5.uiX)
        }
    }
    
    private var _selected = false
    var selected: Bool {
        get {
            _selected
        }
        set {
            _selected = newValue
            imgView.image = .create(_selected ? selectedImgName : normalImgName)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private class AllTaskLevelView: UIView {
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .regular, size: 10.uiX)
        lbl.textColor = .init(hex: "#7A320D")
        lbl.text = "猜成语即可提现！机会多多，金额不限！"
        return lbl
    }()
    
    lazy var levelLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .init(style: .bold, size: 14.5.uiX)
        lbl.textColor = .init(hex: "#7A310C")
        lbl.text = "距离下次提现还差0关"
        return lbl
    }()
    
    private let progressBgView = UIView()
    let progressView = UIView()
    
    let btn = MusicButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImg = UIImage.create("task_img_frame02")
        let bgImgView = UIImageView(image: bgImg)
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.size.equalTo(bgImg.snpSize)
            make.edges.equalToSuperview()
        }
        
        addSubview(levelLbl)
        levelLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5.uiX)
            make.left.equalToSuperview().offset(10.5.uiX)
        }
        
        progressBgView.borderColor = .init(hex: "#DA862D")
        progressBgView.borderWidth = 1.uiX
        addSubview(progressBgView)
        progressBgView.snp.makeConstraints { make in
            make.top.equalTo(levelLbl.snp.bottom).offset(11.5.uiX)
            make.left.equalToSuperview().offset(10.5.uiX)
            make.height.equalTo(9.uiX)
            make.width.equalTo(176.uiX)
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
        
        let btnImg = UIImage.create("task_img_btn01")
        btn.setImage(btnImg, for: .normal)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(btnImg.snpSize)
            make.right.equalToSuperview().offset(-11.5.uiX)
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
