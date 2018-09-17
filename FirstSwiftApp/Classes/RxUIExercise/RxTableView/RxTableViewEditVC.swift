//
//  RxTableViewEditVC.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/9/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

enum TableEditingCommand {
    case setItems(items: [String])
    case addItem(item: String)
    case moveItem(from: IndexPath, to: IndexPath)
    case deleteItem(IndexPath)
}

struct TableViewModel {
    fileprivate var items:[String]
    
    init(items: [String] = []) {
        self.items = items
    }
    
    func execute(command: TableEditingCommand) -> TableViewModel {
        switch command {
        case .setItems(let items):
            print("设置表格数据")
            return TableViewModel(items: items)
        case .addItem(let item):
            print("新增数据项")
            var items = self.items
            items.append(item)
            return TableViewModel(items: items)
        case .moveItem(let from, let to):
            print("移动数据项")
            var items = self.items
            items.insert(items.remove(at: from.row), at: to.row)
            return TableViewModel(items: items)
        case .deleteItem(let indexPath):
            print("删除数据项")
            var items = self.items
            items.remove(at: indexPath.row)
            return TableViewModel(items: items)
        }
    }
}

class RxCustomCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.cyan
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RxTableViewEditVC: RootVC {
    
    let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: naviHeight, width: screenWidth, height: screenHeight - naviHeight), style: .plain)
        tab.register(RxCustomCell.self, forCellReuseIdentifier: "Cell")
        return tab
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton(frame: (self.rightBtn?.frame)!)
        btn.right = (self.rightBtn?.left)! - 8
        btn.backgroundColor = UIColor.blue
        btn.setTitle("＋", for: .normal)
        self.rightBtn?.setTitle("刷新", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviView(title: "RxTableViewEdit")
        
        self.view.addSubview(self.tableView)
        self.naviView?.addSubview(self.addButton)
        
        unitOne()
    }
    
    func unitOne() {
        let initialVM = TableViewModel()
        
        let refreshCommand = rightBtn!.rx.tap.asObservable()
            .startWith(())
            .flatMap(getRandomResult)
            .map(TableEditingCommand.setItems)
        
        let addCommand = addButton.rx.tap.asObservable()
            .map{"\(arc4random())"}
            .map(TableEditingCommand.addItem)
        
        let moveCommand = tableView.rx.itemMoved
            .map(TableEditingCommand.moveItem)
        
        let deleteCommand = tableView.rx.itemDeleted
            .map(TableEditingCommand.deleteItem)
        
        Observable.of(refreshCommand,addCommand,moveCommand,deleteCommand)
            .merge()
            .scan(initialVM) { (vm: TableViewModel, command: TableEditingCommand)
                -> TableViewModel in
                    return vm.execute(command: command)
            }
            .startWith(initialVM)
            .map{
                [AnimatableSectionModel(model: "", items: $0.items)]
            }
            .share(replay: 1)
            .bind(to: tableView.rx.items(dataSource: RxTableViewEditVC.dataSource()))
            .disposed(by:disposeBag)
        
    }
    
    func getRandomResult() -> Observable<[String]> {
        print("生成随机数据")
        let items = (0 ..< 5).map { _ in
            "\(arc4random())"
        }
        return Observable.just(items)
    }
    
}

extension RxTableViewEditVC {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource
        <AnimatableSectionModel<String,String>> {
            return RxTableViewSectionedAnimatedDataSource (
                animationConfiguration: AnimationConfiguration(insertAnimation:.top,
                                                               reloadAnimation:.fade,
                                                               deleteAnimation:.left),
                configureCell : {
                    (dataSource, tv, indexPath, element) in
                    let cell = tv.dequeueReusableCell(withIdentifier:"Cell")!
                    cell.textLabel?.text = "条目\(indexPath.row):\(element)"
                    return cell
                },
                
                canEditRowAtIndexPath: { _,_ in
                    return true
                },
                
                canMoveRowAtIndexPath: { _,_ in
                    return true
                }
            )
    }
}
