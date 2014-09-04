//
//  DetailViewController.swift
//  groupPractice2
//
//  Created by Brian Mendez on 8/18/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,  UINavigationControllerDelegate, UIAlertViewDelegate {
    
    var personProfile : Person!
    var imageQueue = NSOperationQueue()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var gitHubUserNameTextField: UITextField!
    @IBOutlet weak var gitHubPhotoImageView: UIImageView!

//MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.layer.cornerRadius = 100
        self.profileImage.contentMode = UIViewContentMode.ScaleToFill
        self.profileImage.clipsToBounds = true
        if self.personProfile?.image != nil {
            self.profileImage.image = self.personProfile?.image
        }
        else {
            self.profileImage.image = UIImage(named: "placeHolder")
        }
        
        if self.personProfile?.gitHubPhoto != nil {
            self.gitHubPhotoImageView.image = self.personProfile?.gitHubPhoto
        }
        else {
            self.gitHubPhotoImageView.image = UIImage(named: "github.jpg")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.firstNameTextField.text = self.personProfile.firstName
        self.lastNameTextField.text = self.personProfile.lastName
        self.gitHubUserNameTextField.text = self.personProfile!.gitHubUserName
    }
    override func viewWillDisappear(animated: Bool) {
        self.personProfile.firstName = self.firstNameTextField.text
        self.personProfile.lastName = self.lastNameTextField.text
        self.personProfile!.gitHubUserName = self.gitHubUserNameTextField.text
       
    }

//MARK: Action Alert!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: Camera
    @IBAction func selectPicture(sender: AnyObject) {
        self.revealCamera()
    }
    
    
    func revealCamera(){
        var imagePickerController = UIImagePickerController()
        
        
        imagePickerController.delegate = self
        //checks for camera
        imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePickerController.allowsEditing = true
        
        //shows camera view
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
//MARK: Image Picker
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        var editedImage = info[UIImagePickerControllerEditedImage] as UIImage
        self.personProfile.image = editedImage
        self.profileImage.image = editedImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
//MARK: GitHub TextField
    
    @IBAction func gitHubGrabInfoButton (sender: AnyObject) {
        
        var alertTextField : UITextField = UITextField()
        var typeGitHubName = UIAlertController(title: "Github", message: "Enter your Github Username", preferredStyle:.Alert)
        typeGitHubName.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Username"
            alertTextField = textField
        })
        
        typeGitHubName.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        typeGitHubName.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.gitHubUserNameTextField.text = alertTextField.text
            self.personProfile.gitHubUserName = alertTextField.text
            self.gitHubProfilePicture(alertTextField.text)
        })
        self.presentViewController(typeGitHubName, animated: true, completion: nil)
    }
    
//MARK: Github Profile API Call
    
    func gitHubProfilePicture(userNameGit: String) -> Void {
        let githubURL = NSURL(string: "https://api.github.com/users/\(userNameGit)")
        var githubProfilePhotoURL = NSURL()
        self.imageQueue.addOperationWithBlock { () -> Void in
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(githubURL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    println("Error Report")
                }
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if err != nil {
                    println("Error json")
                }
                if let avatarURL = jsonResult["avatar_url"] as? String {
                    githubProfilePhotoURL = NSURL(string: avatarURL)
                }
                var profilePhotoData = NSData(contentsOfURL: githubProfilePhotoURL)
                var profilePhotoImage = UIImage(data: profilePhotoData)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.gitHubPhotoImageView.image = profilePhotoImage
                    self.personProfile!.gitHubPhoto = profilePhotoImage
                })
            })
            task.resume()
        }
    }
}