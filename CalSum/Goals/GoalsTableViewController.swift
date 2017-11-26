//
//  GoalsTableViewController.swift
//  CalSum
//
//  Created by Iain Munro on 24/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class GoalsTableViewController: UITableViewController {
    let reuseIdentifier = "GoalCell"
    public var calendar:Calendar!
    fileprivate let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Goal> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.predicate = NSPredicate(format: "calendar.id = %@", calendar.id!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "from", ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        self.title = "\(calendar.title!) goals"
        refresh(1)
        self.refreshControl?.endRefreshing()
    }
    
    @IBAction func refresh(_ sender: Any) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to fetch goals")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let object = fetchedResultsController.object(at: indexPath)
        fetchedResultsController.managedObjectContext.delete(object)
        try? fetchedResultsController.managedObjectContext.save()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? GoalTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let goal = fetchedResultsController.object(at: indexPath)
        cell.goal = goal
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desination = segue.destination as? GoalViewController {
            if let identifier = segue.identifier{
                switch(identifier) {
                case "editGoal":
                    if let indexPath = self.tableView.indexPathForSelectedRow {
                        desination.goal = fetchedResultsController.object(at: indexPath)
                    }
                    break
                case "addGoal":
                    desination.goal = Goal(context: self.fetchedResultsController.managedObjectContext)
                    desination.goal.resetToDefaults()
                    desination.goal.calendar = self.calendar
                    break
                default:
                    print("dunno what to do with \(identifier)")
                    break
                }
                
            }
        }
    }
    
}
