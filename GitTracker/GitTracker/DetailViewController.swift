//
//  DetailViewController.swift
//  GitTracker
//
//  Created by Bruno Omella Mainieri on 4/27/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //@IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailLabel:UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "configureView:", name: "setContent", object: nil)
        detailLabel = UILabel(frame: CGRectMake(200, self.view.frame.size.height/2, 300, 50))
        detailLabel.text = "Default"
        self.view.addSubview(detailLabel)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        detailLabel = UILabel(frame: CGRectMake(200, self.view.frame.size.height/2, 300, 50))
        detailLabel.text = "Default"
        self.view.addSubview(detailLabel)
        center.addObserver(self, selector: "configureView:", name: "setContent", object: nil)
    }
    
    func configureView(notif:NSNotification) {
        // Update the user interface for the detail item.
        let details = notif.userInfo as! Dictionary<String,Projeto>
        let detail = details["Projeto"]!
        detailLabel.text = detail.nome
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
//        
//        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
//        center.addObserver(self, selector: "configureView:", name: "setContent", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

