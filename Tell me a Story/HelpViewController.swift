//
//  HelpViewController.swift
//  Tell me a Story
//
//  Created by Shane Butler on 25/02/2018.
//  Copyright © 2018 Shane Butler. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class HelpViewController: UIViewController {

    @IBOutlet weak var videoBox: UIImageView!
    @IBAction func onCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        player.pause()
    }
    var player: AVPlayer!
    
    //var avPlayer: AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        let filepath: String? = Bundle.main.path(forResource: "Help Video", ofType: "mov")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        
        player = AVPlayer(url: fileURL)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
