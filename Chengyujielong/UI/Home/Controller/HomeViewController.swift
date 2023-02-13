//
//  HomeViewController.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/8.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift
import Foundation
import SwiftyJSON
import MBProgressHUD

protocol HomeViewControllerDelegate: AnyObject {
    
    func homeDidGetCash(controller: HomeViewController)
    func homeExchangeRadPacket(controller: HomeViewController)
    func homeShowAD(controller: HomeViewController)
}

class HomeViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    weak var delegate: HomeViewControllerDelegate?
//    let maxLel: Int = 1000
    var nowlel: Int = 1
    var questionsMaxRow = 0
    var cellWidth = 38.uiX
    var cellHeight = 38.uiX
    
    let reuseIdentifier = "HomeQuestionCell"
    let reuseIdentifierA = "HomeAnswerCell"
    
    var isGameOver = false
    
    var dataArray : NSMutableArray?

    //问题界面答案空格数据
    var answerIndexArray : NSMutableArray?
    var answerWordsArray : NSMutableArray?
    
    var selectQuestionModel : HomeQuestionCellModel?
    var selectAnswerModel : HomeQuestionCellModel?
    
    lazy var homeBGView: HomeBGView = {
        
        let view = HomeBGView.init(frame: self.view.bounds)
        
        return view
    }()
    
    private lazy var homeSignView: HomeSignView = {
        
        let view = HomeSignView.init(frame: self.view.bounds)
        
        return view
    }()
    
    private var questionsView: UICollectionView = UICollectionView(frame:.zero , collectionViewLayout: .init())
        func getQuestionsView () -> UICollectionView
    {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: self.cellWidth, height: self.cellHeight)
        layout.minimumLineSpacing = 0.uiX
        layout.minimumInteritemSpacing = 0.uiX
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(cellWithClass: HomeQuestionCell.self)
        
        collectionView.width = self.cellWidth * CGFloat(self.questionsMaxRow)
        collectionView.height = self.cellHeight * CGFloat(self.questionsMaxRow)
        collectionView.y = UIDevice.statusBarHeight + 170.uiX
        collectionView.x = (375.uiX - collectionView.width)/2.0
        
        return collectionView
    }
    
    private var answersView: UICollectionView = UICollectionView(frame:.zero , collectionViewLayout: .init())
    func getAnswersView () -> UICollectionView
    {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: self.cellWidth, height: self.cellHeight)
        layout.minimumLineSpacing = 0.uiX
        layout.minimumInteritemSpacing = 0.uiX
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(cellWithClass: HomeAnswerCell.self)
        
        collectionView.width = self.cellWidth * CGFloat(self.questionsMaxRow)
        collectionView.height = self.cellHeight * 3
        collectionView.y = self.questionsView.y + self.questionsView.height
        collectionView.x = (375.uiX - collectionView.width)/2.0
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hbd_barHidden = true
        
        addData()
        
        baseChange()
        
        setupUI()
        
    }
    
    private func baseChange() {
        
        self.cellWidth = 42.uiX * 7 / CGFloat(self.questionsMaxRow)
        self.cellHeight = self.cellWidth
        
    }
    
    private func reloadColloctionView() {
        
        self.questionsView.removeFromSuperview()
        self.answersView.removeFromSuperview()
        self.questionsView = getQuestionsView()
        self.answersView = getAnswersView()
        
        self.view.addSubview(self.questionsView)
        self.view.addSubview(self.answersView)
        
    }
    
    
