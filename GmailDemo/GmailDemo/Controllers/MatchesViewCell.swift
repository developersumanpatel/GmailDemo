//
//  MatchesViewCell.swift
//  GmailDemo
//
//  Created by Suman on 25/09/21.
//

import UIKit

class MatchesViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var favouriteButton: UIButton!
    
    var favouriteClicked: (() -> Void)?
    var locationClicked: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ model: Venue) {
        nameLabel.text = model.name ?? ""
        addressLabel.text = model.location?.address ?? ""
        cityLabel.text = model.location?.city ?? ""
        favouriteButton.setImage(model.isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
    }
    @IBAction func checkLocationClicked(_ sender: Any) {
        locationClicked?()
    }
    
    @IBAction func favouriteClicked(_ sender: Any) {
        favouriteClicked?()
    }
}


