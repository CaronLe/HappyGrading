//
//  CourseManagementTableViewCell.swift
//  Happy Grading
//
//  Created by Swift on 3/9/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class CourseManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var examDateLabel: UILabel!
    @IBOutlet weak var totalTestsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
