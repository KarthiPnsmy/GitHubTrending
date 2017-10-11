//
//  GithubAPIManager.swift
//  GithubTrend
//
//  Created by Karthi Ponnusamy on 28/9/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

class GitHubAPIManager {
    var sessionManager:SessionManager?
    let clientID = "e4f9727bd18796c86a16"
    static let sharedInstance = GitHubAPIManager()
    
    init(){
        alamofierManager()
    }
    
    var OAuthToken:String? {
        set {
            if let valueToSave = newValue {
                do {
                    try Locksmith.saveData(data: ["token" : valueToSave], forUserAccount: "github")
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("reset locksmith")
            }
        }
        
        get {
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "github")
            if let token = dictionary?["token"] as? String {
                return token
            } else {
                return nil
            }
        }
    }
    var oauthTokenCompletionHandler:((NSError?) -> Void)?
    
    func hasOAuthToken() -> Bool {
        if let token = OAuthToken {
            return !token.isEmpty
        }
        return false
    }
    
    func alamofierManager() -> SessionManager? {
        if hasOAuthToken() {
            var headers = Alamofire.SessionManager.defaultHTTPHeaders
            headers["Accept"] = "application/vnd.github.v3+json"
            headers["Authorization"] = "token \(OAuthToken!)"
            
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = headers
            
            sessionManager = Alamofire.SessionManager(configuration: configuration)
            return sessionManager!
        }
        return nil
    }
    
    func getCodeFromUrl(fullUrl: URL) -> String? {
        let components = NSURLComponents(url: fullUrl, resolvingAgainstBaseURL: false)
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if queryItem.name.lowercased() == "code" {
                    return queryItem.value!
                }
            }
        }
        return nil
    }
    
    func generateErrorMessage(message:String?) -> NSError {
        var error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Authentication Failed"])
        if let errorMessage = message {
            error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessage])
        }
        return error
    }
    
    func processOAuthStep1Response(url: URL){
        if let receivedCode = getCodeFromUrl(fullUrl: url) {
            var oAuthError:NSError?
            
            let getTokenPath:String = "https://github.com/login/oauth/access_token"
            let tokenParams = ["client_id": "e4f9727bd18796c86a16", "client_secret": "cca1a895434621428c9466e62d332de705d1a922", "code": receivedCode]
            
            Alamofire.request(getTokenPath, method: .post, parameters: tokenParams, encoding: JSONEncoding.default, headers: nil)
                .responseString { response in
                    if let responseString = response.result.value {
                        let resultParams:Array<String> = responseString.components(separatedBy: "&")
                        for param in resultParams {
                            let resultsSplit = param.components(separatedBy: "=")
                            if resultsSplit.count == 2 {
                                let key = resultsSplit[0]
                                let value = resultsSplit[1]
                                
                                switch key {
                                    case "access_token":
                                        self.OAuthToken = value
                                    case "error":
                                        oAuthError = self.generateErrorMessage(message: value)
                                default: break
                                        //print("key \(key)")
                                    
                                }
                            }
                        }
                        
                        let defaults = UserDefaults.standard
                        defaults.set(false, forKey: "loadingOAuthToken")
                        if self.hasOAuthToken() {
                            if let completionHandler = self.oauthTokenCompletionHandler{
                                completionHandler(nil)
                            }
                        } else {
                            if let completionHandler = self.oauthTokenCompletionHandler{
                                completionHandler(oAuthError)
                            }
                        }
                    }
            }
            
        } else {
            if let completionHandler = self.oauthTokenCompletionHandler{
                let defaults = UserDefaults.standard
                defaults.set(false, forKey: "loadingOAuthToken")
                completionHandler(self.generateErrorMessage(message: nil))
            }
        }
    }
    
    func startOAuth(){
        let authPath:String = "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=public_repo&state=TEST_STATE"
        if let authUrl:URL = URL(string:authPath) {
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "loadingOAuthToken")
            
            UIApplication.shared.open(authUrl, options: [:], completionHandler: nil)
        }
    }
    
    func logout(){
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "github")
        } catch {
            print(error.localizedDescription)
        }
    }
}
