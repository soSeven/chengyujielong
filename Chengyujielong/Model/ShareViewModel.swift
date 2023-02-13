//
//  ShareViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class ShareViewModel: ViewModel, ViewModelType {
    
    var viewController: UIViewController?
    
    struct Input {
        let share: Observable<Void>
    }
    
    struct Output {
        let hud: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let hud = PublishRelay<String>()
        
        input.share.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.requestShare(viewController: self.viewController).subscribe(onNext: { success in
                hud.accept(success)
            }, onError: { error in
                if let e = error as? NetError {
                    switch e {
                    case let .error(code: _, msg: msg):
                        hud.accept(msg)
                    }
                }
                hud.accept("分享失败")
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        return Output(hud: hud)
    }
    
    /// MARK: - Request
    
    func requestShare(viewController: UIViewController?) -> Observable<String> {
        
        return Observable<UIImage>.create { obser in
            DispatchQueue.global().async {
                if let url = URL(string: UserManager.shared.user?.shareUrl),
                   let data = try? Data(contentsOf: url),
                   let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        obser.onNext(img)
                        obser.onCompleted()
                    }
                } else {
                    DispatchQueue.main.async {
                        obser.onError(NetError.error(code: -1000, msg: "分享图片错误"))
                    }
                }
            }
            return Disposables.create()
        }.flatMapLatest { m in
            
            return Observable<String>.create { obser in
                let messageObj = UMSocialMessageObject()
                let img = UMShareImageObject()
                img.shareImage = m
                messageObj.shareObject = img
                UMSocialManager.default()?.share(to: .wechatSession, messageObject: messageObj, currentViewController: viewController, completion: { result, error in
                    if let _ = error {
                        obser.onError(NetError.error(code: -1000, msg: "分享图片错误"))
                    } else {
                        obser.onNext("分享成功")
                        obser.onCompleted()
                    }
                })
                return Disposables.create()
            }
            
        }.timeout(RxTimeInterval.seconds(15), scheduler: MainScheduler.instance).trackError(error).trackActivity(loading)
    }
    
}