//    override var prefersStatusBarHidden: Bool {
//
//        return true
//    }
    
    private func addData() {
        //mark : 设置关卡
        guard let lastLevel = UserManager.shared.user?.lastCheckpointRewardNum else {return}
        self.nowlel = lastLevel + 1
        let path = Bundle.main.path(forResource: "level_\(self.nowlel)", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let dataString:String = (NSString(data: jsonData! as Data, encoding: String.Encoding.utf8.rawValue))! as String
        let json = JSON.init(parseJSON: dataString)
        let model = HomeQuestionModel.init(json: json)
        
        //计算最大row确定范围
        var maxRow = 0
        
        for item in model.posx {
            if item > maxRow {
                maxRow = item
            }
        }
        for item in model.posy {
            if item > maxRow {
                maxRow = item
            }
        }
        
        self.questionsMaxRow = maxRow + 1
        
        let dataArray = NSMutableArray()
        
        let answerDataArray = NSMutableArray()
        
        var x = 0
        
        
        for _ in 0..<self.questionsMaxRow {
            let array = NSMutableArray()
            var y = 0
            for _ in 0..<self.questionsMaxRow {
                var model = HomeQuestionCellModel()
                model.word = ""
                model.posx = x
                model.posy = y
                model.isAnswer = false
                model.showWord = ""
                
                array.add(model)
                y += 1
            }
            x += 1
            dataArray.add(array)
        }
        
        let wordArray = NSMutableArray()
        
        let count = model.word.count
        
        var z = 0
        var answerIndexNum = 0
        for _ in 0..<count {
            let px : Int = model.posx[z]
            let py : Int = self.questionsMaxRow - 1 - model.posy[z]
            
            let array = dataArray[px] as! NSMutableArray
            
            var cellModel : HomeQuestionCellModel = array[py] as! HomeQuestionCellModel
            cellModel.word = model.word[z]
            cellModel.showWord = model.word[z]
            for item in model.answer {
                if z == item {
                    cellModel.isAnswer = true
                    cellModel.showWord = ""
                    cellModel.inAnswerArrayIndex = answerIndexNum
                    answerDataArray.add(cellModel)
                    
                    var wordModel = HomeAnswerCellModel()
                    wordModel.word = cellModel.word
                    wordModel.index = answerIndexNum
                    wordArray.add(wordModel)
                    answerIndexNum += 1
                }
            }
            array[py] = cellModel
            z += 1
        }
        
        self.answerWordsArray = wordArray
        
        //答案数组单独记录
        self.answerIndexArray = answerDataArray.mutableCopy() as? NSMutableArray
        var itemIndex = 0
        let answerDataArrayCount = answerDataArray.count
        for _ in 0..<answerDataArrayCount {
            var i :HomeQuestionCellModel = answerDataArray[itemIndex] as!HomeQuestionCellModel
            i.showWord = i.word
            i.inAnswerArrayIndex = itemIndex
            answerDataArray[itemIndex] = i
            itemIndex += 1
        }
        
        self.dataArray = dataArray
        

    }
    
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(self.homeBGView)
        self.homeBGView.delegate = self
                
        let questionsView = getQuestionsView()
        self.questionsView = questionsView
        view.addSubview(self.questionsView)
        
        let answersView = getAnswersView()
        self.answersView = answersView
        view.addSubview(self.answersView)
        
        addTarget()
        
        updataUI()
        
        setupBinding()
        
        jumpNextEmptySelectModel()
        
    }
    
    private func setupBinding()  {
        UserManager.shared.login.subscribe(onNext: {[weak self] (u, s) in
            guard let self = self else { return }
            guard let u = u else { return }
            self.homeBGView.tixianLabel.text = "\(u.redPacket ?? "")元"
            self.homeBGView.hongbaoLabel.text = "\(u.goldCoin ?? 0)"
            u.difRelay.subscribe(onNext: { (all,now,sub,pr,isShow) in
                /// 总关卡值  当前关卡值  差多少关  进度  是否显示提现
                self.homeBGView.progressView.getCashChange(all: all, now: now, sub: sub, pr: pr, isShow: isShow)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
    }
    
    
    private func getAnswersModelIndexPath(index : Int) -> IndexPath {
        //计算model下标
        let row = index%self.questionsMaxRow
        var section = 0
        var sum = index
        for _ in 0..<self.answerWordsArray!.count {
            sum = sum - self.questionsMaxRow
            if sum<0 {
                break
            }
            section += 1
        }
        return IndexPath.init(row: row, section: section)
    }
    
    
    private func getQuestionsModel(row : Int,section : Int) -> HomeQuestionCellModel {
        
        let array = dataArray?[row] as! NSMutableArray
        let model = array[section] as! HomeQuestionCellModel
        
        return model
    }
    
    private func getAnswersModel(row : Int,section : Int) -> HomeAnswerCellModel {
                
        let index = row + section*self.questionsMaxRow
        var model:HomeAnswerCellModel = HomeAnswerCellModel()
        if (index<self.answerWordsArray!.count){
            model = self.answerWordsArray?[index] as! HomeAnswerCellModel
        }
        
        return model
    }
    
    private func updateQuestionsModel(row : Int,section : Int,model : HomeQuestionCellModel) {
        
        let array = self.dataArray?[row] as! NSMutableArray

        array[section] = model

    }
    
    private func updateAnswersIndexArrayData() {
        let newArray = NSMutableArray()
        var count = 0
        for _ in 0..<self.answerIndexArray!.count {
            let model = self.answerIndexArray![count] as! HomeQuestionCellModel
            let newModel = getQuestionsModel(row: model.posx, section: model.posy)
            newArray.add(newModel)
            count += 1
        }
        
        self.answerIndexArray = newArray
    }
    
    private func clearUpSelectData() {
        var count = 0
        for _ in 0..<self.answerIndexArray!.count {
            let model = self.answerIndexArray![count] as! HomeQuestionCellModel
            var newModel = getQuestionsModel(row: model.posx, section: model.posy)
            newModel.isSelected = false
            updateQuestionsModel(row: model.posx, section: model.posy, model: newModel)
            count += 1
        }
        
    }
    
    private func updateAnswersModel(row : Int,section : Int,model : HomeAnswerCellModel) {
        
        let index = row + section*self.questionsMaxRow

        self.answerWordsArray?[index]  = model

    }
    
    private func updateAnswersModelWithIndex(index : Int,model : HomeAnswerCellModel) {

        self.answerWordsArray?[index]  = model

    }
    
    private func jumpNextEmptySelectModel() {
        
        updateAnswersIndexArrayData()
        
        if self.selectQuestionModel != nil {
            let qModel = getQuestionsModel(row: self.selectQuestionModel!.posx, section: self.selectQuestionModel!.posy)
            if !qModel.isRight {
                return
            }
        }
        
        var model :HomeQuestionCellModel? = nil
        let mArray = NSMutableArray()
        for item in self.answerIndexArray! {
            let it :HomeQuestionCellModel = item as! HomeQuestionCellModel
            if it.showWord.count<1 {
                model = it
                mArray.add(model!)
            }
        }
        //优先同一条线连起来的成语
        let sameArray = NSMutableArray()
        if (self.selectQuestionModel != nil) {
            for item in mArray {
                let it :HomeQuestionCellModel = item as! HomeQuestionCellModel
                if it.posx == self.selectQuestionModel!.posx || it.posy == self.selectQuestionModel!.posy {
                    model = it
                    sameArray.add(model!)
                }
            }
        }
        
        if sameArray.count>0 {
            if self.selectQuestionModel == nil {
                let randomNumber:Int = Int(arc4random()) % mArray.count
                model =  (mArray[randomNumber] as! HomeQuestionCellModel)
            } else {
                var minNum = 100
                let px = self.selectQuestionModel!.posx
                let py = self.selectQuestionModel!.posy
                for item in sameArray {
                    let mModel = item as! HomeQuestionCellModel
                    let sum = abs(mModel.posx - px!) + abs(mModel.posy - py!)
                    if sum < minNum {
                        minNum = sum
                        model = mModel
                    }
                }
            }
        }
        
        
        if mArray.count>0 && model == nil{
            if self.selectQuestionModel == nil {
                let randomNumber:Int = Int(arc4random()) % mArray.count
                model =  (mArray[randomNumber] as! HomeQuestionCellModel)
            } else {
                var minNum = 100
                let px = self.selectQuestionModel!.posx
                let py = self.selectQuestionModel!.posy
                for item in mArray {
                    let mModel = item as! HomeQuestionCellModel
                    let sum = abs(mModel.posx - px!) + abs(mModel.posy - py!)
                    if sum < minNum {
                        minNum = sum
                        model = mModel
                    }
                }
            }
            
        }
        
        
        
        //填上但是有错的情况
        if model == nil {
            for item in self.answerIndexArray! {
                let it :HomeQuestionCellModel = item as! HomeQuestionCellModel
                if (it.showWord != it.word!) {
                        model = it
                    }
            }
        }
        
        if model == nil {
            //所有都填完了
            self.selectQuestionModel = nil
            self.isGameOver = true
        } else {
            //跳转下一个
            clearUpSelectData()
            updateAnswersIndexArrayData()
            model!.isSelected = true
            self.selectQuestionModel = model
            updateQuestionsModel(row: model!.posx, section: model!.posy, model: model!)
            self.questionsView.reloadData()

        }
        
    }
    
    func updataUI() {
        
        self.questionsView.width = (self.cellWidth+2.uiX) * CGFloat(self.questionsMaxRow)
        self.questionsView.height = (self.cellWidth) * CGFloat(self.questionsMaxRow)
        
        self.answersView.y = self.questionsView.y + self.questionsView.height + 5.uiX
        self.questionsView.x = (UIDevice.screenWidth - self.questionsView.width)/2
        self.answersView.x = self.questionsView.x
        
        self.homeBGView.gameTitleLabel.text = "第\(self.nowlel)关"
    }
    
    func reSetData() {
        self.dataArray  = NSMutableArray()

        self.answerIndexArray  = NSMutableArray()
        self.answerWordsArray  = NSMutableArray()
        
        self.selectQuestionModel = nil
        
        self.isGameOver = false
    }
    @objc func replayButtonAction() {
        
        //判断是否有重玩次数
        guard let playAgainNum = UserManager.shared.user?.playAgainNum else { return }
//        if playAgainNum > 0 {
            guard let user = UserManager.shared.user else { return }
            user.playAgainNum = playAgainNum - 1
            UserManager.shared.login.accept((user, .change))
//        } else {
//            let showAD: () -> Void = {[weak self] in
//                guard let self = self else { return }
//                let ad = RewardVideoSingleAd.shared
//                ad.showAd(vc: self)
//                ad.completion = {
//                    self.requestAddTipsRePlayNum().subscribe(onNext: {
//                        guard let user = UserManager.shared.user else { return }
//                        user.playAgainNum = 2
//                        UserManager.shared.login.accept((user, .change))
//                    }, onError: { error in
//
//                    }).disposed(by: self.rx.disposeBag)
//                }
//            }
//            showAD()
//            return
//        }
        
        rebuildGmae()
    }
    
    @objc func rebuildGmae() {
        
        reSetData()
        
        addData()
        
        baseChange()
                
        updataUI()
        
        updataColloction()
        
        jumpNextEmptySelectModel()
        
    }
    
    @objc func updataColloction() {
        
        self.questionsView.reloadData()
        
        self.answersView.reloadData()
    }
    
    @objc func showHowPlay() {
        
        PopView.show(view:self.homeBGView.howPlayView )
        
    }
    
    @objc func showUserView() {

        PopView.show(view:self.homeBGView.homeUserView )
        
    }
    
    @objc func showSignView() {
        PopView.show(view:self.homeSignView)
        _ = homeSignView.getOnlineTime()
    }
    
    @objc func finishGame() {
        
        showHUD(text: "闯关成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showRedPacketView()
        }
        
    }
    func showRedPacketView ()  {
        let view = PassGameRedPacketView()
        view.delegate = self
        view.showWithLevel(level: self.nowlel)
        PopView.show(view:view)
    }
    func nextGame () {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.rebuildGmae()
        }
    }
    
    func addTarget () {
        homeBGView.replayButton.addTarget(self, action: #selector(replayButtonAction) , for:.touchUpInside )
        homeBGView.howPlayButton.addTarget(self, action: #selector(showHowPlay) , for:.touchUpInside )
        homeBGView.tipButton.addTarget(self, action: #selector(tipButtonAction) , for:.touchUpInside )
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showUserView))
        homeBGView.iconImageView.addGestureRecognizer(tap)
        homeBGView.homeUserView.fwButton!.addTarget(self, action: #selector(jumpServiceAction) , for:.touchUpInside )
        homeBGView.homeUserView.ysButton!.addTarget(self, action: #selector(jumpPrivacyAction) , for:.touchUpInside)
        homeBGView.homeUserView.zxButton!.addTarget(self, action: #selector(closeAccount) , for:.touchUpInside)
        
        homeBGView.signButton.addTarget(self, action: #selector(showSignView) , for:.touchUpInside )
        homeBGView.drawButton.addTarget(self, action: #selector(gotoGetCashVC) , for:.touchUpInside )
        
        
        let topTipTap = UITapGestureRecognizer.init(target: self, action: #selector(showTilteLevelView))
        homeBGView.topTipView.addGestureRecognizer(topTipTap)
        
        homeBGView.hongbaoButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.homeExchangeRadPacket(controller: self)
        }).disposed(by: rx.disposeBag)
        homeBGView.tixianButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.homeDidGetCash(controller: self)
        }).disposed(by: rx.disposeBag)
        homeBGView.homeUserView.getCashButton?.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.homeBGView.homeUserView.close()
            self.delegate?.homeDidGetCash(controller: self)
        }).disposed(by: rx.disposeBag)
        homeBGView.progressView.xiaohongbaoButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.homeDidGetCash(controller: self)
        }).disposed(by: rx.disposeBag)
    }
    
    func showHUD(text: String)  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                   hud.mode = .text
                   hud.label.text = text
                   hud.bezelView.style = .solidColor
                   hud.bezelView.color = .init(white: 0, alpha: 0.8)
                   hud.contentColor = .white
                   hud.hide(animated: true, afterDelay: 1.5)
                   
    }
    @objc func showTilteLevelView () {
        
        PopView.show(view: HomeTitleLevelView(action: {
            
        }), needAd: false, needNav: false)
     
        
    }
    
    @objc func closeAccount () {
           
           self.homeBGView.homeUserView.close()
        
           showHUD(text: "用户已注销")
       }
    
    @objc func tipButtonAction() {
        
        //判断是否有提示次数
        guard let tipsNum = UserManager.shared.user?.tipsNum else { return }
//        if tipsNum > 0 {
            guard let user = UserManager.shared.user else { return }
            user.tipsNum = tipsNum - 1
            UserManager.shared.login.accept((user, .change))
//        } else {
//            let showAD: () -> Void = {[weak self] in
//                guard let self = self else { return }
//                let ad = RewardVideoSingleAd.shared
//                ad.showAd(vc: self)
//                ad.completion = {
//                    self.requestAddTipsRePlayNum().subscribe(onNext: {
//                        guard let user = UserManager.shared.user else { return }
//                        user.tipsNum = 3
//                        UserManager.shared.login.accept((user, .change))
//                    }, onError: { error in
//
//                    }).disposed(by: self.rx.disposeBag)
//                }
//            }
//            showAD()
//            return
//        }
        
        if self.selectQuestionModel == nil {
            return
        } else {
                        
            //处理之前填错的答案
            //判断是否有正确答案
            var answerModel :HomeAnswerCellModel?
            var subCount = 0
            for _ in 0..<self.answerWordsArray!.count {
                let subModel = self.answerWordsArray![subCount] as! HomeAnswerCellModel
                if (subModel.word == self.selectQuestionModel!.word) && !subModel.isFill {
                    answerModel = subModel
                    break
                }
                subCount += 1
            }
            updateAnswersIndexArrayData()
            var showCount = 0
            if answerModel == nil {
                for _ in 0..<self.answerIndexArray!.count {
                    var model = self.answerIndexArray![showCount] as! HomeQuestionCellModel
                    if (model.showWord == self.selectQuestionModel!.word) && (!model.isEnd) {
                        let sWord = model.showWord
                        model.showWord = ""
                        model.isRight = true
                        updateQuestionsModel(row: model.posx, section: model.posy, model: model)
                        self.answerIndexArray![subCount] = model
                        
                        var subCount = 0
                        for _ in 0..<self.answerWordsArray!.count {
                            var subModel = self.answerWordsArray![subCount] as! HomeAnswerCellModel
                            if (subModel.word == sWord) && subModel.isFill {
                                subModel.isFill = false
                                self.answerWordsArray![subModel.index] = subModel
                                answerModel = subModel
                                break
                            }
                            subCount += 1
                        }
                        
                        break
                    }
                    showCount += 1
                }
                
                
            }
            
            if answerModel != nil {
                let indexPath = getAnswersModelIndexPath(index: answerModel!.index)
                self.collectionView(self.answersView, didSelectItemAt: IndexPath.init(row: indexPath.row, section: indexPath.section))
                return
            }
            
        }
    }
    
    @objc func gotoGetCashVC() {
        let getCashViewController = GetCashViewController()
        self.navigationController?.pushViewController(getCashViewController)
    }
    
    @objc func jumpServiceAction() {
        
        let nav = self.navigationController
//        let u = UserManager.shared.configure?.page
        let web = WebViewController()
//        web.url = URL(string: u?.userAgreement)
        web.url = URL(string: "http://www.ynxxhy.com/pages/user_agreement")
        nav!.pushViewController(web)
        
        
    }
    
    @objc func jumpPrivacyAction() {
        let nav = self.navigationController
//        let u = UserManager.shared.configure?.page
        let web = WebViewController()
//        web.url = URL(string: u?.privacyPolicy)
        web.url = URL(string: "http://www.ynxxhy.com/pages/privacy_policy")
        nav!.pushViewController(web)
        
        
    }
    
    func getModelChange(model: HomeQuestionCellModel) {
        
        let indexX : Int = model.posx
        let indexY : Int = model.posy
        
        //拿到这个model相邻的所有字
        //拿到Y轴的所有相邻字(x相等)
        let arrayY = NSMutableArray()
        arrayY.add(model)
        var numY = indexY
        for _ in 0..<indexY {
            if numY > 0 {
                numY -= 1
            } else {
                break
            }
            let getQmodel = getQuestionsModel(row: indexX, section: numY)
            if getQmodel.word.count>0 {
                arrayY.insert(getQmodel, at: 0)
            } else {
                break
            }
        }
        numY = indexY
        for _ in 0..<(self.questionsMaxRow - 1 - indexY) {
            if numY < self.questionsMaxRow - 1 {
                numY += 1
            } else {
                break
            }
            let getQmodel = getQuestionsModel(row: indexX, section: numY)
            if getQmodel.word.count>0 {
                arrayY.add(getQmodel)
            } else {
                break
            }
        }
        
        //拿到X轴的所有相邻字(y相等)
        let arrayX = NSMutableArray()
        arrayX.add(model)
        var numX = indexX
        for _ in 0..<indexX {
            if numX > 0 {
                numX -= 1
            } else {
                break
            }
            let getQmodel = getQuestionsModel(row:numX , section: indexY)
            if getQmodel.word.count>0 {
                arrayX.insert(getQmodel, at: 0)
            } else {
                break
            }
        }
        numX = indexX
        for _ in 0..<(self.questionsMaxRow - 1 - indexX) {
            if numX < self.questionsMaxRow - 1 {
                numX += 1
            } else {
                break
            }
            let getQmodel = getQuestionsModel(row: numX, section: indexY)
            if getQmodel.word.count>0 {
                arrayX.add(getQmodel)
            } else {
                break
            }
        }
        
        //处理数据
        let allArray = NSMutableArray()
        allArray.add(arrayX)
        allArray.add(arrayY)
        var passCount = 0
        var haveMistake  = false
        var haveRight = false
        let selfModel = model
        for item in allArray {
            let array = item as! NSArray
            if array.count<4 {
                continue
            } else {
                passCount += 1
            }
            //是否全部填完
            var isAllEnd = true
            var isAllRight = true
            for item in array {
                let model = item as! HomeQuestionCellModel
                if model.showWord.count<1 {
                    isAllEnd = false
                }
                
                if model.word != model.showWord {
                    isAllRight = false
                }
            }
            
            if isAllEnd {
                //全部完成后判断对错(有错答案全算错)
                let overArray = NSMutableArray()
                if isAllRight {
                    //全对
                    haveRight = true
                    for item in array {
                        var model = item as! HomeQuestionCellModel
                        model.isEnd = true
                        model.isRight = true
                        model.isSelected = false
                        overArray.add(model)
                    }
                } else {
                    haveMistake = true
                    //有错误
                    for item in array {
                        var model = item as! HomeQuestionCellModel
                        if model.isAnswer && !model.isEnd{
                            model.isRight = false
                            //处理同时出现对错显示问题
                            if passCount>1 && haveRight && (model.posx == selfModel.posx) && (model.posy == selfModel.posy){
                                model.isRight = true
                                model.isEnd = true
                            }
                        }
                        overArray.add(model)
                    }
                }
                
                //更改源数据
                for item in overArray {
                    let model = item as! HomeQuestionCellModel
                    updateQuestionsModel(row: model.posx, section: model.posy, model: model)
                    
                }
                
            }
            
           }
        if haveMistake {
            
        } else {
            jumpNextEmptySelectModel()
        }
           self.questionsView.reloadData()
           
       }
       
       
    
}


