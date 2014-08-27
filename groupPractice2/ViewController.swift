//
//  ViewController.swift
//  groupPractice2
//
//  Created by Brian Mendez on 8/17/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var teacherArray = [Person]()
    var personArray = [Person]()
    var allArrays = [[Person]]()
    var preProfile : Person!
    
    var sectionsArray = ["Students", "Teachers"]

//MARK: ViewDidLoad - Append
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    
        if let people = NSKeyedUnarchiver.unarchiveObjectWithFile(documentsPath + "/archive") as? [[Person]] {
            
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
         
        NSKeyedArchiver.archiveRootObject(allArrays, toFile: documentsPath + "/archive")
            //not great, or this is the first time they launched.
        }
    
    }
    
    //when transitioning back to ViewController after selecting name
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        var people = NSKeyedArchiver.archiveRootObject(allArrays, toFile: documentsPath + "/archive")
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        println("number of sections in tableview")
        return self.allArrays.count
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
//        println(self.numberOfSectionCounter++)
        return allArrays[section].count
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return sectionsArray[section]
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.imageView.image = allArrays[indexPath.section][indexPath.row].image
        cell.textLabel.text = allArrays[indexPath.section][indexPath.row].fullName()
        self.preProfile = allArrays[indexPath.section][indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let indexPath = self.tableView.indexPathForSelectedRow()
        if segue.identifier == "showDetail" {
        let destination = segue.destinationViewController as DetailViewController
        destination.personSegue = allArrays[indexPath.section][indexPath.row]
        }
    }
    
//    sectionIndexTitlesForTableView(<#tableView: UITableView!#>)
    
}