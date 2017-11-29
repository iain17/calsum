//
//  CalSumTests.swift
//  CalSumTests
//
//  Created by Iain Munro on 29/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import XCTest
import Foundation

class DayTests: XCTestCase {
    var today = Date()
    var day: Day = Day(date: Date())
    
    override func setUp() {
        super.setUp()
        self.today = Foundation.Calendar.current.startOfDay(for: Date())
        self.day = Day(date: today)
    }
    
    func testDateToSeconds() {
        var components = Foundation.Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        var date = Foundation.Calendar.current.date(from: components)!
        XCTAssert(self.day.dateToSeconds(date) == 0)
        
        components.second = 1
        date = Foundation.Calendar.current.date(from: components)!
        XCTAssert(self.day.dateToSeconds(date) == 1)
        components.second = 0
        
        
        components.minute = 1
        date = Foundation.Calendar.current.date(from: components)!
        XCTAssert(self.day.dateToSeconds(date) == 60)
        components.minute = 0
        
        components.hour = 1
        date = Foundation.Calendar.current.date(from: components)!
        XCTAssert(self.day.dateToSeconds(date) == 3600)
        components.hour = 0
    }
    
    //Simple one hour appointment
    func testSimpleBook() {
        let appointmentFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: today)!
        let appointmentTill = Foundation.Calendar.current.date(byAdding: .hour, value: 2, to: today)!
        self.day.book(from: appointmentFrom, till: appointmentTill)
        XCTAssert(self.day.totalSecondsBooked == 3600)
    }
    
    func testExactOverlapBook() {
        let appointmentFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: today)!
        let appointmentTill = Foundation.Calendar.current.date(byAdding: .hour, value: 2, to: today)!
        //Book twice.
        self.day.book(from: appointmentFrom, till: appointmentTill)
        self.day.book(from: appointmentFrom, till: appointmentTill)
        XCTAssert(self.day.totalSecondsBooked == 3600)
    }
    
    func testOverlapWithLittleEventBook() {
        //One long one
        let eventAFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 0, to: today)!
        let eventATill = Foundation.Calendar.current.date(byAdding: .hour, value: 4, to: today)!
        self.day.book(from: eventAFrom, till: eventATill)
        
        //One inbetween
        let eventBFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: today)!
        let eventBTill = Foundation.Calendar.current.date(byAdding: .hour, value: 2, to: today)!
        self.day.book(from: eventBFrom, till: eventBTill)
        
        //One past
        let eventCFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 5, to: today)!
        let eventCTill = Foundation.Calendar.current.date(byAdding: .hour, value: 6, to: today)!
        self.day.book(from: eventCFrom, till: eventCTill)
        
        XCTAssert(self.day.totalSecondsBooked == 5 * 3600)
    }
    
    func testNoOverbooking() {
        //Exact one day. No overbooking.
        let eventAFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 0, to: today)!
        var eventATill = Foundation.Calendar.current.date(byAdding: .hour, value: 0, to: today)!
        eventATill = Foundation.Calendar.current.date(byAdding: .day, value: 1, to: eventATill)!
        self.day.book(from: eventAFrom, till: eventATill)
        XCTAssert(self.day.totalSecondsOverbooked == 0)
    }
    
    func testOverbooking() {
        //One hour of over booking
        let eventAFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 0, to: today)!
        var eventATill = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: today)!
        eventATill = Foundation.Calendar.current.date(byAdding: .day, value: 1, to: eventATill)!
        self.day.book(from: eventAFrom, till: eventATill)
        XCTAssert(self.day.totalSecondsOverbooked == 3600)
        
        let tomorrow = Day(date: eventATill, yesterdaySecondsOverbooked: self.day.totalSecondsOverbooked)
        XCTAssert(tomorrow.totalSecondsBooked == 3600)
        XCTAssert(tomorrow.totalSecondsOverbooked == 0)
    }
    
    func testExtremeOverbooking() {
        //One hour of over booking
        let eventAFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 0, to: today)!
        var eventATill = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: today)!
        eventATill = Foundation.Calendar.current.date(byAdding: .day, value: 5, to: eventATill)!
        
        self.day.book(from: eventAFrom, till: eventATill)
        XCTAssert(self.day.totalSecondsOverbooked == ((4 * 86400) + 1 * 3600))
        
        var dateTomorrow = Foundation.Calendar.current.date(byAdding: .day, value: 1, to: today)!
        var tomorrow = Day(date: dateTomorrow, yesterdaySecondsOverbooked: self.day.totalSecondsOverbooked)
        //One inbetween
        let eventBFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: dateTomorrow)!
        let eventBTill = Foundation.Calendar.current.date(byAdding: .hour, value: 2, to: dateTomorrow)!
        tomorrow.book(from: eventBFrom, till: eventBTill)
        
        XCTAssert(tomorrow.totalSecondsBooked == 86400)
        XCTAssert(tomorrow.totalSecondsOverbooked == ((3 * 86400) + 1 * 3600))
        
        dateTomorrow = Foundation.Calendar.current.date(byAdding: .day, value: 1, to: dateTomorrow)!
        tomorrow = Day(date: dateTomorrow, yesterdaySecondsOverbooked: tomorrow.totalSecondsOverbooked)
        XCTAssert(tomorrow.totalSecondsBooked == 86400)
        XCTAssert(tomorrow.totalSecondsOverbooked == ((2 * 86400) + 1 * 3600) )
    }
    
    func testPerformanceBooking() {
        self.measure {
            //One long one
            let eventAFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 0, to: today)!
            let eventATill = Foundation.Calendar.current.date(byAdding: .hour, value: 4, to: today)!
            self.day.book(from: eventAFrom, till: eventATill)

            //One inbetween
            let eventBFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: today)!
            let eventBTill = Foundation.Calendar.current.date(byAdding: .hour, value: 2, to: today)!
            self.day.book(from: eventBFrom, till: eventBTill)

            //One past
            let eventCFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 5, to: today)!
            let eventCTill = Foundation.Calendar.current.date(byAdding: .hour, value: 6, to: today)!
            self.day.book(from: eventCFrom, till: eventCTill)
        }
    }
    
    func testPerformanceFullDay() {
        self.measure {
            //One long one
            let eventAFrom = Foundation.Calendar.current.date(byAdding: .hour, value: 0, to: today)!
            let eventATill = Foundation.Calendar.current.date(byAdding: .hour, value: 24, to: today)!
            self.day.book(from: eventAFrom, till: eventATill)
        }
    }
    
}
