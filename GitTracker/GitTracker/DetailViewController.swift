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


    var projeto:Projeto!
    var gravity = UIGravityBehavior()
    var animator = UIDynamicAnimator()
    var collision = UICollisionBehavior()
    var properties = UIDynamicItemBehavior()
    
    //var detailLabel:UILabel!
//    lazy var detailLabel:UILabel = {
//        let label: UILabel = UILabel(frame: CGRectMake(200, self.view.frame.size.height/2, 300, 50))
//        return label
//    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "configureView:", name: "setContent", object: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "configureView:", name: "setContent", object: nil)
    }
    
    func configureView(notif:NSNotification) {
        // Update the user interface for the detail item.
        let details = notif.userInfo as! Dictionary<String,Projeto>
        projeto = details["Projeto"]!
        
        if nil == projeto {
            println("CHAMA OS BOMBEIRO")
            return
        }
        
        if projeto.labels.count < 1 {
            println("NOLABELS")
            //colocar labellegal aqui
        }
        else{
            var floatLegal:Float = 100.0
            for eachLabel in projeto.labels {
                let gitLabel = eachLabel as! Label
                let uiLabel:UILabel = UILabel(frame: CGRectMake(20, CGFloat(floatLegal), 100, 30))
                
                uiLabel.text = gitLabel.desc
                
                //uiLabel.frame.size.width = uiLabel.font.pointSize * CGFloat(count(gitLabel.desc))
                uiLabel.numberOfLines = 1
                uiLabel.sizeToFit()
                uiLabel.frame.size.height += 2
                uiLabel.frame.size.width += 10
                uiLabel.textAlignment = NSTextAlignment.Center
                
                uiLabel.backgroundColor = hexStringToUIColor(gitLabel.cor)
                uiLabel.layer.borderWidth = 2.0
                uiLabel.layer.borderColor = hexStringToUIColor(gitLabel.cor).CGColor
                uiLabel.layer.cornerRadius = 10.0
                uiLabel.layer.masksToBounds = true
                
                self.view.addSubview(uiLabel)
                floatLegal += 50
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
//
//        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
//        center.addObserver(self, selector: "configureView:", name: "setContent", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        let label: UILabel = UILabel(frame: CGRectMake(200, self.view.frame.size.height/2, 300, 25))
        let label2: UILabel = UILabel (frame: CGRectMake(170, self.view.frame.size.height/2 + 130, 300, 25))
        
        label.text = projeto.nome as? String
        label2.text = projeto.user as? String
        
        self.view.addSubview(label)
        self.view.addSubview(label2)
        var arrayLabels2 = [label, label2]
        
        gravity = UIGravityBehavior(items: arrayLabels2)
        gravity.magnitude = 0.4
        
        collision = UICollisionBehavior(items: arrayLabels2)
        collision.collisionMode = UICollisionBehaviorMode.Everything
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundaryWithIdentifier("tela", fromPoint: CGPointMake(self.view.frame.minX, self.view.frame.maxY), toPoint: CGPointMake(self.view.frame.maxX, self.view.frame.maxY))
        
        properties = UIDynamicItemBehavior(items: arrayLabels2)
        properties.allowsRotation = false
        properties.elasticity = 0.8
        properties.resistance = 0.4
        
        animator.addBehavior(properties)
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        // let label: UILabel = UILabel(frame: CGRectMake(200, self.view.frame.size.height/2, 300, 50))
        // label.text = projeto.nome as? String
        // 
        // self.view.addSubview(label)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }


}

