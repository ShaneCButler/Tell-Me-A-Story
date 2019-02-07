//
//  ViewStoryViewController.swift
//  Tell me a Story
//
//  Created by Shane Butler on 04/03/2018.
//  Copyright © 2018 Shane Butler. All rights reserved.
//

import UIKit

class ViewStoryViewController: UIViewController {

    var fileURLs: [URL] = []
    var pageCount = 1
    var backgroundCount = 0
    var pageString = ""
    var pageURL = destinationURL
    var storyText: [String] = []
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBAction func onCloseButton(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        if pageCount > 1 {
            pageCount = pageCount - 1
            intToString()
            let image = UIImage(contentsOfFile: (pageURL?.path)!)
            MainImageView.image = image
            textLabel.text = storyText[pageCount - 1]
        }
        else
        {
            MainImageView.image = MainImageView.image
            textLabel.text = textLabel.text
        }
    }
    
    @IBAction func forwardButton(_ sender: Any) {
        if pageCount == fileURLs.count - 1
        {
            MainImageView.image = MainImageView.image
            textLabel.text = textLabel.text
        }
        else{
            pageCount = pageCount + 1
            intToString()
            let image = UIImage(contentsOfFile: (pageURL?.path)!)
            MainImageView.image = image
            textLabel.text = storyText[pageCount - 1]
        }
    }
    
    @IBOutlet weak var MainImageView: UIImageView!
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        shareButton.isHidden = true
        closeButton.isHidden = true
        forwardButton.isHidden = true
        backButton.isHidden = true
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        
        
        shareButton.isHidden = false
        closeButton.isHidden = false
        forwardButton.isHidden = false
        backButton.isHidden = false
        let alertController = UIAlertController(title: "Saved", message: "Image has been saved to gallery", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            
            let ac = UIAlertController(title: "Saved!", message: "The screenshot has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findFiles()
        intToString()
        pageURL = destinationURL.appendingPathComponent(textFileName)
        
        do {
            let textFile = try String(contentsOfFile: pageURL!.path)
            storyText = textFile.components(separatedBy: "\n")
        } catch {
            Swift.print("Fatal Error: Couldn't read the contents!")
        }
        print(storyText[1])
        pageURL = destinationURL.appendingPathComponent(pageString)
        let image = UIImage(contentsOfFile: (pageURL?.path)!)
        MainImageView.image = image
        textLabel.text = storyText[0]
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findFiles(){
        let fileManager = FileManager.default
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil)
        } catch {
            print("Error while enumerating files \(destinationURL.path): \(error.localizedDescription)")
        }
        print(fileURLs)
    }
    func intToString(){
        pageString = String(pageCount)
        pageURL = destinationURL.appendingPathComponent(pageString)
    }


}
