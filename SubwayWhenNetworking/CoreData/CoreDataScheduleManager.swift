//
//  CoreDataScheduleManager.swift
//  SubwayWhenNetworking
//
//  Created by 이윤수 on 9/12/24.
//

import Foundation

import CoreData

class CoreDataScheduleManager: CoreDataScheduleManagerProtocol {
    private init() {
        UserDefaults.standard.set(true, forKey: "com.apple.CoreData.SQLDebug")
    }
    static let shared = CoreDataScheduleManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataScheduleModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func shinbundangScheduleDataSave(to scheduleData: [String: [ShinbundangScheduleModel]], scheduleVersion: Int) -> Bool {
        for (stationName, schedules) in scheduleData {
            let insertedObject = NSEntityDescription.insertNewObject(forEntityName: "ShinbundangLineScheduleModel", into: self.context)
            if let entity = insertedObject as? ShinbundangLineScheduleModel {
                entity.stationName = stationName
                entity.scheduleData = schedules
                entity.scheduleVersion = scheduleVersion
            }
        }
        
        do {
            try self.context.save()
            return true
        } catch {
            print("CORE DATA ERROR: ", error)
            return false
        }
    }
    
    func shinbundangScheduleDataLoad(stationName: String) -> [ShinbundangLineScheduleModel] {
        let request: NSFetchRequest<ShinbundangLineScheduleModel> = ShinbundangLineScheduleModel.fetchRequest()
        request.predicate = NSPredicate(format: "stationName == %@", stationName)
        
        do {
            let results = try self.context.fetch(request)
            print("MAMONAKU", results)
            
            return results
        } catch {
            print("Core Data Fetch Error: \(error)")
            return []
        }
    }
}
