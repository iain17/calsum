//
//  GoalsTableViewCell.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit
import Foundation

class GoalTableViewCell: UITableViewCell {
    var formatter = NumberFormatter()
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    public var goal:Goal? {
        didSet {
            self.percentageValue = nil
            name.text = goal?.name
            if goal != nil  {
                self.brain = CalSumBrain(goal: goal!)
            }
            calcProgress()
        }
    }
    
    var percentageValue: Double? = nil {
        didSet {
            DispatchQueue.main.async {
                if var percentageValue = self.percentageValue {
                    if percentageValue > 100 {
                        percentageValue = 100
                    }
                    var value = 0.0
                    if percentageValue > 0 {
                        value = percentageValue / 100
                    }
                    self.percentage.text = self.formatter.string(from: NSNumber(value: value))
                    self.progress.progress = Float(value)
                }
                
                self.percentage.isHidden = self.percentageValue == nil
                if self.percentageValue == nil {
                    self.loading.startAnimating()
                } else {
                    self.loading.stopAnimating()
                }
            }
        }
    }
    var brain: CalSumBrain?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.formatter.numberStyle = .percent
        self.formatter.maximumFractionDigits = 2;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.formatter.numberStyle = .percent
        self.formatter.maximumFractionDigits = 2;
    }
    
    func calcProgress() {
        if let brain = self.brain {
            brain.getPercentage(completion: { (percentage) in
                self.percentageValue = percentage
            })
        }
    }
    
}
