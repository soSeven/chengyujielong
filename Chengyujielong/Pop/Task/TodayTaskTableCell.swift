//
//  TodayTaskTableCell.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/29.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxCocoa
import RxSwift

class TodayTaskTableCell: TableViewCell {
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#7A310C")
        lbl.font = .init(style: .bold, size: 14.5.uiX)
        lbl.text = "获得“秀才”头衔"
        return lbl
    }()
    
    private let item1 = TodayTaskTableCellItem(imgName: "task_img_coin")
    
    private let btn = MusicButton()
    
    private let progressBgView = UIView()
    private let progressView = UIView()
    private let numToNumView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        let bgImg = UIImage.create("task_img_frame02")
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.isUserInteractionEnabled = true
        contentView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12.uiX)
            make.size.equalTo(bgImg.snpSize).priority(900)
        }
        
        let s = UIStackView(arrangedSubviews: [titleLbl, item1])
        s.axis = .vertical
        s.alignment = .leading
        s.distribution = .equalSpacing
        s.spacing = 12.uiX
        
        bgImgView.addSubview(s)
        s.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.5.uiX)
            make.centerY.equalToSuperview()
        }
        
        let btnImg = UIImage.create("task_img_btn02")
        btn.setImage(btnImg, for: .normal)
        bgImgView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.size.equalTo(btnImg.snpSize)
            make.right.equalToSuperview().offset(-11.5.uiX)
            make.bottom.equalToSuperview().offset(-11.5.uiX)
        }
        
        addSubview(progressBgView)
        addSubview(progressView)
        addSubview(numToNumView)
        
        numToNumView.snp.makeConstraints { make in
            make.centerY.equalTo(progressBgView)
            make.right.equalToSuperview().offset(-46.uiX)
        }
        
        numToNumView.attributedText = getAttStr(num: 0, total: 0)
        
        progressBgView.borderColor = .init(hex: "#DA862D")
        progressBgView.backgroundColor = .init(hex: "#F4E5BE")
        progressBgView.borderWidth = 1.uiX
        
        progressBgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21.5.uiX)
            make.right.equalTo(numToNumView.snp.left).offset(-6.uiX)
            make.height.equalTo(8.uiX)
            make.width.equalTo(51.uiX)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.bottom.top.equalTo(progressBgView)
            make.width.equalTo(progressBgView).multipliedBy(0.5)
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setupProgress(num: Int, total: Int) {
        var progress: CGFloat = 0
        if total > 0 {
            progress = CGFloat(num)/CGFloat(total)
        }
        progressView.snp.remakeConstraints { make in
            make.left.bottom.top.equalTo(progressBgView)
            make.width.equalTo(progressBgView).multipliedBy(progress)
        }
        progressView.isHidden = (progress == 0)
        numToNumView.attributedText = getAttStr(num: num, total: total)
    }
    
    private func getAttStr(num: Int, total: Int) -> NSAttributedString {
        let a1: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 9.uiX),
            .foregroundColor: UIColor(hex: "#E71A00")
        ]
        let a2: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 9.uiX),
            .foregroundColor: UIColor(hex: "#7A310C")
        ]
        let s = NSMutableAttributedString(string: "\(num)", attributes: a1)
        let s2 = NSAttributedString(string: "/\(total)", attributes: a2)
        s.append(s2)
        return s
    }
    
    // MARK: - Bind

    func bind(to viewModel: TodayTaskCellViewModel) {
        titleLbl.text = viewModel.text
        setupProgress(num: viewModel.nowCount, total: viewModel.min)
        if viewModel.goldCoin > 0 {
            item1.isHidden = false
            item1.textLbl.text = "\(viewModel.goldCoin ?? 0)"
        } else {
            item1.isHidden = true
        }
        cellDisposeBag = DisposeBag()
        viewModel.status.subscribe(onNext: {[weak self] s in
            guard let self = self else { return }
            if s > 0 {
                let btnImg = UIImage.create("task_img_btn02")
                self.btn.setImage(btnImg, for: .normal)
                self.btn.rx.tap.subscribe(onNext: {
                    viewModel.openReward.onNext(viewModel)
                }).disposed(by: self.cellDisposeBag)
            } else {
                let btnImg = UIImage.create("task_img_btn03")
                self.btn.setImage(btnImg, for: .normal)
            }
        }).disposed(by: cellDisposeBag)
    }
    
}

private class TodayTaskTableCellItem: UIView {
    
    lazy var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#7A310C")
        lbl.font = .init(style: .regular, size: 12.uiX)
        lbl.text = "5元"
        return lbl
    }()
    
    let imgView = UIImageView()
    
    init(imgName: String) {
        super.init(frame: .zero)
        
        let img = UIImage.create(imgName)
        imgView.image = img
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.size.equalTo(img.snpSize)
        }
        
        addSubview(textLbl)
        textLbl.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(4.uiX)
            make.centerY.right.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
