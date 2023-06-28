//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 22/06/23.
//

import Foundation
import CoreData

open class PersistentContainer: NSPersistentContainer {
}

struct CoreDataManager {
    
    static var shared = CoreDataManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: PersistentContainer? = {
        guard let modelURL = Bundle.module.url(forResource:"LoggerModel", withExtension: "momd") else { return  nil }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
        let container = PersistentContainer(name:"LoggerModel",managedObjectModel:model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


//    lazy var context = persistentContainer.viewContext
    // MARK: - Core Data Saving support

    mutating func saveContext(_ completion: @escaping(_ status: Bool) -> Void) {
           let context = persistentContainer?.viewContext
//           let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
//           let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//           privateMOC.parent = moc
//           privateMOC.perform({
//               do {
//                   try privateMOC.save()
//                   completion(true)
//               } catch {
//                   completion(false)
//                   fatalError("Failure to save context: \(error)")
//               }
//           })
           if ((context?.hasChanges) != nil) {
               do {
                   try context?.save()
                   completion(true)
               } catch {
                   completion(false)
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
   
               }
           }
       }
    
    mutating func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]?
    {
        let context = persistentContainer?.viewContext
        do {
            
            guard let result = try context?.fetch(managedObject.fetchRequest()) as? [T] else {return nil}
            return result

        } catch let error {
            debugPrint(error)
        }

        return nil
    }
    
    mutating func deleteManagedObject<T: NSManagedObject>(managedObject: T)
    {
        let context = persistentContainer?.viewContext
        context?.delete(managedObject)
        saveContext { status in
            
        }

    }
    
    mutating func checkForExistingData<T: NSManagedObject>(paramId: String,checkValue: Any,managedObject: T.Type)
    {
        let context = persistentContainer?.viewContext
        do {
            print("paramId name===",paramId)
            print("value=====",checkValue)
            let request : NSFetchRequest = managedObject.fetchRequest()
            request.predicate = NSPredicate(format: "legGuid == %d", checkValue as! CVarArg)
            let numberOfRecords = try context?.count(for: request)
            print("number of records====",numberOfRecords)
//            guard let result = try context.fetch(managedObject.fetchRequest()) as? [T] else {return nil}
//            return result

        } catch let error {
            debugPrint(error)
        }

//        return nil
    }
    
     mutating func clearDatabase() {
         guard let url = persistentContainer?.persistentStoreDescriptions.first?.url else { return }
        
         let persistentStoreCoordinator = persistentContainer?.persistentStoreCoordinator

         do {
             try persistentStoreCoordinator?.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
             try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
             print("successfully cleared the DB")
         } catch {
             print("Attempted to clear persistent store: " + error.localizedDescription)
         }
    }
}

