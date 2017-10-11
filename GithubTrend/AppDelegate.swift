//
//  AppDelegate.swift
//  GithubTrend
//
//  Created by Karthi Ponnusamy on 8/8/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barStyle = .blackOpaque
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("openURL \(url)")
        GitHubAPIManager.sharedInstance.processOAuthStep1Response(url: url)
        return true
    }
}

