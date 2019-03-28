//
//  AllSetViewController.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/14/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit

class AllSetViewController: UIViewController {
    
    //  MARK: - Variables

    @IBOutlet weak var backToWeather: UIButton!
    @IBOutlet weak var runImageView: UIImageView!
    @IBOutlet weak var readyToGoLabel: UILabel!
    
    let runImage1 = UIImage(named: "run1")
    let runImage2 = UIImage(named: "run2")
    let runImage3 = UIImage(named: "run3")
    let runImage4 = UIImage(named: "run4")
    let runImage5 = UIImage(named: "run5")
    let runImage6 = UIImage(named: "run6")
    let runImage7 = UIImage(named: "run7")
    let runImage8 = UIImage(named: "run8")
    var images: [UIImage] = []
    var viewControllers: [UIViewController] = []
    
    // MARK: - View Loading
    
    override func viewWillAppear(_ animated: Bool) {

        // https://github.com/codepath/ios_guides/wiki/Animating-A-Sequence-of-Images
        images = [runImage1, runImage2, runImage3, runImage4, runImage5, runImage6, runImage7, runImage8] as! [UIImage]
        let animatedImage = UIImage.animatedImage(with: images, duration: 1.0)
        runImageView.image = animatedImage
        runImageView.center.x  -= view.bounds.width * (3/4)
        
        // https://www.raywenderlich.com/363-ios-animation-tutorial-getting-started
        UIView.animate(withDuration: 4.0,
                       animations: {
                        self.runImageView.isHidden = false
                        self.runImageView.center.x += self.view.bounds.width
                        self.runImageView.center.x += self.view.bounds.width
                        },
                       completion: { _ in UIView.animate(withDuration: 0.5) {
                        self.readyToGoLabel.center.y += self.view.bounds.height / 4
                        }}
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backToWeather.layer.cornerRadius =  10.0
        backToWeather.layer.masksToBounds = true
    }
    
    // MARK: - Actions
    
    // https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift
    // https://stackoverflow.com/questions/26132658/pop-2-view-controllers-in-nav-controller-in-swift
    @IBAction func clickBackToWeather(_ sender: Any) {
        viewControllers = self.navigationController!.viewControllers
        let destination = viewControllers[viewControllers.count - 3]
        self.navigationController!.popToViewController(destination, animated: true)
    }
}
