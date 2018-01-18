//
//  EventTableViewCell.swift
//  XCStats
//
//  Created by Seshu Adunuthula on 1/17/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var numRunnersLabel: UILabel!
    @IBOutlet weak var divisionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
