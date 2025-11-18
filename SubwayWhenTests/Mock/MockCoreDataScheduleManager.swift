//
//  MockCoreDataScheduleManager.swift
//  SubwayWhenTests
//
//  Created by 이윤수 on 11/18/25.
//

import Foundation
import CoreData
import RxSwift

@testable import SubwayWhen

class MockCoreDataScheduleManager: CoreDataScheduleManagerProtocol {
    
    private lazy var mockContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "CoreDataScheduleModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, _ in }
        return container.viewContext
    }()
    
    private var scheduleData: [String: ShinbundangLineScheduleModel] = [:]
    
    private(set) var scheduleLoadCount = 0
    
    func shinbundangScheduleDataSave(to scheduleData: [String : [SubwayWhen.ShinbundangScheduleModel]], scheduleVersion: String) {
        for (stationName, schedules) in scheduleData {
            let entity = ShinbundangLineScheduleModel(context: mockContext)
            entity.stationName = stationName
            entity.scheduleData = schedules
            entity.scheduleVersion = scheduleVersion
            
            self.scheduleData[stationName] = entity
        }
    }
    
    func shinbundangScheduleDataLoad(stationName: String) -> SubwayWhen.ShinbundangLineScheduleModel? {
        self.scheduleLoadCount += 1
        return self.scheduleData[stationName]
    }
    
    func shinbundangScheduleDataRemove(stationName: String) {
        self.scheduleData[stationName] = nil
    }
}
