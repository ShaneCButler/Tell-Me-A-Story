//
//  ChangeColourViewController.swift
//  Tell me a Story
//
//  Created by Shane Butler on 26/02/2018.
//  Copyright © 2018 Shane Butler. All rights reserved.
//

import UIKit

protocol ChangeColourViewControllerDelegate: class {
    func backgroundChanged(_ changeColourViewController: ChangeColourViewController)
    func brushChanged(_ changeColourViewController: ChangeColourViewController)
    func sizeChanged(_ changeColourViewController: ChangeColourViewController)
    func backgroundImage(_ changeColourViewController: ChangeColourViewController)
    func end(_ changeColourViewController: ChangeColourViewController)
}


class ChangeColourViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var brushSizeLabal: UILabel!
    
    @IBOutlet weak var colourImageView: UIImageView!
    
    let photoPicker = UIImagePickerController()
    
    @IBAction func backgroundColourButton(_ sender: Any) {
        self.delegate?.backgroundChanged(self)
    }
    @IBAction func brushColourButton(_ sender: Any) {
        self.delegate?.brushChanged(self)
    }
    
    @IBAction func pickPhotoButton(_ sender: Any) {
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        pressed = true
        present(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func onCloseButton(_ sender: Any) {
        self.delegate?.sizeChanged(self)
        self.delegate?.end(self)
        if pressed == true{
        self.delegate?.backgroundImage(self)
        dismiss(animated: true, completion: nil)
        }
        else
        {
        dismiss(animated: true, completion: nil)
        }

    }
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushSize: CGFloat = 10.0
    var backgroundImage: UIImage!
    var pressed = false
    
    weak var delegate: ChangeColourViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        redSlider.value = Float(red)
        redValueLabel.text = String(format: "%d", Int(redSlider.value))
        greenSlider.value = Float(green)
        greenValueLabel.text = String(format: "%d", Int(greenSlider.value))
        blueSlider.value = Float(blue)
        blueValueLabel.text = String(format: "%d", Int(blueSlider.value))
        brushSizeLabal.text = String(format: "%d", Int(brushSizeSlider.value))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeColour(_ sender: Any) {
        
        red = CGFloat(redSlider.value / 255.0)
        redValueLabel.text = String(format: "%d", Int(redSlider.value))
        green = CGFloat(greenSlider.value / 255.0)
        greenValueLabel.text = String(format: "%d", Int(greenSlider.value))
        blue = CGFloat(blueSlider.value / 255.0)
        blueValueLabel.text = String(format: "%d", Int(blueSlider.value))
        
        colourPreview()
    }
    
    @IBAction func changeBrushSize(_ sender: Any) {
        brushSize = CGFloat(brushSizeSlider.value)
        brushSizeLabal.text = NSString(format: "%.2f", brushSize.native) as String
        colourPreview()
    }
    
    func colourPreview() {
        UIGraphicsBeginImageContext(colourImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineWidth(brushSize)
        
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.move(to: CGPoint(x: 60, y: 60))
        context?.addLine(to: CGPoint(x: 60, y: 60))
        context?.strokePath()
        colourImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func imagePickerController(_ photoPicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        backgroundImage = newImage
        dismiss(animated: true)
    }
    
}

