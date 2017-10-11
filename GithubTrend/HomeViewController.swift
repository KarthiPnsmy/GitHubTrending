//
//  ViewController.swift
//  GithubTrend
//
//  Created by Karthi Ponnusamy on 8/8/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Kanna
import FaveButton

class HomeViewController: BaseViewController, UITableViewDataSource, FaveButtonDelegate{

    let trendRepoUrl: String = "https://github.com/trending/swift?since=weekly"
    let trendUserUrl: String = "https://github.com/trending/developers/swift?since=daily"
    var userList: [User] = []
    var repoList: [Repo] = []
    
    @IBOutlet var repoTableView: UITableView!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoTableView.dataSource = self
        repoTableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoCellReuseIdentifier")
        repoTableView.rowHeight = 115
        
        userTableView.dataSource = self
        userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCellReuseIdentifier")
        userTableView.rowHeight = 100
        
        self.addSlideMenuButton()
        self.userTableView.isHidden = true
        self.repoTableView.isHidden = false
        getGithubRepoTrend()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            self.userTableView.isHidden = true
            self.repoTableView.isHidden = false
            if repoList.count == 0{
                getGithubRepoTrend()
            }
        case 1:
            self.userTableView.isHidden = false
            self.repoTableView.isHidden = true
            if userList.count == 0{
                getGithubUserTrend()
            }
        default:
            break; 
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.repoTableView {
            return repoList.count
        } else {
            return userList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if tableView == self.repoTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCellReuseIdentifier") as! RepoTableViewCell
            
            let repo = repoList[indexPath.row]
        
            
            if repo.userName != nil {
                cell.userNameLable.text = repo.userName!
            }
            
            if repo.repoName != nil {
                cell.repoNameLabel.text = "/\(repo.repoName!)"
            }
            
            cell.descriptionLable.text = repo.repoDescription
            cell.starsLabel.text = repo.stars
            cell.forkLabel.text = repo.fork
            cell.starsTodayLabel.text = repo.starsToday
            
            cell.starButton.tag = indexPath.row
            cell.starButton.setSelected(selected: false, animated: false)
            cell.starButton.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCellReuseIdentifier") as! UserTableViewCell
            
            let user = userList[indexPath.row]
            cell.userIdLabel.text = user.id
            cell.userFullNameLabel.text = user.name
            cell.repoNameLabel.text = user.repoName
            cell.descriptionLabel.text = user.repoDescription
            
            Alamofire.request(user.profileImage).responseImage { response in
                if let image = response.result.value {
                    cell.profileImage.image = image
                }
            }
            
            if user.canFollow {
                cell.followButton.setSelected(selected: false, animated: false)
                cell.followButton.delegate = self
                cell.followButton.isHidden = false
            } else {
                cell.followButton.isHidden = true
            }
            
            return cell
        }

    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        let repo = repoList[faveButton.tag]

