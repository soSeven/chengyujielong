//
// Created by liqi on 2020/9/28.
// Copyright (c) 2020 Kaka. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GetCashRecordViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "提现记录"
        view.backgroundColor = .init(hex: "#FFFFFF")

        hbd_barTintColor = .clear
        hbd_barAlpha = 0
        setupUI()
    }

    // MARK: - UI

    private func setupUI() {

        let backBtn = MusicButton()
        backBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        backBtn.setImage(UIImage(named: "cash_img_return"), for: .normal)
        backBtn.frame = .init(x: 0, y: 0, width: 40, height: 40)
        backBtn.contentHorizontalAlignment = .left
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)

        let bgImg = UIImage.create("home_img_bgd")
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.clipsToBounds = true
        view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let u = UserManager.shared.user?.withdrawalTime, !u.isEmpty {
            setupItemView()
        } else {
            Observable.just(true).bind(to: rx.showEmptyView(inset: .init(top: 200.uiX, left: 0, bottom: 0, right: 0))).disposed(by: rx.disposeBag)
        }
        
    }
    
    private func setupItemView() {
        
        let bgImg = UIImage.create("cash_record_img_frame")
        let bgImgView = UIImageView(image: bgImg)
        view.addSubview(bgImgView)
        
        bgImgView.snp.makeConstraints { make in
            make.size.equalTo(bgImg.snpSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(15.uiX)
        }
        
        let lbl = UILabel()
        lbl.text = "新手专享提现"
        lbl.textColor = .init(hex: "#7A320D")
        lbl.font = .init(style: .medium, size: 15.uiX)
        
        let timelbl = UILabel()
        timelbl.text = "2020-09-01 09:37"
        timelbl.textColor = .init(hex: "#AC7850")
        timelbl.font = .init(style: .regular, size: 12.uiX)
        
        let s = UIStackView(arrangedSubviews: [lbl, timelbl], axis: .vertical, spacing: 2.uiX, alignment: .leading, distribution: .equalSpacing)
        bgImgView.addSubview(s)
        s.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10.5.uiX)
        }
        
        let pricelbl = UILabel()
        pricelbl.text = "0.3元"
        pricelbl.textColor = .init(hex: "#E53A1F")
        pricelbl.font = .init(style: .medium, size: 17.uiX)
        bgImgView.addSubview(pricelbl)
        pricelbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-24.uiX)
        }
        
    }
    

}
