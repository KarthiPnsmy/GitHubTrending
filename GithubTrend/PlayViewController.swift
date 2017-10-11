//
//  PlayViewController.swift
//  GithubTrend
//
//  Created by Karthi Ponnusamy on 27/8/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit

class PlayViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSlideMenuButton()
        self.title = "About"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
