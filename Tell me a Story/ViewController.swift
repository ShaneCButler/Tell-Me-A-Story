//
//  ViewController.swift
//  Tell me a Story
//
//  Created by Shane Butler on 09/02/2018.
//  Copyright © 2018 Shane Butler. All rights reserved.
//

import UIKit
import CoreData

var destinationURL: URL!
var textFileName: String!


class ViewController: UIViewController {
    
    

    
   
    @IBOutlet weak var createStoryTap: UIView!
    @IBOutlet weak var helpTap: UIView!
    @IBOutlet weak var openStoryTap: UIView!
    @IBOutlet weak var labelview: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = documentsDirectory.appendingPathComponent("Stories")
        folderPath = dataPath
        let dataPathString = dataPath.absoluteString
        if directoryExistsAtPath(dataPathString) != true{
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
        }
        else{
            print(dataPath)
        }
        print(dataPath)
        
        let createStoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCreateTap))
        createStoryTap.addGestureRecognizer(createStoryTapGesture)
        
        let helpTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHelpTap))
        helpTap.addGestureRecognizer(helpTapGesture)
        
        let openStoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenTap))
        openStoryTap.addGestureRecognizer(openStoryTapGesture)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleCreateTap() {
        performSegue(withIdentifier: "CreateStorySegue", sender: self)
    }
    
    @objc func handleOpenTap() {
        performSegue(withIdentifier: "OpenStorySegue", sender: self)
    }
    
    @objc func handleHelpTap() {
        performSegue(withIdentifier: "HelpSegue", sender: self)
    }
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    

}

