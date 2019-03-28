//
//  ClothingTableViewCell.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/8/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit

class ClothingTableViewCell: UITableViewCell {
    
    // MARK: - Variables

    @IBOutlet weak var clothingImage: UIImageView!
    @IBOutlet weak var clothingLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var clothingBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
