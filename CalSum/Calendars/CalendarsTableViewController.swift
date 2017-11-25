//
//  TableViewController.swift
//  CalSum
//
//  Created by Iain Munro on 24/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class CalendarsTableViewController: UITableViewController {
    static let reuseIdentifier = "CalendarCell"
    let eventStore = EKEventStore()
    fileprivate let coreDataManager = CoreDataManager(modelName: "CalSum")

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Calendar> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Calendar> = Calendar.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to fetch calendars")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
        self.tableView.reloadData()
    }
    
    @objc func refresh() {
        self.eventStore.requestAccess(to: .event) { [weak self] (granted, error) in
            if !granted {
                self?.showError(title: "No permissions!", message: "Failed to receive Calendar permissions. Please try again.")
                return
            }
            if error != nil {
                self?.showError(title: "Error occured", message: error.debugDescription)
                return
            }
            if let calendars = self?.eventStore.calendars(for: .event) {
                self?.setCalendars(calendars: calendars)
            }
        }
    }
    
    private func setCalendars(calendars: [EKCalendar]) {
        for rawCalendar in calendars {
            _ = try? Calendar.upsert(rawCalendar: rawCalendar, in: coreDataManager.managedObjectContext)
        }
        DispatchQueue.main.async {
            do {
                try self.fetchedResultsController.performFetch()
            } catch let error {
                print(error)
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertView()
            alert.title = title
            alert.message = message
            alert.show()
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarsTableViewController.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let calendar = fetchedResultsController.object(at: indexPath)
        cell.calendar = calendar
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            if let goalsTVC = segue.destination as? GoalsTableViewController {
                goalsTVC.calendar = fetchedResultsController.object(at: indexPath)
            }
        }
    }
    
}
