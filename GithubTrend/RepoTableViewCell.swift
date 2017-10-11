//
//  RepooTableViewCell.swift
//  GithubTrend
//
//  Created by Karthi Ponnusamy on 5/9/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit
import FaveButton

class RepoTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var starsTodayLabel: UILabel!
    
    @IBOutlet weak var starView: UIView!
    
    @IBOutlet weak var starButton: FaveButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellContainer.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.cellContainer.layer.cornerRadius = 3.0
        self.cellContainer.layer.masksToBounds = false
        self.cellContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.cellContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.cellContainer.layer.shadowOpacity = 0.8
    
    
        /*
        self.starView.layer.cornerRadius = self.starView.frame.size.width / 2
        self.starView.clipsToBounds = true
        self.starView.layer.masksToBounds = false;
        */
        
        /*
        self.starView.layer.cornerRadius = 8;
        self.starView.layer.shadowOffset = CGSize(width:5.0, height:5.0);
        self.starView.layer.shadowRadius = 5;
        self.starView.layer.shadowOpacity = 0.5;
         */
        
        /*
        self.starView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.starView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.starView.layer.shadowOpacity = 0.8
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
