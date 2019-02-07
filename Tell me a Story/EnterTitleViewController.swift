//
//  EnterTitleViewController.swift
//  Tell me a Story
//
//  Created by Shane Butler on 27/02/2018.
//  Copyright © 2018 Shane Butler. All rights reserved.
//

import UIKit
import CoreData
var folderPath: URL!
var storyPath: URL!
var textFileURL: URL!
var backgroundURL: URL!


class EnterTitleViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func onCloserButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onGoButton(_ sender: Any) {
        let lastchar = (nameField.text)?.last!
        if nameField.text != "" && lastchar != " "
        {
            let storyTitle = nameField.text
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataPath = documentsDirectory.appendingPathComponent("Stories")
            folderPath = dataPath
            let newDataPath = dataPath.appendingPathComponent(nameField.text!)
            let checkPathString = newDataPath.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: checkPathString) != true{
            do {
                try FileManager.default.createDirectory(atPath: newDataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
            }
            else{
                nameExistsAlertBox()
            }
            storyPath = newDataPath
            textFileName = storyTitle! + ".txt"
            textFileURL = newDataPath.appendingPathComponent(textFileName)
            FileManager.default.createFile(atPath: textFileURL.path, contents: nil, attributes: nil)
            print(newDataPath)
            
            performSegue(withIdentifier: "LetsGoSegue", sender: self)
        }
        else
        {
            alertBox()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertBox() {
        let alertController = UIAlertController(title: "Please try again", message: "There was an error in this title. Either you have not entered anything, or the last character is a space.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func nameExistsAlertBox() {
        let alertController = UIAlertController(title: "Please try again", message: "This title has already been used, please pick another.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
        
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
    return documentsDirectory
    }

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws
    {
        
    }
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        print(exists)
        return exists && isDirectory.boolValue
    }


