//
//  AuthStatusMFAEnroll.swift
//  OktaAuthNative
//
//  Created by Ildar Abdullin on 3/12/19.
//

import Foundation

public class OktaAuthStatusMFAEnroll : OktaAuthStatus {

    init(oktaDomain: URL, model: OktaAPISuccessResponse) {
        super.init(oktaDomain: oktaDomain)
        self.model = model
        statusType = .MFAEnroll
    }
}
