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

    @IBOutlet weak var backButtonInNavBar: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the title of the help.
        // This creates the frame for the label, position and so on.
        lblTitle.frame = CGRect(x: 0, y: 89, width: self.view.frame.width, height: 120)
        // Add some text.
        lblTitle.text = "HELP"
        // Alignment.
        lblTitle.textAlignment = .center
        // Color of the background.
        lblTitle.backgroundColor = UIColor.gray
        // Color of the text.
        lblTitle.textColor = UIColor.white
        // The font.
        lblTitle.font = UIFont(name: "Arial-BoldMT", size: 22)
        
        // Add it to the view.
        self.view.addSubview(lblTitle)
        
        lblSection1.frame = CGRect(x: 50, y: 150, width: 300, height: 200)
        lblSection1.text = "To play this game, first press on your screen to load in the map and then spawn the snake."
        lblSection1.textAlignment = .left
        lblSection1.textColor = UIColor.black
        lblSection1.font = UIFont(name: "Arial", size: 16)
        lblSection1.adjustsFontSizeToFitWidth = true
        lblSection1.minimumScaleFactor = 0.5
        lblSection1.allowsDefaultTighteningForTruncation = true
        // I have to figure out line breaks.
        lblSection1.numberOfLines = 10
        lblSection1.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.view.addSubview(lblSection1)

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
