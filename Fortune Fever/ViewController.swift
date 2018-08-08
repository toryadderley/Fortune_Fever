//
//  ViewController.swift
//  Fortune Fever
//

//  Copyright © 2018 Tory Adderley. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var totalPoints: Int = 0
    var slotIndex1: Int = 0
    var slotIndex2: Int = 0
    var slotIndex3: Int = 0
    var canPressStopButton: Bool = false
    
    var AudioPlayer: AVAudioPlayer!
    
    struct Colors {
        static let yellow = UIColor.init(red: 240.0/255.0, green: 230.0/255.0, blue: 140.0/255.0, alpha: 1)
        static let greenishYellow = UIColor.init(red: 195.0/255.0, green:255.0/255.0, blue: 0.0/255.0, alpha: 1)
    }

    @IBOutlet weak var slotImage1: UIImageView!
    @IBOutlet weak var slotImage2: UIImageView!
    @IBOutlet weak var slotImage3: UIImageView!
    @IBOutlet weak var awardMoney: UILabel!

    var orderedSlotImages: [UIImage] = [ ]
    var randomSlotImages: [UIImage] = [ ]
    lazy var last = randomSlotImages.count - 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderedSlotImages = createArray(total: 10, imagePrefix: "points")
        randomSlotImages = createArray(total: 10, imagePrefix: "points")
        shuffleSlotImages()
        awardMoney.text = "$0"
        
        setGradientBackground(colorOne: Colors.greenishYellow, colorTwo: Colors.yellow)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createArray(total: Int, imagePrefix: String) -> [UIImage] {
        
        var imageArray: [UIImage] = []
        
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount).png"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        return imageArray
    }
    
    func shuffleSlotImages() {
        
        while(last > 0) {
            let rand = Int(arc4random_uniform(UInt32(last)))
            randomSlotImages.swapAt(last, rand)
            last -= 1
            }
    }
    
    func animate(imageView: UIImageView, images: [UIImage]) {
        
        imageView.animationImages = images
        if imageView == slotImage1 {
            imageView.animationDuration = 1
        }
        else if imageView == slotImage2 {
            imageView.animationDuration = 1.5
        }
        else if imageView == slotImage3 {
            imageView.animationDuration = 2
        }
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    func finalResult(imageView: UIImageView, index: Int) -> Int {
        
        imageView.stopAnimating()
        let index = Int(arc4random_uniform(10))
        imageView.image = orderedSlotImages[index]
        return index
    }
    
    func playSound(filename: String, fileExtension: String) {
        let audioUrl: URL!
        audioUrl = Bundle.main.url(forResource: filename, withExtension: fileExtension)
        
        do{
            AudioPlayer = try AVAudioPlayer.init(contentsOf: audioUrl)
            AudioPlayer.prepareToPlay()
            if filename == "slot-machine" {
                AudioPlayer.numberOfLoops = -1
            }
            AudioPlayer.play()
        }
        catch{
            print(error)
        }
    }

    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
            
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
    
    
    @IBAction func letsPlayButtonPress(_ sender: UIButton) {
        
        animate(imageView: slotImage1, images: randomSlotImages)
        animate(imageView: slotImage2, images: randomSlotImages)
        animate(imageView: slotImage3, images: randomSlotImages)
        
        awardMoney.text = "$0"
        canPressStopButton = true
        
        playSound(filename: "slot-machine", fileExtension: "mp3")
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        
        if canPressStopButton == true {
            totalPoints = finalResult(imageView: slotImage1, index: slotIndex1) +
                finalResult(imageView: slotImage2, index: slotIndex2) +
                finalResult(imageView: slotImage3, index: slotIndex3)
        
            awardMoney.text = "$" + "\(totalPoints)"
            
            canPressStopButton = false
            
            if totalPoints < 10{
                playSound(filename: "Sad_Trombone", fileExtension: "mp3")
            }
            if totalPoints >= 10{
                playSound(filename: "Cha_Ching", fileExtension: "mp3")
            }
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        animate(imageView: slotImage1, images: randomSlotImages )
        animate(imageView: slotImage2, images: randomSlotImages)
        animate(imageView: slotImage3, images: randomSlotImages)
        
        awardMoney.text = "$0"
        canPressStopButton = true
    }
}

