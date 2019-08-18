//
//  recordCellTableViewCell.swift
//  YourTimer
//
//  Created by SooRin Kim on 16/08/2019.
//  Copyright © 2019 SooRin Kim. All rights reserved.
//

import UIKit

class recordTimesCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
