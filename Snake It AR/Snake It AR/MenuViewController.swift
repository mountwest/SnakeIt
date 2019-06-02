//
//  MenuViewController.swift
//  Snake It AR
//
//  Created by Jonathan Hallén on 2019-04-11.
//  Copyright © 2019 snake-group. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var recentScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        UpdateScoreLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UpdateScoreLabels()
    }
    
    func UpdateScoreLabels() {
        recentScoreLabel.text = String(UserDefaults.standard.integer(forKey: "RecentScore"))
        highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "Highscore"))
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
