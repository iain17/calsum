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
    
    public var calendar:Calendar!
    fileprivate let coreDataManager = CoreDataManager(modelName: "CalSum")
    
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
        self.title = calendar.title
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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarsTableViewController.reuseIdentifier, for: indexPath) as? GoalTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let goal = fetchedResultsController.object(at: indexPath)
        cell.goal = goal
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = self.tableView.indexPathForSelectedRow {
//            if let goalsTVC = segue.destination as? GoalsTableViewController {
//                goalsTVC.calendar = fetchedResultsController.object(at: indexPath)
//            }
//        }
    }
    
}
