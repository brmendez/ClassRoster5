//
//  Person.swift
//  groupPractice2
//
//  Created by Brian Mendez on 8/17/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import Foundation
import UIKit

class Person  : NSObject, NSCoding {
    var firstName : String
    var lastName : String
    var image : UIImage?
    
    
    init (fName: String, lName: String){
        self.firstName = fName
        self.lastName = lName
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(self.firstName, forKey: "firstName")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        //        aCoder.encodeObject(self.image!, forKey: "image")
    }
    
    required init(coder aDecoder: NSCoder) {
        //super.init()
        self.firstName = aDecoder.decodeObjectForKey("firstName") as String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as String
//        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
    }
    
    func fullName() -> String {
        return self.firstName + " " + self.lastName
    }
}


