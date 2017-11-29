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
    var brain: CalSumBrain?
    
    public var goal:Goal? {
        didSet {
            name.text = goal?.name
            percentage.text = "..."
            progress.progress = 0
            if goal != nil  {
                self.brain = CalSumBrain(goal: goal!)
            }
            calcProgress()
        }
    }
    
    func calcProgress() {
        if let brain = self.brain {
            brain.getTotalHours(completion: { (result) in
                print(result)
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
