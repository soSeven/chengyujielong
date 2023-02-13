//
//  AllTaskViewModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/28.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class AllTaskViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Void>
    }
    
    struct Output {
        let allTaskList: BehaviorRelay<[AllTaskCellViewModel]>
        let todayTaskList: BehaviorRelay<[TodayTaskCellViewModel]>
        let openAllTaskReward: PublishRelay<AllTaskCellViewModel>
        let openTodayTaskReward: PublishRelay<TodayTaskCellViewModel>
        let allTaskRedDot: BehaviorRelay<Bool>
        let todayTaskRedDot: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let allTaskList = BehaviorRelay<[AllTaskCellViewModel]>(value: [])
        let todayTaskList = BehaviorRelay<[TodayTaskCellViewModel]>(value: [])
        let openAllTaskReward = PublishRelay<AllTaskCellViewModel>()
        let openTodayTaskReward = PublishRelay<TodayTaskCellViewModel>()
        let allTaskRedDot = BehaviorRelay<Bool>(value: true)
        let todayTaskRedDot = BehaviorRelay<Bool>(value: true)
        
        input.request.subscribe(onNext: { [weak self] j in
            guard let self = self else { return }
            Observable.zip(self.requestAllTask().asObservable(), self.requestTodayTask().asObservable()).subscribe(onNext: {[weak self] (allM, todayM) in
                guard let self = self else { return }
                let allList = allM?.taskList.filter{ $0.rewardStatus == 0 }.sorted(by: {$0.status > $1.status}).map({ taskM -> AllTaskCellViewModel in
                    let taskVM = AllTaskCellViewModel(model: taskM)
                    taskVM.openReward.bind(to: openAllTaskReward).disposed(by: self.rx.disposeBag)
                    return taskVM
                }) ?? []
                allTaskList.accept(allList)
                if let n = allM?.rewardCountLeft, n > 0 {
                    allTaskRedDot.accept(false)
                }
                
                let todayList = todayM?.taskListToday.filter{ $0.rewardStatus == 0 }.sorted(by: {$0.status > $1.status}).map({ taskM -> TodayTaskCellViewModel in
                    let taskVM = TodayTaskCellViewModel(model: taskM)
                    taskVM.openReward.bind(to: openTodayTaskReward).disposed(by: self.rx.disposeBag)
                    return taskVM
                }) ?? []
                todayTaskList.accept(todayList)
                if let n = todayM?.rewardCountLeftToday, n > 0 {
                    todayTaskRedDot.accept(false)
                }
                
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(allTaskList: allTaskList,
                      todayTaskList: todayTaskList,
                      openAllTaskReward: openAllTaskReward,
                      openTodayTaskReward: openTodayTaskReward,
                      allTaskRedDot: allTaskRedDot,
                      todayTaskRedDot: todayTaskRedDot)
    }
    
    // MARK: - Request
    
    func requestAllTask() -> Observable<AllTaskModel?> {
        return NetManager.requestObj(.allTask, type: AllTaskModel.self).trackError(error).trackActivity(loading)
    }
    
    func requestTodayTask() -> Observable<TodayTaskModel?> {
        return NetManager.requestObj(.todayTask, type: TodayTaskModel.self).trackError(error).trackActivity(loading)
    }
    
}
