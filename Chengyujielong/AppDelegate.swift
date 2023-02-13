//
//  AppDelegate.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/7.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Application.shared.configureDependencies()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LibManager.shared.register(launchOptions: launchOptions)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        self.window = window
        Application.shared.configureMainInterface(in: window)

        self.window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url, options: options) ?? false
        return result
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url) ?? false
        return result
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        UMSocialManager.default()?.handleUniversalLink(userActivity, options: nil)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenStr = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        print("deviceToken: \(deviceTokenStr)")
        LibManager.shared.deviceToken = deviceTokenStr
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let _ = u else { return }
            guard s == .login else { return }
//            NetManager.requestResponse(.updateDeviceToken(token: deviceTokenStr)).subscribe(onSuccess: { _ in
//                print("success to regist deviceToken: \(deviceTokenStr)")
//            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

        //获取当前时间
        let  now =  NSDate ()
        // 创建一个日期格式器
        let  dformatter =  DateFormatter ()
        dformatter.dateFormat =  "yyyy年MM月dd日"
        let dateString = dformatter.string(from: now as Date)
//        print ( "当前日期时间：\(dateString)" )
        //当前时间的时间戳
        let  timeInterval: TimeInterval  = now.timeIntervalSince1970
        let  timeStamp =  Int (timeInterval)
//        print ( "当前时间的时间戳：\(timeStamp)" )
        
        //非今日时间
        let lastDateString = UserDefaults.standard.string(forKey: "todayDateString")
        if lastDateString != dateString {
            UserDefaults.standard.set(dateString, forKey: "todayDateString")
            UserDefaults.standard.set(0, forKey: "userOnlineTime")
        }
        //记录当前时间戳
        UserDefaults.standard.set(timeStamp, forKey: "userOnlineTimeStamp")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        //获取当前时间
        let  now =  NSDate ()
        // 创建一个日期格式器
        let  dformatter =  DateFormatter ()
        dformatter.dateFormat =  "yyyy年MM月dd日"
        let dateString = dformatter.string(from: now as Date)
        //当前时间的时间戳
        let  timeInterval: TimeInterval  = now.timeIntervalSince1970
        let  timeStamp =  Int (timeInterval)
        
        let lastDateString = UserDefaults.standard.string(forKey: "todayDateString")
        if lastDateString != dateString {
            UserDefaults.standard.set(dateString, forKey: "todayDateString")
            UserDefaults.standard.set(0, forKey: "userOnlineTime")
        } else {
            let lastOnlineTime = UserDefaults.standard.integer(forKey: "userOnlineTime")
            let lastOnlineTimeStamp = UserDefaults.standard.integer(forKey: "userOnlineTimeStamp")
            let subTime = timeStamp - lastOnlineTimeStamp
            UserDefaults.standard.set((lastOnlineTime + subTime), forKey: "userOnlineTime")
        }

    }

}

