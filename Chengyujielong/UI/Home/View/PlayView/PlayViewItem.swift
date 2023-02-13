//
//  PlayViewItem.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/9.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlayViewItem: UIView {
    
    let viewModel = PlayWordViewModel()
    
    var acceptViewModel: PlayWordViewModel?
    
    let selectedRelay = BehaviorRelay<Bool>(value: false)
    let writePublish = PublishRelay<String>()
    
    var didClickItem: ((PlayViewItem) -> ())?
    
    init(scale: CGFloat) {
        
        super.init(frame: .zero)
        
        let bgImgView = UIImageView(image: .create("home_img_txt00"))
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#7A310C")
        lbl.font = UIFont.init(name: "HYa9gj", size: 20.uiX * scale)
        addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let selectedImgView = UIImageView(image: .create("home_img_text06"))
        addSubview(selectedImgView)
        selectedImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectedImgView.isHidden = true
        
        var clickDisposeBag = DisposeBag()
        viewModel.type.subscribe(onNext: {[weak self] type in
            guard let self = self else { return }
            clickDisposeBag = DisposeBag()
            switch type {
            case .empty:
                bgImgView.image = .create("home_img_txt00")
            case .finish:
                bgImgView.image = .create("home_img_txt02")
                lbl.textColor = .init(hex: "#7A310C")
            case .right:
                bgImgView.image = .create("home_img_txt01")
                lbl.textColor = .init(hex: "#FFFFFF")
            case .wrong:
                bgImgView.image = .create("home_img_txt03")
                lbl.textColor = .init(hex: "#E11819")
                self.rx.tap().subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.didClickItem?(self)
                }).disposed(by: clickDisposeBag)
            case .write:
                bgImgView.image = .create("home_img_txt04")
                self.rx.tap().subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.didClickItem?(self)
                }).disposed(by: clickDisposeBag)
            case .wait:
                bgImgView.image = .create("home_img_txt03")
                lbl.textColor = .init(hex: "#E11819")
                self.rx.tap().subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.didClickItem?(self)
                }).disposed(by: clickDisposeBag)
            case .read:
                bgImgView.image = .create("home_img_txt02")
                lbl.textColor = .init(hex: "#7A310C")
                self.rx.tap().subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.didClickItem?(self)
                }).disposed(by: clickDisposeBag)
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.text.bind(to: lbl.rx.text).disposed(by: rx.disposeBag)
        
        viewModel.selected.subscribe(onNext: { selected in
            selectedImgView.isHidden = !selected
        }).disposed(by: rx.disposeBag)
        
        viewModel.animation.subscribe(onNext: {[weak self] (success, duration) in
            guard let self = self else { return }
            if success {
                UIView.animate(withDuration: 0.25, delay: TimeInterval(duration), options: .curveLinear) {
                    self.transform = .init(scaleX: 1.1, y: 1.1)
                } completion: { _ in
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) {
                        self.transform = .identity
                    } completion: { _ in
                        
                    }
                }
            } else {
                CATransaction.begin()
                let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                animation.duration = 1
                animation.values = [-5.0, 5.0, -5.0, 5.0, -2.5, 2.5, -1.25, 1.25, 0.0]
                self.layer.add(animation, forKey: "shake")
                CATransaction.commit()
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

