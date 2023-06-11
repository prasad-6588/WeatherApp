//
//  CityTableViewCell.swift
//  OpenWeather-MVVM

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCity: UIImageView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
