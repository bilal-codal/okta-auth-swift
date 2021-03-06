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

import XCTest
@testable import OktaAuthNative

class OktaAPITests : XCTestCase {
    
    let url = URL(string: "https://B6D242A0-4FC6-41A4-A68B-F722B84BB346.com")!
    var api: OktaAPI!
    
    override func setUp() {
        api = OktaAPI(oktaDomain: url)
    }
    
    override func tearDown() {
        api = nil
    }
    
    func testPrimaryAuthentication() {
        let username = "username"
        let password = "password"
        
        let exp = XCTestExpectation()
        api.commonCompletion = { req, _ in
            XCTAssertEqual(req.baseURL, self.url)
            XCTAssertEqual(req.path, "/api/v1/authn")
            XCTAssertEqual(req.bodyParams?["username"] as? String, username)
            XCTAssertEqual(req.bodyParams?["password"] as? String, password)
            exp.fulfill()
        }
        
        api.primaryAuthentication(username: username, password: password)
        
        wait(for: [exp], timeout: 60.0)
    }
    
    func testPrimaryAuthenticationWithDeviceFingerprint() {
        let username = "username"
        let password = "password"
        let deviceFingerprint = "fingerprint"
        
        let exp = XCTestExpectation()
        api.commonCompletion = { req, _ in
            XCTAssertEqual(req.baseURL, self.url)
            XCTAssertEqual(req.path, "/api/v1/authn")
            XCTAssertEqual(req.bodyParams?["username"] as? String, username)
            XCTAssertEqual(req.bodyParams?["password"] as? String, password)
            XCTAssertEqual(req.additionalHeaders?["X-Device-Fingerprint"] , deviceFingerprint)
            exp.fulfill()
        }
        
        api.primaryAuthentication(username: username, password: password, deviceFingerprint: deviceFingerprint)
        
        wait(for: [exp], timeout: 60.0)
    }
    
    func testChangePassword() {
        let token = "token"
        let oldpass = "oldpass"
        let newpass = "newpass"
        
        let exp = XCTestExpectation()
        api.commonCompletion = { req, _ in
            XCTAssertEqual(req.baseURL, self.url)
            XCTAssertEqual(req.path, "/api/v1/authn/credentials/change_password")
            XCTAssertEqual(req.bodyParams?["stateToken"] as? String, token)
            XCTAssertEqual(req.bodyParams?["oldPassword"] as? String, oldpass)
            XCTAssertEqual(req.bodyParams?["newPassword"] as? String, newpass)
            exp.fulfill()
        }
        
        api.changePassword(stateToken: token, oldPassword: oldpass, newPassword: newpass)
        
        wait(for: [exp], timeout: 60.0)
    }
    
    func testGetTransactionState() {
        let token = "token"
        
        let exp = XCTestExpectation()
        api.commonCompletion = { req, _ in
            XCTAssertEqual(req.baseURL, self.url)
            XCTAssertEqual(req.path, "/api/v1/authn")
            XCTAssertEqual(req.bodyParams?["stateToken"] as? String, token)
            exp.fulfill()
        }
        
        api.getTransactionState(stateToken: token)
        
        wait(for: [exp], timeout: 60.0)
    }
    
    func testCancelTransaction() {
        let token = "token"
        
        let exp = XCTestExpectation()
        api.commonCompletion = { req, _ in
            XCTAssertEqual(req.baseURL, self.url)
            XCTAssertEqual(req.path, "/api/v1/authn/cancel")
            XCTAssertEqual(req.bodyParams?["stateToken"] as? String, token)
            exp.fulfill()
        }
        
        api.cancelTransaction(stateToken: token)
        
        wait(for: [exp], timeout: 60.0)
    }
    
    func testPerformLink() {
        let link = LinksResponse.Link(href: url, hints: [:])
        let token = "token"
        
        let exp = XCTestExpectation()
        api.commonCompletion = { req, _ in
            XCTAssertEqual(req.baseURL, self.url)
            XCTAssertEqual(req.bodyParams?["stateToken"] as? String, token)
            exp.fulfill()
        }
        
        api.perform(link: link, stateToken: token)
        
        wait(for: [exp], timeout: 60.0)
    }

    func testMFAVerify() {
        let factorId = "id"
        let token = "token"
        let answer = "answer"
        let passCode = "passCode"
        let rememberDevice = true
        let autoPush = false

        let exp = XCTestExpectation()
        api.commonCompletion = { req, _ in
            XCTAssertEqual(req.urlParams?["rememberDevice"], "true")
            XCTAssertEqual(req.urlParams?["autoPush"], "false")
            XCTAssertEqual(req.bodyParams?["stateToken"] as? String, token)
            XCTAssertEqual(req.bodyParams?["answer"] as? String, answer)
            XCTAssertEqual(req.bodyParams?["passCode"] as? String, passCode)
            exp.fulfill()
        }

        api.verifyFactor(factorId: factorId,
                         stateToken: token,
                         answer: answer,
                         passCode: passCode,
                         rememberDevice: rememberDevice,
                         autoPush: autoPush)

        wait(for: [exp], timeout: 60.0)
    }
}
