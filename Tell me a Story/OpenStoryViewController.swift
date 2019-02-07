//
//  OpenStoryViewController.swift
//  Tell me a Story
//
//  Created by Shane Butler on 04/03/2018.
//  Copyright © 2018 Shane Butler. All rights reserved.
//

import UIKit
var editStory = false
class OpenStoryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var fileURLs: [URL] = []
    
    

    @IBOutlet weak var pickStory: UIPickerView!
    @IBAction func onGoButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectStoryButton(_ sender: Any) {
        destinationURL = fileURLs[pickStory.selectedRow(inComponent: 0)]
        textFileName = destinationURL.lastPathComponent + ".txt"
        print(textFileName)
        performSegue(withIdentifier: "ViewStorySegue", sender: self)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this story?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.delete()
            self.findFolders()
            self.pickStory.reloadAllComponents()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func editStoryButton(_ sender: Any) {
        destinationURL = fileURLs[pickStory.selectedRow(inComponent: 0)]
        textFileName = destinationURL.lastPathComponent + ".txt"
        editStory = true
        performSegue(withIdentifier: "editStorySegue", sender: self)
    }
    
    override func viewDidLoad() {
        pickStory.delegate = self
        pickStory.dataSource = self
        super.viewDidLoad()
        findFolders()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delete()
    {
        let fileManager = FileManager.default
        destinationURL = fileURLs[pickStory.selectedRow(inComponent: 0)]
        do {
            try fileManager.removeItem(at: destinationURL)
        }catch {
            print("Could not delete folder: \(error)")
        }
    }
    
    func findFolders(){
        let fileManager = FileManager.default
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil)
        } catch {
            print("Error while enumerating files \(folderPath.path): \(error.localizedDescription)")
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fileURLs.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fileURLs[row].lastPathComponent
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
