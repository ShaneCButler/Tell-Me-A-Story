//
//  CreateStoryViewController.swift
//  Tell me a Story
//
//  Created by Shane Butler on 25/02/2018.
//  Copyright © 2018 Shane Butler. All rights reserved.
//

import UIKit


class CreateStoryViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {

   
    @IBOutlet weak var textFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var pointerButton: UIButton!
    @IBOutlet weak var brushButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var MainImageView: UIImageView!
    @IBOutlet weak var TempImageView: UIImageView!
    @IBOutlet weak var storyText: UITextField!
    var count = 1
    var lastPoint = CGPoint.zero //keep track of the last tocuh point
    var red: CGFloat = 0.0 //RGB values
    var green: CGFloat = 0.0 //RGB values
    var blue: CGFloat = 0.0 //RGB values
    var swiped = false //has the user swiped the screen
    var backgroundRed: CGFloat = 255.0 //RGB values
    var backgroundGreen: CGFloat = 255.0 //RGB values
    var backgroundBlue: CGFloat = 255.0 //RGB values
    var backgroundColour: UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0) //set initial background colour
    var brushSize: CGFloat = 5.0 //set brush sizze
    var tempBrushSize: CGFloat = 5.0 //set temporary brush size when user eraser
    var eraserPressed = false //checks to see if the user is using the brush or an eraser
    var savedBackgroundImage: UIImage!
    var backgroundChanged = false
    var imageCount = 0
    var changeColourPressed = false //stops the user accidentally drawing when on the change colour page
    var pickedImage: String!
    var emojiCount = 0 //how many emojis are on the screen
    var emojiImageViews: [UIImageView] = []//array of emojis
    var movingEmoji = false //is the emoji moving
    var fileURLs: [URL] = []
    var pageCount = 1
    var backgroundCount = 0 //how many backgrounds have been selected
    var pageString = ""
    var pageURL = destinationURL
    var storyTextFill: [String] = []
    var editedText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TempImageView.bringSubview(toFront: storyText)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        if editStory == true {
        findFiles()
        intToString()
        pageURL = destinationURL.appendingPathComponent(textFileName)
            
        do {
            let textFile = try String(contentsOfFile: pageURL!.path)
            storyTextFill = textFile.components(separatedBy: "\n")
        } catch {
            Swift.print("Fatal Error: Couldn't read the contents!")
        }
        print(storyTextFill[1])
        pageURL = destinationURL.appendingPathComponent(pageString)
        let image = UIImage(contentsOfFile: (pageURL?.path)!)
        MainImageView.image = image
        storyText.text = storyTextFill[0]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }

    }
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        if eraserPressed == true {
        MainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
            
        context?.setLineCap(.round)
        context?.setLineWidth(brushSize)
            
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        context?.setBlendMode(.copy)
        context?.strokePath()
            
        MainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        MainImageView.alpha = 1
        }
        else{
        TempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(.round)
        context?.setLineWidth(brushSize)
       
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(.normal)
        
        
        context?.strokePath()
        
        TempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        TempImageView.alpha = 1
        }
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if changeColourPressed == true{
          changeColourPressed = true
        }
        else if movingEmoji == true {
            movingEmoji = true
        }
        else {
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLine(fromPoint: lastPoint, toPoint: currentPoint)

            lastPoint = currentPoint
        }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLine(fromPoint: lastPoint, toPoint: lastPoint)
        }

        UIGraphicsBeginImageContextWithOptions(MainImageView.frame.size, false, 0.0)

        MainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: 1.0)
        TempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: 1.0)
        MainImageView.image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        TempImageView.image = nil
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        if movingEmoji == true {
        let view = sender.view
        self.view.bringSubview(toFront: view!)
        let translation = sender.translation(in: self.view)
            view?.center = CGPoint(x: (view?.center.x)! + translation.x, y: (view?.center.y)! + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @IBAction func changeColour(_ sender: Any) {
        changeColourPressed = true
        performSegue(withIdentifier: "changeColourSegue", sender: self)
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if editStory == true{
            if pageCount == fileURLs.count - 1
            {
                let alertController = UIAlertController(title: "No more pages", message: "This is the last page of the story", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.finished()
                pageCount = pageCount + 1
                intToString()
                let image = UIImage(contentsOfFile: (pageURL?.path)!)
                MainImageView.image = image
                storyText.text = storyTextFill[pageCount - 1]
            }
        }
        else {
        if storyText.text != "" {
            let alertController = UIAlertController(title: "Next Page", message: "Are you sure you have finshed this page?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.finished()
            }))
            
            alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            alertBox()
        }
        }
    }
    
    @IBAction func stickerButton(_ sender: Any) {
         performSegue(withIdentifier: "stickerSegue", sender: self)
    }
    
    @IBAction func finishedButton(_ sender: Any) {
        if storyText.text != "" {
            let alertController = UIAlertController(title: "Finished", message: "Are you sure you have finished this page?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                if editStory == true {
                    self.pageURL = destinationURL.appendingPathComponent(textFileName)
                    if FileManager.default.fileExists(atPath: (self.pageURL?.path)!) {
                        let fileHandle = FileHandle(forWritingAtPath: (self.pageURL?.path)!)
                        
                        fileHandle!.seek(toFileOffset: UInt64(0))
                        fileHandle!.write(self.editedText.data(using: .utf8)!)
                        fileHandle!.closeFile()
                    }
                }
                self.finished()
                editStory = false
                self.dismiss(animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            alertBox()
        }
    }
    @IBAction func eraserButton(_ sender: Any) {
        if eraserPressed == false {
        tempBrushSize = brushSize
        brushSize = 30.0
        eraserPressed = true
        movingEmoji = false
        }
    }
    
    @IBAction func pointerButtonPressed(_ sender: Any) {
        movingEmoji = true
        
    }
    @IBAction func brushButton(_ sender: Any) {
        brushSize = tempBrushSize
        eraserPressed = false
        movingEmoji = false
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func alertBox() {
        let alertController = UIAlertController(title: "Please try again", message: "Please enter some text for your story before continuing", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func finished() {
        
        let countString = String(count)
        var fileURL: URL!
        if editStory == true {
        fileURL = destinationURL.appendingPathComponent(countString)
        }
        else {
        fileURL = storyPath.appendingPathComponent(countString)
        }
        var backImage: UIImage!
        let backImageView = UIImageView(frame: UIScreen.main.bounds)
        if backgroundChanged == true{
        backImage = savedBackgroundImage // The image used as a background
        backImageView.image = backImage
        }
        else{
        backImage = UIImage(color: backgroundColour) // The image used as a background
        backImageView.image = backImage // Create the view holding the image
        }
        backImageView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        UIGraphicsBeginImageContextWithOptions(backImageView.frame.size, false, 0.0)
        brushButton.isHidden = true
        eraserButton.isHidden = true
        stickerButton.isHidden = true
        nextPageButton.isHidden = true
        settingsButton.isHidden = true
        finishedButton.isHidden = true
        storyText.isHidden = true
        pointerButton.isHidden = true
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        backImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        brushButton.isHidden = false
        eraserButton.isHidden = false
        stickerButton.isHidden = false
        nextPageButton.isHidden = false
        settingsButton.isHidden = false
        finishedButton.isHidden = false
        storyText.isHidden = false
        pointerButton.isHidden = false
        
        if let data = UIImageJPEGRepresentation(backImageView.image!, 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
                print(countString)
                count = count + 1
            } catch {
                print("error saving file:", error)
            }
            if FileManager.default.fileExists(atPath: textFileURL.path) {
                let fileHandle = FileHandle(forWritingAtPath: textFileURL.path)
                
                fileHandle!.seekToEndOfFile()
                let inputText = storyText.text! + "\n"
                fileHandle!.write(inputText.data(using: .utf8)!)
                fileHandle!.closeFile()
            }
        }
        else if editStory == true{
            let data = UIImageJPEGRepresentation(backImageView.image!, 1.0)
            do {
                try data?.write(to: fileURL)
                print("file saved")
                print(countString)
                count = count + 1
                print("balls")
            } catch {
                print("error saving file:", error)
            }
            editedText.append(contentsOf: storyText.text! + "\n")
            
        }
        
        
        MainImageView.image = nil
        storyText.text = nil
        if emojiImageViews.count > 0 { //crashed the app if there was no emojis used so making sure there is more than 0.
        for i in 0...emojiImageViews.count-1{
            emojiImageViews[i].removeFromSuperview()//remove Stickers
        }
        }
    }
    func changeBackgroundColour()
    {
        backgroundColour = UIColor(red: backgroundRed, green: backgroundGreen, blue: backgroundBlue, alpha: 1.0)
        MainImageView.backgroundColor = backgroundColour
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
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.textFieldConstraint?.constant = 55
            } else {
                self.textFieldConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if changeColourPressed == true {
        let changeColourViewController = segue.destination as! ChangeColourViewController
        changeColourViewController.delegate = self
        changeColourViewController.red = red
        changeColourViewController.green = green
        changeColourViewController.blue = blue
        changeColourViewController.brushSize = brushSize
        }
        else{
        let stickerCollectionViewController = segue.destination as! StickerCollectionViewController
        stickerCollectionViewController.delegate = self
        stickerCollectionViewController.selectedItem = pickedImage
        }
    }
}
extension CreateStoryViewController: ChangeColourViewControllerDelegate {
    func backgroundChanged(_ changeColourViewController: ChangeColourViewController) {
        self.backgroundRed = changeColourViewController.red
        self.backgroundGreen = changeColourViewController.green
        self.backgroundBlue = changeColourViewController.blue
        changeBackgroundColour()
        backgroundChanged = false
    }
    func brushChanged(_ changeColourViewController: ChangeColourViewController){
        self.red = changeColourViewController.red
        self.green = changeColourViewController.green
        self.blue = changeColourViewController.blue
    }
    func sizeChanged(_ changeColourViewController: ChangeColourViewController){
        self.brushSize = changeColourViewController.brushSize
    }
    func backgroundImage(_ changeColourViewController: ChangeColourViewController){
        MainImageView.backgroundColor = nil
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = changeColourViewController.backgroundImage
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: imageCount)
        imageCount = imageCount + 1
        savedBackgroundImage = changeColourViewController.backgroundImage
        backgroundChanged = true
    }
    func end(_ changeColourViewController: ChangeColourViewController){
       changeColourPressed = false
    }
    
}

extension CreateStoryViewController: StickerCollectionViewControllerDelegate {
    
    func pickedSticker(_ stickerCollectionViewController: StickerCollectionViewController) {
        pickedImage = stickerCollectionViewController.selectedItem
        print(pickedImage)
        print("AHHHHHHHHHHHHHHHHSHDHHFHFHGHGKKDD")
        let imageView = UIImageView(image: pickedImage.emojiToImage())
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 60, height: 60)
        imageView.center = TempImageView.center
        imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        emojiImageViews.append(imageView)
        print(emojiImageViews.count)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(CreateStoryViewController.draggedView(_:)))
        gesture.delegate = self
        imageView.addGestureRecognizer(gesture)
        movingEmoji = true
        
    }
}
extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 60, height: 60)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 50)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
    
    
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}


    



