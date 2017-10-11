//
//  User.swift
//  GithubTrend
//
//  Created by Karthi Ponnusamy on 10/8/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import Foundation

class User: NSObject {
    var id: String
    var name: String
    var canFollow: Bool
    var profileImage: String
    var repoName: String
    var repoDescription: String
    
    init(id: String, name: String, canFollow: Bool, profileImage: String, repoName: String, repoDescription: String) {
        self.id = id
        self.name = name
        self.canFollow = canFollow
        self.profileImage = profileImage
        self.repoName = repoName
        self.repoDescription = repoDescription
    }
}
