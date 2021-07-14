//
//  InfoViewController.swift
//  CoreDatabeginner
//
//  Created by IwasakIYuta on 2021/07/12.
//

import UIKit

class InfoViewController: UIViewController {
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var registrInfoLabel: UILabel!
    
    var name = ""
    var email = ""
    
    //セグエによって画面を切り替える
    enum Mode {
        case Mode1
        case Mode2
    }
    var mode: Mode = .Mode1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch mode {
        case .Mode1:
            nameLabel.text = name
            emailLabel.text = email
            registrInfoLabel.text = "このemaliで登録されています、nameが上書きされました"
        case .Mode2:
            nameLabel.text = name
            emailLabel.text = email
            registrInfoLabel.text = "登録情報が変更されました"
        }
       
       
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
