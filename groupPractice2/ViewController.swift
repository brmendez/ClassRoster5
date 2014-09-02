//
//  ViewController.swift
//  groupPractice2
//
//  Created by Brian Mendez on 8/17/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//


/* Questions
    -how do I persist rounded images from DVC to VC? Where is it done? DVC or VC at CellForRowAtIndexPath?
    -how do I know if something points by value/ref?
    -how do i get default profile picture to stay archived?
*/

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
//MARK: Var Arrays
    var teacherArray = [Person]()
    var personArray = [Person]()
    var allArrays = [[Person]]()
    var preProfile : Person!
    var archive = "/archive8"
    
    var sectionsArray = ["Students", "Teachers"]

//MARK: ViewDidLoad - Append
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        if let people = NSKeyedUnarchiver.unarchiveObjectWithFile(documentsPath + "\(archive)") as? [[Person]] {
            
            self.allArrays = people
            //this is great, it loaded our stuff
            
        } else {

            var kori = Person(fName: "Kori", lName: "Kolo")
            var brian = Person(fName: "Brian", lName: "Mendez")
            
            var brad = Person(fName: "Brad", lName: "Johnson")
            var john = Person(fName: "John", lName: "Clem")
            
            personArray = [kori, brian]
            teacherArray = [brad, john]
            allArrays = [personArray, teacherArray]
         
            
        NSKeyedArchiver.archiveRootObject(allArrays, toFile: documentsPath + "\(archive)")
            //not great, or this is the first time they launched.
        }
    
    }
    
    //when transitioning back to ViewController after selecting name
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        NSKeyedArchiver.archiveRootObject(allArrays, toFile: documentsPath + "\(archive)")
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return self.allArrays.count
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
//        println(self.numberOfSectionCounter++)
        return allArrays[section].count
    }
    
//MARK: TitleForHeader
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return sectionsArray[section]
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool{
        
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            
            
            allArrays[indexPath.section].removeAtIndex(indexPath!.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            NSKeyedArchiver.archiveRootObject(allArrays, toFile: documentsPath + "\(archive)")
        }
    }
    
//MARK: CellForRow
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    
        cell.textLabel.text = allArrays[indexPath.section][indexPath.row].fullName()
        self.preProfile = allArrays[indexPath.section][indexPath.row]
        return cell
    }
    
//MARK: PrepForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let indexPath = self.tableView.indexPathForSelectedRow()
        if segue.identifier == "showDetail" {
        let destination = segue.destinationViewController as DetailViewController
        destination.personSegue = allArrays[indexPath.section][indexPath.row]
        }
        if segue.identifier == "addNewPerson" {
            let destination = segue.destinationViewController as DetailViewController
            destination.personSegue = Person(fName: " ", lName: " ")
            personArray.append(destination.personSegue)
            var students = self.allArrays[0] as [Person]
            students.append(destination.personSegue!)
            self.allArrays[0] = students
        }
    }
    
}