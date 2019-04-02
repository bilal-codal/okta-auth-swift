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

import UIKit
import OktaAuthNative

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        OktaAuthSdk.authenticate(with: URL(string: "https://dev-123456.oktapreview.com")!,
                                 username: "john.doe@okta.com",
                                 password: "password",
                                 onSuccess:
            { sessionToken in
                
                let alert = UIAlertController(title: "Hooray!", message: "We are logged in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            },
                                 onPasswordWarning:
            { passwordWarningStatus in
                
                passwordWarningStatus.skipPasswordChange(onSuccess: { sessionToken in
                    // handle
                }, onError: { error in
                    // handle
                })
            },
                                 onPasswordExpired:
            { passwordExpiredStatus in
                
                passwordExpiredStatus.changePassword(oldPassword: "oldPassword", newPassword: "newPassword", onSuccess: { sessionToken in
                    // handle
                }, onError: { error in
                    // handle
                })
            },
                                 onMFAEnroll:
            { mfaEnrollStatus in
                
                //mfaEnrollStatus.enrollFactor()
            },
                                 onMFARequired:
            { mfaRequiredStatus in
            
                // mfaRequiredStatus.selectFactor()
            },
                                 onLockedOut:
            { lockedOutStatus in
            
                // lockedOutStatus.unlockAccount()
            },
                                 onError:
            { error in
            
                // handleError(error)
            })
    }
}
