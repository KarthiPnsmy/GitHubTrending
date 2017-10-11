//
//  UserTableViewCell.swift
//  GithubTrend
//
//  Created by Karthi Ponnusamy on 6/9/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit
import FaveButton

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var followButton: FaveButton!
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
