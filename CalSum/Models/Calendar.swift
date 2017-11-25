//
//  Calendar.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import Foundation
import CoreData
import EventKit

public class Calendar: NSManagedObject {
    static func upsert(rawCalendar: EKCalendar, in context: NSManagedObjectContext) throws -> Calendar
    {
        let request: NSFetchRequest<Calendar> = Calendar.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", rawCalendar.id)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Calendar.upsert -- database inconsistency!")
                return matches[0]
            }
        } catch {
            print(error)
        }
        
        let calendar = Calendar(context: context)
        calendar.title = rawCalendar.title
        calendar.id = rawCalendar.id
        calendar.source = rawCalendar.source.title
        calendar.createdAt = Date()
        do {
            try context.save()
        } catch {
            let saveError = error as NSError
            print("Unable to Save")
            print("\(saveError), \(saveError.localizedDescription)")
        }
        return calendar
    }
}


extension EKCalendar {
    public var id: String {
        return self.source.sourceIdentifier + self.title
    }
}
