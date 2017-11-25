//
//  CalendarTableViewCell.swift
//  CalSum
//
//  Created by Iain Munro on 24/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel?
    
    public var calendar:Calendar? {
        didSet {
            self.name?.text = calendar?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
