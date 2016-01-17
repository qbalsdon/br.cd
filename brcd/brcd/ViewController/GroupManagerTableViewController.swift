//
//  GroupManagerTableViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/17.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import CoreData

class GroupManagerTableViewController: UITableViewController {

    @IBOutlet var groupTableView: UITableView!
    @IBOutlet var newGroupField: UITextField!
    
    var dataSource = [GroupEntity]()
    var currentGroup: GroupEntity! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        dataSource = fetchAllGroups()
        groupTableView.reloadData()
    }
    
    func fetchAllGroups() -> [GroupEntity] {
        let fetchRequest = NSFetchRequest(entityName: GroupEntity.NAME)
        
        do {
            return try CoreDataStackManager.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [GroupEntity]
        } catch let error as NSError {
            print("Error fetching groups: \(error)")
            return [GroupEntity]()
        }
    }
    
    func addGroup(name: String) {
        print("New group: \(name)")
        let nGroup = NSEntityDescription.insertNewObjectForEntityForName("GroupEntity", inManagedObjectContext: CoreDataStackManager.sharedInstance.managedObjectContext) as? GroupEntity
        
        nGroup?.setValue(name, forKey: GroupEntity.FIELD.NAME.rawValue)
        CoreDataStackManager.sharedInstance.saveContext()
        
        dataSource.insert(nGroup!, atIndex: dataSource.endIndex)
        groupTableView.reloadData()
    }
    
    func nameEntered(alert: UIAlertAction!){
        // store the new word
        addGroup(newGroupField.text!)
    }
    
    // MARK: - Actions
    
    func addTextField(textField: UITextField!){
        textField.placeholder = "New group name"
        textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
        newGroupField = textField
    }
    
    @IBAction func addGroupButtonPressed(sender: AnyObject) {
        let newWordPrompt = UIAlertController(title: "New group", message: "Enter the name of the new group", preferredStyle: UIAlertControllerStyle.Alert)
        newWordPrompt.addTextFieldWithConfigurationHandler(addTextField)
        newWordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        newWordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nameEntered))
        presentViewController(newWordPrompt, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath)

        cell.textLabel!.text = dataSource[indexPath.row].name

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let deleted = dataSource[indexPath.row]
            
            CoreDataStackManager.sharedInstance.managedObjectContext.deleteObject(deleted)
            CoreDataStackManager.sharedInstance.saveContext()
            dataSource.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentGroup = dataSource[indexPath.row]
        performSegueWithIdentifier("showGroupTabController", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGroupTabController" {
            let nc = segue.destinationViewController as! GroupTabBarViewController
            nc.group = currentGroup
        }
    }
}
