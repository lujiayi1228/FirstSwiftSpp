//
//  RxTableViewSearchVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class RxTableViewSearchVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    lazy var searchBar : UISearchBar = {
        let search = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 56))
        return search
    }()
    
    lazy var tableView : UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: naviHeight, width: screenWidth, height: screenHeight - naviHeight), style: .plain)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tab.tableHeaderView = self.searchBar
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxTableViewSearch")
        self.view.addSubview(self.tableView)
        
        self.rightBtn!.setTitle("刷新", for: .normal)
        
        unitOne()
    }
    
    func unitOne() {
        let randomResult = self.rightBtn!.rx.tap.asObservable()
            .startWith(())
            .flatMapLatest(getRandomResult)
            .flatMap(filterResult)
            .share(replay: 1)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Int>>(configureCell: {
            (dataSource,tableV,indexPath,element) in
            let cell = tableV.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "条目\(indexPath.row):\(element)"
            return cell
        })

        randomResult
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func getRandomResult() -> Observable<[SectionModel<String,Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map { _ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
    
    func filterResult(data:[SectionModel<String,Int>]) -> Observable<[SectionModel<String,Int>]> {
        return self.searchBar.rx.text.orEmpty
            .flatMapLatest {
                query -> Observable<[SectionModel<String,Int>]> in
                print("正在筛选数据(条件为：\(query)")
                //输入条件为空，则直接返回原始数据
                if query.isEmpty {
                    return Observable.just(data)
                }
                //输入条件不为空，则只返回包含有该文字的数据
                else {
                    var newData:[SectionModel<String,Int>] = []
                    for sectionModel in data {
                        let items = sectionModel.items.filter{"\($0)".contains(query)}
                        newData.append(SectionModel(model: sectionModel.model, items: items))
                    }
                    return Observable.just(newData)
                }
        }
            
    }
}
