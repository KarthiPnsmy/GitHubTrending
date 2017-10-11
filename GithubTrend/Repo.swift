//
//  Repo.swift
//  GithubTrend
//
//  Created by Karthi Ponnusamy on 10/8/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation

class Repo: NSObject {
    
    var userName: String?
    var repoName: String?
    var repoAndUserName: String {
        didSet{
            print("repoAndUserName didSet called")
            setUserId(repoAndUserName: self.repoAndUserName)
        }
    }
    
    var repoDescription: String
    var stars: String
    var fork: String
    var starsToday: String
    
    
    init(repoAndUserName: String, repoDescription: String, stars: String, fork: String, starsToday: String){
        self.repoAndUserName = repoAndUserName
        self.repoDescription = repoDescription
        self.stars = stars
        self.fork = fork
        self.starsToday = starsToday
    }
    
    func setRepoAndUserName(name: String){
        self.repoAndUserName = name
    }
    
    func setUserId(repoAndUserName: String){
        let splitArray:[String] = repoAndUserName.components(separatedBy: " / ")
        print("repoAndUserName > \(repoAndUserName)")
        print("splitArray > \(splitArray.count)")
        if splitArray.count == 2 {
            self.userName = splitArray[0]
            self.repoName = splitArray[1]
        }
    }

}
