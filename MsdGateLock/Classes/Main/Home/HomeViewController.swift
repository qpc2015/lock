//
//  HomeViewController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/12.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var lockTableView: UITableView!
    @IBOutlet weak var eleqLabel: UILabel!
    @IBOutlet weak var inLockLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var openLockBtn: UIButton!
    @IBOutlet weak var doorListLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var tipLockLabel: UILabel!
    @IBOutlet weak var lockNumbersBtn: BottomButton!
    @IBOutlet weak var lockSetBtn: BottomButton!
    @IBOutlet weak var centerLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    
    lazy var popVerAnimatior : PopoverAnimator = PopoverAnimator(callBack: {[weak self] (isPresent) in
        self?.titleBtn.isSelected = isPresent
    })
    
    override func viewWillAppear(_ animated: Bool) {
        [super.viewWillAppear(animated)]
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupStyle()
        
    }

}


//MARK:- UI
extension HomeViewController{
    
    fileprivate func setupNavigationBar(){

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named : "message icon "), style: .plain, target: self, action: #selector(HomeViewController.messageCenterClick))
        
        let item1 =  UIBarButtonItem.init(image: UIImage(named : "user"), style: .plain, target: self, action: #selector(HomeViewController.personCenterClick))
        
        let item2 =  UIBarButtonItem.init(image: UIImage(named : "add"), style: .plain, target: self, action: #selector(HomeViewController.addLockClick))
        navigationItem.rightBarButtonItems = [item1,item2]
        
        titleBtn.setTitle("家", for: .normal)
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleViewClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    fileprivate func setupStyle(){
        lockTableView.isScrollEnabled = false
        lockTableView.rowHeight = 27
        lockTableView.separatorStyle = .none
        
        eleqLabel.textColor = kRGBColorFromHex(rgbValue: 0x3d3d3d)
        inLockLabel.textColor = kRGBColorFromHex(rgbValue: 0x3d3d3d)
        powerLabel.textColor = kRGBColorFromHex(rgbValue: 0x4c4c4c)
        doorListLabel.textColor = kRGBColorFromHex(rgbValue: 0x595959)
        moreBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x444444), for: .normal)
        tipLockLabel.textColor = kRGBColorFromHex(rgbValue: 0x2282ff)
        
        centerLine.backgroundColor = kRGBColorFromHex(rgbValue: 0xe9e9e9)
        bottomLine.backgroundColor = kRGBColorFromHex(rgbValue: 0xe9e9e9)
        lockNumbersBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x2282ff), for: .normal)
        lockSetBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x2282ff), for: .normal)
    }
    
}

//MARK:- 相应事件
extension HomeViewController{
    
    func personCenterClick(){
        QPCLog("person")
    }
    
    func messageCenterClick(){
        QPCLog("message")
    }
    
    func addLockClick(){
        QPCLog("login")
    }
    
    @objc fileprivate func titleViewClick(_ titleBtn : TitleButton) {
        titleBtn.isSelected = !titleBtn.isSelected
        
        let popOverView = PopoverViewController()
        popOverView.modalPresentationStyle = .custom
        
        popVerAnimatior.presentedFrame = CGRect(x: 150, y: 60, width: 100, height: 150)
        popOverView.transitioningDelegate = popVerAnimatior
        
        
        present(popOverView, animated: true, completion: nil)
    }
    
}


extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentfier = "openLock"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentfier)
        if cell == nil{
            cell = Bundle.main.loadNibNamed("OpenLockCell", owner: nil, options: nil)?.last as? UITableViewCell
        }
        return cell!
    }
    
    
    
    
}

