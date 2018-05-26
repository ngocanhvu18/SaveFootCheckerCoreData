//
//  DataService.swift
//  SaveFootCheckerCoreData
//
//  Created by Ngọc Anh on 5/25/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit
import CoreData
class DataService {
    static let share: DataService = DataService()
   var fetchResultController: NSFetchedResultsController<Entity>{
    if _fetchResultController != nil {
        return _fetchResultController!
    }
    let fetchRequest : NSFetchRequest<Entity> = Entity.fetchRequest()
    fetchRequest.fetchBatchSize = 20
    let sortDescriptor = NSSortDescriptor (key: "text", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let afetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: "Master")
    _fetchResultController = afetchResultController
    do{try _fetchResultController?.performFetch()
        
    }
    catch{
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    return _fetchResultController!
    }
    private var _fetchResultController: NSFetchedResultsController<Entity>? = nil
    
    // Dete data
    func removeData (from indexPath: IndexPath){
        guard let context = _fetchResultController?.managedObjectContext else {return}
        context.delete((_fetchResultController?.object(at: indexPath))!)
        saveToCoreData()
    }
    
    // Save Data
    func saveToCoreData() {
        let context = _fetchResultController?.managedObjectContext
        do {
            try context?.save()
            print("Core Data Saved")
        } catch let error as NSError {
            print("\(error.userInfo)")
        }
    }
}

