//
//  PersonInfoController.swift
//  MsdGateLock
//
//  Created by 覃鹏成 on 2017/7/1.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class PersonInfoController: UITableViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var iconTip: UILabel!
    @IBOutlet weak var nickNameTip: UILabel!
    @IBOutlet weak var mumberTip: UILabel!
    
    var fileURL : URL!
    var model : UserInfoResp?
    var uploadUrl : String = ""
    var iconKey : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人资料"
        self.view.backgroundColor = UIColor.globalBackColor
        self.tableView.tableFooterView = UIView()
        setupUI()
        
        getAvatarUploadKey()
    }

    func setupUI(){
        iconTip.textColor = UIColor.textBlackColor
        nickNameTip.textColor = UIColor.textBlackColor
        mumberTip.textColor = UIColor.textBlackColor
        
        nameLabel.textColor = UIColor.textGrayColor
        numberLabel.textColor = UIColor.textGrayColor
    
        let imgUrl = URL(string: model?.userImage ?? "")
        iconImageView.kf.setImage(with: imgUrl, placeholder: UIImage(named : "user1") , options: nil, progressBlock: nil)
        nameLabel.text = model?.userName
        numberLabel.text = model?.userTel
    }

    //cell线
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.tableView?.responds(to: #selector(setter: UITableViewCell.separatorInset)))!{
            tableView?.separatorInset = UIEdgeInsets.zero
        }
        
        if (tableView?.responds(to: #selector(setter: UIView.layoutMargins)))!{
            tableView?.layoutMargins = UIEdgeInsets.zero
        }
    }
}

//MARK:- CLICK
extension PersonInfoController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func setupAlertViewController(){
        
        weak var weakSelf = self
        let alerVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "从相册选择", style: .default) { (action) in
            QPCLog("相册")
            weakSelf?.openPhotoAlbum()
        }
        let action2 = UIAlertAction(title: "拍照", style: .default) { (action) in
            weakSelf?.openCamera()
        }
        let action3 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alerVC.addAction(action1)
        alerVC.addAction(action2)
        alerVC.addAction(action3)
        present(alerVC, animated: true, completion: nil)
    }
    
    //图片上传
    func uploadImageTask(_ uploadUrl:String,token:String,id:String){
        if self.fileURL == nil
        {
            return
        }
//        weak var weakSelf = self
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(token.data(using: String.Encoding.utf8)!, withName: "token")
            multipartFormData.append(id.data(using: String.Encoding.utf8)!, withName: "item_id")
            multipartFormData.append(self.fileURL!, withName: "f1")
        }, to: uploadUrl).responseJSON(completionHandler: {
            data in
            print("upload finished: \(data)")
            }).response(completionHandler: {
                (encodingResult) in
                switch encodingResult.result {
                case .success(let dataObj):
                    print("upload success result: \(dataObj)")
//                    upload.responseString{
//                        response in
//                        QPCLog(response)
//                        let relult = response.result.value
//                        QPCLog(relult)
//                        weakSelf?.updateUserAvatar(imageUrl: relult!)
//                    }
                case .failure(let encodingError):
                    print(encodingError)
                    print("请求失败")
                }
            })
//        AF.upload(multipartFormData: , to: uploadUrl, encodingCompletion: { (encodingResult) in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseString{
//                    response in
//                    QPCLog(response)
//                    let relult = response.result.value
//                    QPCLog(relult)
//                    weakSelf?.updateUserAvatar(imageUrl: relult!)
//                }
//            case .failure(let encodingError):
//                print(encodingError)
//                print("请求失败")
//            }
//        })
    }
    
    //用户头像更新
    func updateUserAvatar(imageUrl : String){
        
        let req = BaseReq<OneParam<String>>()
        req.sessionId = UserInfo.getSessionId()!
        req.action = GateLockActions.ACTION_UpdateUserAvatar
        req.data = OneParam.init(p1: imageUrl)
        
        AjaxUtil<CommonResp>.actionPost(req: req) { (resp) in
            SVProgressHUD.showSuccess(withStatus: "上传成功")
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.openImagePickerController(.camera)
        }else {
            Utils.showTip("请从隐私设置打开相机权限")
        }
    }

    func openPhotoAlbum() {
        self.openImagePickerController(.photoLibrary)
    }

    func openImagePickerController(_ type:UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true) {
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        picker.dismiss(animated: true) {
            self.fileURL = LockTools.saveImage(image)
            let newPhonto : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            self.iconImageView.image = newPhonto
            
            self.uploadImageTask(self.uploadUrl, token: self.iconKey, id: "\(UserInfo.getUserId()!)")
        }
    }
}

extension PersonInfoController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            setupAlertViewController()
        }else if indexPath.row == 1{
            let nickVC = SetNickNameController()
            nickVC.nickNameStr = self.model?.userName
            nickVC.delegate = self
            navigationController?.pushViewController(nickVC, animated: true)
        }else{
            let phoneVC = ChangePhoneNumController()
            navigationController?.pushViewController(phoneVC, animated: true)
        }
    }
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
}


extension PersonInfoController{
    
    func getAvatarUploadKey(){
        
        let req = CommonReq()
        req.sessionId = UserInfo.getSessionId() ?? ""
        req.action = GateLockActions.ACTION_AvatarUploadKey
        
        weak var weakSelf = self
        AjaxUtil<TwoParam<String,String>>.actionPost(req: req) { (resp) in
            weakSelf?.uploadUrl = resp.data?.p1 ?? ""
            weakSelf?.iconKey = resp.data?.p2 ?? ""
        }
    }
}


extension PersonInfoController: SetNickNameControllerDelegate{
    
    func resetNickNameDidFinished(newStr: String) {
        nameLabel.text = newStr
    }
    
    func uploadImage(image : UIImage, success:@escaping (_ imageModel: UploadImageModel) ->Void,
                     failure:@escaping (Void) ->Void){
     
//        let parameters = [
//            "access_token": UserInstance.accessToken
//        ]
//           let uploadIImageURLString = "上传路径"
//            //图片压缩，转nsdata类型 UIImageJPEGRepresentation(image, 0.3)
//            let imageData = image.jpegData(compressionQuality: 0.3)
////            //获取当前时间格式化成String类型
////            let date: Date = Date()
////            let formatter : DateFormatter = DateFormatter()
////            formatter.dateFormat = "yyyyMMddHHmmss"
////            let dateString = formatter.string(from: date)
////            let fileName = dateString + ".jpg"
//
//        
//        AF.upload(multipartFormData: { multipartFormData in
//        if imageData != nil {
//        multipartFormData.append(imageData!, withName: "attach", fileName: "file", mimeType: "image/jpeg")
//        }
////    for (key, value) in parameters {
////    multipartFormData.append(value!.data(using: String.Encoding.utf8)!, withName: key)
////    }
//    },to: uploadIImageURLString,encodingCompletion: { result in
//    switch result {
//    case .success(let upload, _, _):
//        upload.responseJSON { response in
//            switch response.result {
//            case .success(let data):
//                let model = Mapper<BaseResp<UploadImageModel>>().map(JSONObject:data)!
//                QPCLog(model)
////              success(model)
//            case .failure(_):
//                failure(())
//            }
//       }
//    case .failure(let encodingError):
//          QPCLog(encodingError)
//        }
//      })
    }
}
