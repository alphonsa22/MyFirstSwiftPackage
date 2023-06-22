//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 22/06/23.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static var shared = CoreDataManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

//    lazy var context = persistentContainer.viewContext
    // MARK: - Core Data Saving support

    mutating func saveContext() {
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
    
    mutating func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]?
    {
        let context = persistentContainer.viewContext
        do {
            
            guard let result = try context.fetch(managedObject.fetchRequest()) as? [T] else {return nil}
            return result

        } catch let error {
            debugPrint(error)
        }

        return nil
    }
    
    mutating func deleteManagedObject<T: NSManagedObject>(managedObject: T)
    {
        let context = persistentContainer.viewContext
            context.delete(managedObject)
            saveContext()

    }
    
    mutating func checkForExistingData<T: NSManagedObject>(paramId: String,checkValue: Any,managedObject: T.Type)
    {
        let context = persistentContainer.viewContext
        do {
            print("paramId name===",paramId)
            print("value=====",checkValue)
            let request : NSFetchRequest = managedObject.fetchRequest()
            request.predicate = NSPredicate(format: "legGuid == %d", checkValue as! CVarArg)
            let numberOfRecords = try context.count(for: request)
            print("number of records====",numberOfRecords)
//            guard let result = try context.fetch(managedObject.fetchRequest()) as? [T] else {return nil}
//            return result

        } catch let error {
            debugPrint(error)
        }

//        return nil
    }
    
     mutating func clearDatabase() {
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }
        
        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

         do {
             try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
             try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
         } catch {
             print("Attempted to clear persistent store: " + error.localizedDescription)
         }
    }
}

