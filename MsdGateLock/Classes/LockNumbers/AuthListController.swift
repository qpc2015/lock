//
//  AuthListController.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/28.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import Kingfisher

class AuthListController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var line: UIView!
    
    var lockModel : UserLockListResp?   //对应锁信息
    var userInfoArr : [AuthInfoListResp]?

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAuthListData() 
    }
}


extension AuthListController{
    
    func setupUI(){
        let totalCount : Int = (self.userInfoArr?.count)!
        totalLabel.text = "授权用户（\(totalCount)位）"

        let itemHeight : CGFloat = 140.0
//        let collHeight  = CGFloat((totalCount - 1) / 3 + 1) * itemHeight
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 44 - 64 - 70))
        backView.backgroundColor = UIColor.white
        self.view.insertSubview(backView, at: 0)
        
        totalLabel.textColor = kRGBColorFromHex(rgbValue: 0x858585)
        line.backgroundColor = kRGBColorFromHex(rgbValue: 0xf0f0f0)
        
        let ownerKO = (userInfoArr?.first?.userTel == UserInfo.getPhoneNumber())
        
        //定义布局样式
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
//        let collHeight  = CGFloat((count - 1) / 3 + 1) * 155.0

//        QPCLog(collHeight)
        let leftMagin : CGFloat = 15.0
        let collecWidth = kScreenWidth - 2*leftMagin
        var collecFrame : CGRect!
        if ownerKO{
            collecFrame = CGRect(x: leftMagin, y: 40, width: collecWidth, height: kScreenHeight - 220)
        }else{
            collecFrame = CGRect(x: leftMagin, y: 40, width: collecWidth, height: kScreenHeight - 170)
        }

        let spacing : CGFloat = 12.0
        let itemWidth = (collecWidth - spacing * 2) / 3.0
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: collecFrame, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName:"AuthIconCollectionCell",bundle:nil), forCellWithReuseIdentifier: "AuthIconCollectionCell")
        self.view.addSubview(collectionView)
        
        if ownerKO{
            self.view.backgroundColor = kGlobalBackColor
            
            let addAuthNumberBtn = UIButton(type: .custom)
            addAuthNumberBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            addAuthNumberBtn.setTitle("添加授权成员", for: .normal)
            addAuthNumberBtn.backgroundColor = kTextBlueColor
            addAuthNumberBtn.layer.cornerRadius = 4.0
            addAuthNumberBtn.layer.masksToBounds = true
            addAuthNumberBtn.addTarget(self, action: #selector(addAuthorizaNumbersClick(_:)), for: .touchUpInside)
            view.addSubview(addAuthNumberBtn)
            addAuthNumberBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo(view)
                make.top.equalTo(collectionView.snp.bottom).offset(10)
                make.width.equalTo(184)
                make.height.equalTo(50)
            }
        }
    }
}

extension AuthListController{
    
    func getAuthListData(){
        let req = BaseReq<AuthInfoListReq>()
        req.action = GateLockActions.ACTION_UserRoleInfo
        req.sign = LockTools.getSignWithStr(str: "oxo")
        req.sessionId = UserInfo.getSessionId() ?? ""
        req.data = AuthInfoListReq(UserInfo.getUserId() ?? 0, lockId: lockModel?.lockId ?? "", roleType: 1)
        
        weak var weakSelf = self
        AjaxUtil<AuthInfoListResp>.actionArrPost(req: req) { (resp) in
            QPCLog(resp.data)
            weakSelf?.userInfoArr = resp.data
            weakSelf?.setupUI()
        }
    }
    
    @objc func addAuthorizaNumbersClick(_ btn : UIButton) {
        
        let addAuthorVC = UIStoryboard(name: "AddAuthorizaMemberController", bundle: nil).instantiateViewController(withIdentifier: "AddAuthorizaMemberController") as! AddAuthorizaMemberController
        addAuthorVC.lockModel = lockModel
        navigationController?.pushViewController(addAuthorVC, animated: true)
        
    }
    
    //获取授权用户详情
    fileprivate func authUserClick(index : Int) {
        let authVC = UIStoryboard(name: "AuthUserDetailController", bundle: nil).instantiateViewController(withIdentifier: "AuthUserDetailController") as! AuthUserDetailController
        authVC.userModel = userInfoArr?[index]
        authVC.lockModel = lockModel
        authVC.isCurrentOwner = (userInfoArr?.first?.userTel == UserInfo.getPhoneNumber())
        navigationController?.pushViewController(authVC, animated: true)
    }
    
}


extension AuthListController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     - returns: Section中Item的个数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userInfoArr?.count ?? 0
    }
    
    /**
     - returns: 绘制collectionView的cell
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = self.userInfoArr?[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthIconCollectionCell", for: indexPath) as! AuthIconCollectionCell

        //判断是否过期"2017-06-24T21:51:03"
        if LockTools.checkIsOvertime(stringTime: (model?.endTime)!){
            cell.imageView.image = UIImage(named: "yiguoqi")
        }else{
            cell.imageView.kf.setImage(with: URL(string: model?.userImage ?? ""))
        }

//        let owerName = UserDefaults.standard.object(forKey: UserInfo.userName) as! String
//        if (model?.memberName.characters.count)! > 0 {
        cell.nameLabel.text = model?.sourceName
//        }else if owerName.characters.count > 0 {
//            cell.nameLabel.text = owerName
//        }else{
//            cell.nameLabel.text = model?.userTel.phoneNumToAsterisk()
//        }
        ///判断是否是onwer
        if model?.roleType == 0{
            cell.isAdmin = true
        }
        return cell
    }
    
    // #MARK: --UICollectionViewDelegate的代理方法
    /**
     Description:当点击某个Item之后的回应
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("(\(indexPath.section),\(indexPath.row))")
        
        authUserClick(index: indexPath.row)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0, 16, 0, 0)
//    }
    
}




