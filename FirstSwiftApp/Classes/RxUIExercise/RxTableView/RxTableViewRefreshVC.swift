//
//  RxTableViewRefreshVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class RxTableViewRefreshVC : RootVC {
    
    let disposeBag = DisposeBag()
    
    lazy var tableView : UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: naviHeight, width: self.view.width, height: self.view.height - naviHeight), style: .plain)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxTableViewRefresh")
        self.view.addSubview(self.tableView)
        self.rightBtn?.setTitle("刷新", for: .normal)
        
        unitOne()
    }
    
    //点击刷新，两秒延迟刷新数据
    func unitOne() {
        //随机的表格数据
//        let randomResult = getCanCancelObservable(canCancel: false)
        
        //点击cell取消刷新
        let randomResult = getCanCancelObservable(canCancel: true)
        
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, Int>>(configureCell: {
                (dataSource,tabV,indexPath,element) in
                let cell = tabV.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "条目\(indexPath.row):\(element)"
                return cell
            })
        
        randomResult
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by:disposeBag
        
        )
    }
    
    //含暂停刷新（刷新开始后，获取到数据前可以停止）
    func getCanCancelObservable(canCancel: Bool) -> Observable<[SectionModel<String, Int>]> {
        let randomResult = self.rightBtn!.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .startWith(())
            .flatMapLatest{
                //只去最后一次有效点击，进行刷新，并且当点击cell时，取消刷新
                canCancel ? self.getRandomResult().takeUntil(self.tableView.rx.itemSelected) : self.getRandomResult()
            }
            .share(replay:1)
        
        tableView.rx.itemSelected.subscribe(onNext:{ indexPath in
            print("cellClicked:\(indexPath)")
        }).disposed(by: disposeBag)
        
        return randomResult
    }
    
    func getRandomResult() -> Observable<[SectionModel<String,Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map { _ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model:"S",items:items)])
        return observable.delay(2, scheduler: MainScheduler.instance)//延迟两秒返回数据
    }

}
