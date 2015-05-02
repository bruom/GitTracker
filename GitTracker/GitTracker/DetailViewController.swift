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
    
    var arrayLabels: [UILabel] = []
    
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
            println("Erro ao carregar dados do projeto.")
            return
        }
        
        
        self.title = projeto.nome
        //metodo que configura as infos das views.
        self.configurarConteudo(projeto)
        
        if projeto.labels.count < 1 {
            println("No labels.")
            //colocar labellegal aqui
        }
        else{
            
//            for eachLabel in projeto.labels{
//                let gitLabel = eachLabel as! Label
//            }

            
            
            //ordenando por tipo
            var bronzes = NSMutableArray()
            var pratas = NSMutableArray()
            var ouros = NSMutableArray()
            var misc = NSMutableArray()
            
            
            
            
            for eachLabel in projeto.labels {
                let gitLabel = eachLabel as! Label
                
                if gitLabel.desc.hasPrefix("Bronze") {
                    bronzes.addObject(gitLabel)
                }
                else if gitLabel.desc.hasPrefix("Prata") {
                    pratas.addObject(gitLabel)
                }
                else if gitLabel.desc.hasPrefix("Ouro") {
                    ouros.addObject(gitLabel)
                }
                else {
                    misc.addObject(gitLabel)
                }
            }
            
            //ordenando por numero
            bronzes = NSMutableArray(array: bronzes.sortedArrayUsingComparator({ (l1, l2) -> NSComparisonResult in
                return l1.desc.compare(l2.desc)
            }))
            pratas = NSMutableArray(array: pratas.sortedArrayUsingComparator({ (l1, l2) -> NSComparisonResult in
                return l1.desc.compare(l2.desc)
            }))
            ouros = NSMutableArray(array: ouros.sortedArrayUsingComparator({ (l1, l2) -> NSComparisonResult in
                return l1.desc.compare(l2.desc)
            }))
            misc = NSMutableArray(array: misc.sortedArrayUsingComparator({ (l1, l2) -> NSComparisonResult in
                return l1.desc.compare(l2.desc)
            }))
            
            var labelsEmOrdem = NSMutableArray()
            
            for eachLabel in bronzes {
                labelsEmOrdem.addObject(eachLabel)
            }
            for eachLabel in pratas {
                labelsEmOrdem.addObject(eachLabel)
            }
            for eachLabel in ouros {
                labelsEmOrdem.addObject(eachLabel)
            }
            for eachLabel in misc {
                labelsEmOrdem.addObject(eachLabel)
            }
                
            
            var alturaLabel:CGFloat = self.view.frame.size.height*0.8
            //adicionando a tela
            for eachLabel in labelsEmOrdem {
                let gitLabel = eachLabel as! Label
                
                let uiLabel:UILabel = UILabel(frame: CGRectMake(10, CGFloat(alturaLabel), 100, 40))
                
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
                //uiLabel.center = self.view.center
                uiLabel.center = CGPointMake(self.view.center.x, alturaLabel)
                
                self.view.addSubview(uiLabel)
                self.arrayLabels.append(uiLabel)
                alturaLabel = alturaLabel - 50
            }
        }
    }
    
    func configurarConteudo(projeto: Projeto){
        var nomeLabel:UILabel = UILabel(frame: CGRectMake(self.view.frame.origin.x + 30, self.view.frame.origin.y + 100, self.view.bounds.maxX, 40))
        nomeLabel.text = "Repositorio: ".stringByAppendingString(projeto.nome)
        
        var userLabel:UILabel = UILabel(frame: CGRectMake(self.view.frame.origin.x + 30, nomeLabel.frame.origin.y + 40, self.view.bounds.maxX, 40))
        userLabel.text = "Usuario: ".stringByAppendingString(projeto.user)
        
        var lastUpdateLabel:UILabel = UILabel(frame: CGRectMake(self.view.frame.origin.x + 30, userLabel.frame.origin.y + 40, self.view.bounds.maxX, 40))
        lastUpdateLabel.text = "Ultima atualização: ".stringByAppendingString(projeto.lastUpdate)
        
        self.view.addSubview(nomeLabel)
        self.view.addSubview(userLabel)
        self.view.addSubview(lastUpdateLabel)
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
        self.fisica()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fisica(){
        gravity = UIGravityBehavior(items: self.arrayLabels)
        gravity.magnitude = 0.3
        
        collision = UICollisionBehavior(items: self.arrayLabels)
        collision.collisionMode = UICollisionBehaviorMode.Everything
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundaryWithIdentifier("tela", fromPoint: CGPointMake(self.view.frame.minX, self.view.frame.maxY), toPoint: CGPointMake(self.view.frame.maxX, self.view.frame.maxY))
        
        properties = UIDynamicItemBehavior(items: self.arrayLabels)
        properties.allowsRotation = false
        properties.elasticity = 0.8
        properties.resistance = 0.2
        
        animator.addBehavior(properties)
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
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

