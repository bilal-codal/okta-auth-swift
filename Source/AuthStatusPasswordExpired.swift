/*
 * Copyright (c) 2019, Okta, Inc. and/or its affiliates. All rights reserved.
 * The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
 *
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and limitations under the License.
 */

import Foundation

public class OktaAuthStatusPasswordExpired : OktaAuthStatus {

    init(oktaDomain: URL, model: OktaAPISuccessResponse) {
        super.init(oktaDomain: oktaDomain)
        self.model = model
        statusType = .passwordExpired
    }

    public func changePassword(oldPassword: String,
                               newPassword: String,
                               onStatusChange: @escaping (_ newStatus: OktaAuthStatus) -> Void,
                               onError: @escaping (_ error: OktaError) -> Void) {

        guard canChange() else {
            onError(.wrongState("Can't find 'next' link in response"))
            return
        }

        api.changePassword(link: model!.links!.next!,
                           stateToken: model!.stateToken!,
                           oldPassword: oldPassword,
                           newPassword: newPassword) { result in
    
            self.handleServerResponse(result,
                                      onStatusChanged: onStatusChange,
                                      onError: onError)
        }
    }

    public func canChange() -> Bool {
        
        guard (model?.links?.next?.href) != nil else {
            return false
        }

        return true
    }
}
