//
//  HelpViewController.swift
//  Snake It AR
//
//  Created by Jonathan Hallén on 2019-04-11.
//  Copyright © 2019 snake-group. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    // Create a new label.
    var lblTitle = UILabel()
    var lblSection1 = UILabel()
    var lblSection2 = UILabel()

    @IBOutlet weak var backButtonInNavBar: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the title of the help.
        // This creates the frame for the label, position and so on.
        lblTitle.frame = CGRect(x: 0, y: 89, width: self.view.frame.width, height: 60)
        // Add some text.
        lblTitle.text = "HELP"
        // Alignment.
        lblTitle.textAlignment = .center
        // Color of the background.
        lblTitle.backgroundColor = UIColor.gray
        // Color of the text.
        lblTitle.textColor = UIColor.white
        // The font.
        lblTitle.font = UIFont(name: "Arial-BoldMT", size: 32)
        
        // Add it to the view.
        self.view.addSubview(lblTitle)
        
        lblSection1.frame = CGRect(x: 50, y: 150, width: 275, height: 120)
        lblSection1.text = "To play this game, first press on your screen to load in the map and then spawn the snake. After the snake spawns, it will begin to move. You can control the direction, by swiping left or right."
        lblSection1.textAlignment = .left
        lblSection1.textColor = UIColor.black
        lblSection1.font = UIFont(name: "Arial", size: 16)
        lblSection1.adjustsFontSizeToFitWidth = true
        lblSection1.minimumScaleFactor = 0.5
        lblSection1.allowsDefaultTighteningForTruncation = true
        lblSection1.numberOfLines = 20
        lblSection1.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.view.addSubview(lblSection1)
        
        lblSection2.frame = CGRect(x: 50, y: 250, width: 275, height: 120)
        lblSection2.text = "Collect fruits to collect points. Try to avoid the snake and walls! Hitting anything, that is NOT a fruit, will end the game!"
        lblSection2.textAlignment = .left
        lblSection2.textColor = UIColor.black
        lblSection2.font = UIFont(name: "Arial", size: 16)
        lblSection2.adjustsFontSizeToFitWidth = true
        lblSection2.minimumScaleFactor = 0.5
        lblSection2.allowsDefaultTighteningForTruncation = true
        lblSection2.numberOfLines = 20
        lblSection2.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.view.addSubview(lblSection2)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
