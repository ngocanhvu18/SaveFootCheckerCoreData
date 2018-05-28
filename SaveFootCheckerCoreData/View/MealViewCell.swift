//
//  MealViewCell.swift
//  SaveFootCheckerCoreData
//
//  Created by Ngọc Anh on 5/25/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell {
    
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var rantingController: RatingControl!
    
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