        if(!GitHubAPIManager.sharedInstance.hasOAuthToken()){
            GitHubAPIManager.sharedInstance.oauthTokenCompletionHandler = {
                (error) -> Void in
                if let oAuthError:NSError = error {
                    ToastManager.sharedInstance.show(parent: self.view, message: oAuthError.localizedDescription)
                } else {
                    let loginSuccessNotification = Notification.Name(rawValue: "loginSuccess")
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.post(name: loginSuccessNotification, object: nil)
                    self.checkStarStatus(repoName: repo.repoName!, owner: repo.userName!, faveButton: faveButton)
                }
            }
            
            GitHubAPIManager.sharedInstance.startOAuth();
        } else {
            self.checkStarStatus(repoName: repo.repoName!, owner: repo.userName!, faveButton: faveButton)
        }
    }

    func checkStarStatus(repoName:String, owner:String, faveButton: FaveButton){
        if faveButton.isSelected {
            self.starTheRepo(repoName: repoName, owner: owner, faveButton: faveButton, completion: {
                success, error in
                if success {
                    ToastManager.sharedInstance.show(parent: self.view, message: "\(repoName) has been added to your started list")
                } else {
                    if let gError = error {
                        ToastManager.sharedInstance.show(parent: self.view, message: gError.localizedDescription)
                    }
                }
            })
        } else {
            self.unstarTheRepo(repoName: repoName, owner: owner, faveButton: faveButton, completion: {
                success, error in
                if success {
                    ToastManager.sharedInstance.show(parent: self.view, message: "\(repoName) has been removed from your started list")
                } else {
                    if let gError = error {
                        ToastManager.sharedInstance.show(parent: self.view, message: gError.localizedDescription)
                    }
                }
            })
        }
    }
    
    func starTheRepo(repoName:String, owner:String, faveButton: FaveButton, completion: @escaping (_ success:Bool, _ error:NSError?) -> Void){
        let urlString = "https://api.github.com/user/starred/\(owner)/\(repoName)"
        
        let request = GitHubAPIManager.sharedInstance.alamofierManager()?.request(urlString, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { response in
            debugPrint(response)
            
            if let statusCode = response.response?.statusCode {
                if statusCode == 204 {
                    completion(true, nil)
                } else {
                    faveButton.setSelected(selected: false, animated: false)
                    completion(false, GitHubAPIManager.sharedInstance.generateErrorMessage(message: "Unable to star \(repoName). Try again later"))
                }
            }
        }
        debugPrint(request!)
    }
    
    func unstarTheRepo(repoName:String, owner:String, faveButton: FaveButton, completion: @escaping (_ success:Bool, _ error:NSError?) -> Void){
        let urlString = "https://api.github.com/user/starred/\(owner)/\(repoName)"
        
        let request = GitHubAPIManager.sharedInstance.alamofierManager()?.request(urlString, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { response in
            debugPrint(response)
            if let statusCode = response.response?.statusCode {
                if statusCode == 204 {
                    completion(true, nil)
                } else {
                    faveButton.setSelected(selected: false, animated: false)
                    completion(true, GitHubAPIManager.sharedInstance.generateErrorMessage(message: "Unable to remove \(repoName) from your started list. Try again later"))
                }
            }
        }
        debugPrint(request!)
    }
    
    func getGithubRepoTrend(){
        Alamofire.request(trendRepoUrl).responseString{ response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseTrendRepoHTML(html: html)
            }
        }
    }
    
    func getGithubUserTrend(){
        Alamofire.request(trendUserUrl).responseString{ response in
            if let html = response.result.value {
                self.parseTrendUsersHtml(html: html)
            }
        }
    }
    
    func parseTrendRepoHTML(html: String){
        if let doc = Kanna.HTML(html: html, encoding: .utf8) {
            for item in doc.xpath("//div[@class='explore-content']/ol/li") {                
                let repoContainer = item.xpath("div")
                let repoAndUserName = repoContainer.first?.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let repoDetail = repoContainer[2].text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                let repoMetaContainer = repoContainer[3].xpath("a")
                let starCount = repoMetaContainer.first?.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let forkCount = repoMetaContainer[1].text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let startsToday = repoContainer[3].xpath("span[@class='d-inline-block float-sm-right']")[0].text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

                
//                print("RepoAndUserName => \(repoAndUserName!)")
//                print("Desc => \(repoDetail!)")
//                print("Stars => \(starCount!)")
//                print("Fork => \(forkCount!)")
//                print("Stars Today => \(startsToday!)")
                
                let repo: Repo = Repo.init(repoAndUserName: repoAndUserName!, repoDescription: repoDetail!, stars: starCount!, fork: forkCount!, starsToday: startsToday!)
                repo.setRepoAndUserName(name: repoAndUserName!)
                repoList.append(repo)
            }
        }
        print("DONE repoList \(repoList.count)")
        self.repoTableView.reloadData()
    }
    
    
    func parseTrendUsersHtml(html:String){
        if let doc = Kanna.HTML(html: html, encoding: .utf8) {
            for item in doc.xpath("//div[@class='explore-content']/ol/li") {
                let userContainer = item.xpath("div")

                let followNode = item.xpath("div[@class='mx-2 ml-6 ml-sm-2']/span").count
                var canFollow = false
                if followNode > 0 {
                    canFollow = true
                }
                let userDetailNode = userContainer[0].xpath("div")
                let userProfileImage = userDetailNode[0].xpath("a/img")[0]["src"]
                
                let useId = userDetailNode[1].xpath("h2/a")[0]["href"]
                
                
                var userName = ""
                let userFullNameNode = userDetailNode[1].xpath("h2/a/span[@class='text-gray text-bold']")
                if userFullNameNode.count > 0 {
                    userName = (userFullNameNode[0].text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                }

                
                let repo = userDetailNode[1].xpath("a/span/span")[0].text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let userRepoNode = userDetailNode[1].xpath("a/span[@class='repo-snipit-description css-truncate-target']")
                var desc = ""
                if userRepoNode.count > 0 {
                    desc = (userRepoNode[0].text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                }
                
//                print("canFollow => \(canFollow)")
//                print("userProfileImage => \(userProfileImage!)")
//                print("useId => \(useId!)")
//                print("userName => \(userName)")
//                print("repo => \(repo!)")
//                print("desc => \(desc)")
                
                let user: User = User.init(id: useId!, name: userName, canFollow: canFollow, profileImage: userProfileImage!, repoName: repo!, repoDescription: desc)
                userList.append(user)
                
            }
            print("DONE userList \(userList.count)")
            self.userTableView.reloadData()
        }
        
    }
}

