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
import OktaAuthNative

class OktaAPIMock: OktaAPI {
    
    public init?(successCase: Bool, json: String?, resourceName: String?) {
        
        var jsonData: Data?
        if let resourceName = resourceName {
        
            let url = Bundle.init(for: OktaAPIMock.self).url(forResource: resourceName, withExtension: nil)
            do {
                jsonData = try Data(contentsOf: url!)
            } catch {
                return nil
            }
        }
        
        if let json = json {

            jsonData = json.data(using: .utf8)
        }
        
        guard jsonData != nil else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(formatter)

        if successCase {
            let response: OktaAPISuccessResponse
            do {
                response = try decoder.decode(OktaAPISuccessResponse.self, from: jsonData!)
            } catch {
                return nil
            }
            
            result = OktaAPIRequest.Result.success(response)
        } else {
            let response: OktaAPIErrorResponse
            do {
                response = try decoder.decode(OktaAPIErrorResponse.self, from: jsonData!)
            } catch {
                return nil
            }
            
            result = OktaAPIRequest.Result.error(OktaError.serverRespondedWithError(response))
        }
        
        
        super.init(oktaDomain: URL(string: "https://dummy.url")!)
    }
    
    public convenience init?(successCase: Bool, json: String) {
        
        self.init(successCase: successCase, json: json, resourceName: nil)
    }
    
    public convenience init?(successCase: Bool, resourceName: String) {
        
        self.init(successCase: successCase, json: nil, resourceName: resourceName)
    }
    
    @discardableResult override public func primaryAuthentication(username: String?,
                                                                  password: String?,
                                                                  audience: String?,
                                                                  relayState: String?,
                                                                  multiOptionalFactorEnroll: Bool,
                                                                  warnBeforePasswordExpired: Bool,
                                                                  token: String?,
                                                                  deviceToken: String?,
                                                                  deviceFingerprint: String?,
                                                                  completion: ((OktaAPIRequest.Result) -> Void)?) -> OktaAPIRequest {
        DispatchQueue.main.async {
            completion?(self.result)
        }
        
        self.primaryAuthenticationCalled = true
        let req = OktaAPIRequest(baseURL: URL(string: "https://dummy.url")!,
                                 urlSession: URLSession(configuration: .default),
                                 completion: { _ = $0; _ = $1})
        
        return req
    }
    
    @discardableResult override public func cancelTransaction(stateToken: String,
                                                              completion: ((OktaAPIRequest.Result) -> Void)?) -> OktaAPIRequest {
        
        DispatchQueue.main.async {
            completion?(self.result)
        }
        
        self.cancelTransactionCalled = true
        let req = OktaAPIRequest(baseURL: URL(string: "https://dummy.url")!,
                                 urlSession: URLSession(configuration: .default),
                                 completion: { _ = $0; _ = $1})
        
        return req
    }
    
    @discardableResult override public func changePassword(stateToken: String,
                                                           oldPassword: String,
                                                           newPassword: String,
                                                           completion: ((OktaAPIRequest.Result) -> Void)?) -> OktaAPIRequest {
     
        DispatchQueue.main.async {
            completion?(self.result)
        }
        
        self.changePasswordCalled = true
        let req = OktaAPIRequest(baseURL: URL(string: "https://dummy.url")!,
                                 urlSession: URLSession(configuration: .default),
                                 completion: { _ = $0; _ = $1})
        
        return req
    }
    
    @discardableResult override public func getTransactionState(stateToken: String,
                                                                completion: ((OktaAPIRequest.Result) -> Void)?) -> OktaAPIRequest {
        
        DispatchQueue.main.async {
            completion?(self.result)
        }
        
        self.getTransactionStateCalled = true
        let req = OktaAPIRequest(baseURL: URL(string: "https://dummy.url")!,
                                 urlSession: URLSession(configuration: .default),
                                 completion: { _ = $0; _ = $1})
        
        return req
    }
    
    @discardableResult override public func verifyFactor(factorId: String,
                                                         stateToken: String,
                                                         answer: String?,
                                                         passCode: String?,
                                                         rememberDevice: Bool?,
                                                         autoPush: Bool?,
                                                         completion: ((OktaAPIRequest.Result) -> Void)?) -> OktaAPIRequest {
        
        DispatchQueue.main.async {
            completion?(self.result)
        }
        
        self.verifyFactorCalled = true
        let req = OktaAPIRequest(baseURL: URL(string: "https://dummy.url")!,
                                 urlSession: URLSession(configuration: .default),
                                 completion: { _ = $0; _ = $1})
        
        return req
    }
    
    @discardableResult override public func perform(link: LinksResponse.Link,
                                                    stateToken: String,
                                                    completion: ((OktaAPIRequest.Result) -> Void)?) -> OktaAPIRequest {
        
        DispatchQueue.main.async {
            completion?(self.result)
        }
        
        self.performCalled = true
        self.performedLink = link
        let req = OktaAPIRequest(baseURL: URL(string: "https://dummy.url")!,
                                 urlSession: URLSession(configuration: .default),
                                 completion: { _ = $0; _ = $1})
        
        return req
    }

    private let result: OktaAPIRequest.Result
    
    var primaryAuthenticationCalled: Bool = false
    var cancelTransactionCalled: Bool = false
    var changePasswordCalled: Bool = false
    var getTransactionStateCalled: Bool = false
    var verifyFactorCalled: Bool = false
    var performCalled: Bool = false

    var performedLink: LinksResponse.Link?
}
