//
//  VerificationTF.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/27.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit

protocol VerificationTFDeleteDelegate {
    func didClickBackWard()
}


class VerificationTF: UITextField {

    var deleteDelegate : VerificationTFDeleteDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        deleteDelegate?.didClickBackWard()
    }
    
    

}
