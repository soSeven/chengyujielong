////
////  RXBUSplashAdDelegateProxy.swift
////  CrazyMusic
////
////  Created by LiQi on 2020/9/1.
////  Copyright © 2020 LQ. All rights reserved.
////
//
//import Foundation
////import BUAdSDK
//import RxSwift
//import RxCocoa
//
//extension BUSplashAdView: HasDelegate {
//    public typealias Delegate = BUSplashAdDelegate
//}
//
//class RXBUSplashAdDelegateProxy:
//DelegateProxy<BUSplashAdView, BUSplashAdDelegate>,
//DelegateProxyType, BUSplashAdDelegate {
//    
//    weak private(set) var splashView: BUSplashAdView?
//    
//    init(splashView: BUSplashAdView) {
//        self.splashView = splashView
//        super.init(parentObject: splashView, delegateProxy: RXBUSplashAdDelegateProxy.self)
//    }
//    
//    static func registerKnownImplementations() {
//        self.register { parent -> RXBUSplashAdDelegateProxy in
//            RXBUSplashAdDelegateProxy(splashView: parent)
//        }
//    }
//    
//}
//
//extension Reactive where Base: BUSplashAdView {
//    
//    var delegate: DelegateProxy<BUSplashAdView, BUSplashAdDelegate> {
//        return RXBUSplashAdDelegateProxy.proxy(for: base)
//    }
//    
//    var didCompleteWithAuthorization: Observable<BUSplashAdView> {
//        return delegate.methodInvoked(#selector(BUSplashAdDelegate.splashAdDidClose(_:))).map { parameters in
//            return parameters[0] as! BUSplashAdView
//        }
//    }
//    
//    var didCompleteWithError: Observable<Error?> {
//        return delegate.methodInvoked(#selector(BUSplashAdDelegate.splashAd(_:didFailWithError:))).map { parameters in
//            return parameters[1] as? Error
//        }
//    }
//    
//}
