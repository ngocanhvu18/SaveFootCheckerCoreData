//
//  MasterViewController.swift
//  SaveFootCheckerCoreData
//
//  Created by Ngọc Anh on 5/25/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {
    
    var fetchResultController = DataService.share.fetchResultController
    var searchController: UISearchController!
    var entity : [Entity] = []
//    @IBOutlet var tableViewController: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResultController.delegate = self
        // set searchBar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Meal"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        navigationItem.hidesSearchBarWhenScrolling = true
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive {
            return entity.count
        }
        return fetchResultController.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MealViewCell
        let filterEntity = searchController.isActive ? entity[indexPath.row] : fetchResultController.object(at: indexPath)
        configureCell(cell, withEntity: filterEntity)

        return cell
    }
    
    func configureCell(_ cell: MealViewCell, withEntity entity: Entity) {
        cell.labelName!.text = entity.name
        cell.rantingController.rating = Int(entity.ranting)
        cell.photoView?.image = entity.photo as? UIImage
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
  
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataService.share.removeData(from: indexPath)
           
        } else if editingStyle == .insert {
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let masterViewController = segue.destination as? DetailViewController{
            if let indexPath = tableView.indexPathForSelectedRow{
                let filterEntity = searchController.isActive ? entity[indexPath.row] : fetchResultController.object(at: indexPath)
                masterViewController.entity = filterEntity
                searchController.isActive = false
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue ) {
    
    }

}
extension MasterViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)! as! MealViewCell, withEntity: anObject as! Entity)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)! as! MealViewCell, withEntity: anObject as! Entity)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
extension MasterViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchtext = searchController.searchBar.text{
            let context = fetchResultController.fetchedObjects ?? []
             entity = context.filter({(data) -> Bool in
                return data.name?.range(of: searchtext, options: .caseInsensitive, range: nil, locale: nil) != nil
             })
            tableView.reloadData()
        }
    }
}
