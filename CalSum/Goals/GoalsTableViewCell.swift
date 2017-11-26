//
//  GoalsTableViewCell.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    public var goal:Goal? {
        didSet {
            name.text = goal?.name
            percentage.text = "..."
            progress.progress = 0
            calcProgress()
        }
    }
    
    func calcProgress() {
        let events = self.goal!.calendar!.getEvents(from: self.goal!.from!, till: self.goal!.till!)
        print(events)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
