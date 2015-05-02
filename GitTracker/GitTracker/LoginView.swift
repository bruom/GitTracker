//
//  LoginView.swift
//  GitTracker
//
//  Created by Andre Lucas Ota on 30/04/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let useDef = NSUserDefaults.standardUserDefaults()
        
        if useDef.valueForKey("username") != nil {
            self.textField.text = useDef.valueForKey("username") as! String
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goButton(sender: UIButton) {
        let usernameFormatado:String = self.textField.text.lowercaseString
        
        let regex: NSRegularExpression = NSRegularExpression(pattern:"^[a-z]([a-z]| |\\+|\\(|\\)|'|\\^)*", options:NSRegularExpressionOptions.CaseInsensitive , error: nil)!
        
        let match = regex.numberOfMatchesInString(usernameFormatado, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, count(usernameFormatado)))
        
        if match == 0 {
            sender.userInteractionEnabled = false
            UIView.animateWithDuration(0.06, animations: { () -> Void in
                UIView.setAnimationRepeatCount(7.4)
                self.textField.transform = CGAffineTransformMakeTranslation(0, 4)
            }, completion: { (comp) -> Void in
                self.textField.transform = CGAffineTransformMakeTranslation(0, 0)
                sender.userInteractionEnabled = true
            })

        }
        else{
            let useDef = NSUserDefaults.standardUserDefaults()
            let newUser = usernameFormatado.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            useDef.setValue(newUser as String, forKey: "username")
            let view = self.storyboard?.instantiateViewControllerWithIdentifier("TableView") as! MasterViewController
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