///mark : UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           if collectionView == self.questionsView {
               return self.questionsMaxRow
           } else {
               return 3
           }
         }
         
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == self.questionsView {
                 return self.questionsMaxRow
             } else {
                 return self.questionsMaxRow
             }
         }
         
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if collectionView == questionsView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! HomeQuestionCell
               cell.model = self.getQuestionsModel(row: indexPath.row, section: indexPath.section)
           
             return cell
           } else {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierA, for: indexPath as IndexPath) as! HomeAnswerCell
           
                   cell.model = self.getAnswersModel(row: indexPath.row, section: indexPath.section)
               
               return cell
           }
       }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //点击题目collocation
        if collectionView == self.questionsView {
            
            //拿到model,不是答案的格子禁止操作
            var getIndexModel = self.getQuestionsModel(row: indexPath.row, section: indexPath.section)
            
            if (!getIndexModel.isAnswer) {
                return
            }
            if (getIndexModel.isEnd) {
                return
            }
            
            //控制选择框
            if self.selectQuestionModel != nil {
                var newModel = getQuestionsModel(row: self.selectQuestionModel!.posx, section: self.selectQuestionModel!.posy)
                newModel.isSelected = false
                updateQuestionsModel(row: self.selectQuestionModel!.posx, section: selectQuestionModel!.posy, model: newModel)
            }
            
            getIndexModel.isSelected = true
            updateQuestionsModel(row: indexPath.row, section: indexPath.section, model: getIndexModel)
            self.questionsView.reloadData()

            //如果之前没有正确的答案,前答案还原
            if(getIndexModel.showWord.count>0) {
                var answerModel : HomeAnswerCellModel?
                for item in self.answerWordsArray! {
                    let itemSub = item as! HomeAnswerCellModel
                    if (itemSub.word == getIndexModel.showWord) && (itemSub.isFill == true) {
                        answerModel = itemSub
                    }
                }
                if answerModel != nil {
                    answerModel!.isFill = false
                    self.answerWordsArray![answerModel!.index] = answerModel!
                    self.answersView.reloadData()
                }
                getIndexModel.showWord = ""
                if (self.selectQuestionModel!.showWord.count<1) {
                    getIndexModel.isRight = true
                }
                updateQuestionsModel(row: getIndexModel.posx, section: getIndexModel.posy, model: getIndexModel)
                self.questionsView.reloadData()
            }
            
            self.selectQuestionModel = getIndexModel;
            
        }
        
        //点击答案collocation
        if collectionView == self.answersView {
            //拿到model,不是答案的格子禁止操作,选择过的禁止操作
            var getIndexModel = self.getAnswersModel(row: indexPath.row, section: indexPath.section)
            //判断是否有值
            if getIndexModel.word.count<1 {
                return
            }
            //判断点击模型是否有效
            if getIndexModel.isFill {
                return
            }
            //处理上一个选择的model
            if self.selectQuestionModel != nil {
                
                //如果上一个选择的model填过词,要把词还原
                if self.selectQuestionModel!.showWord.count>0 {

                    var answerModel = self.answerWordsArray![self.selectQuestionModel!.inAnswerArrayIndex] as! HomeAnswerCellModel
                    answerModel.isFill = false
                    self.answerWordsArray![self.selectQuestionModel!.inAnswerArrayIndex] = answerModel
                }
                //现在的要消失
                self.selectQuestionModel!.showWord = getIndexModel.word
                self.selectQuestionModel!.inAnswerArrayIndex = getIndexModel.index
                getIndexModel.isFill = true
                
                updateQuestionsModel(row: self.selectQuestionModel!.posx, section: self.selectQuestionModel!.posy, model: self.selectQuestionModel!)
                updateAnswersModel(row: indexPath.row, section: indexPath.section, model: getIndexModel)
                
                self.answersView.reloadData()
                getModelChange(model: self.selectQuestionModel!)
            } else {
                //未选择任何空格返回
                return
            }

            if self.isGameOver {
                finishGame()
                return
            }
        }
        
    }
}

extension HomeViewController {
    // MARK: - Request
    private func requestAddTipsRePlayNum() -> Observable<Void>{
        return NetManager.requestResponse(.addTipsRePlayNum).asObservable()
        
    }
}
