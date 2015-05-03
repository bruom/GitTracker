//
//  MainViewController.swift
//  GitTracker
//
//  Created by Bruno Omella Mainieri on 5/2/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import UIKit
import CoreData

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ativIndicator: UIActivityIndicatorView!
    
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var manager: CoreDataManager!
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    var projetoArray: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //projetoArray = self.manager.fetchDataForEntity("Projeto", predicate:nil)
        manager = CoreDataManager.sharedInstance
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.blurView.hidden = true
        
        //self.view.backgroundColor = UIColor(netHex: 0xf99608)
        
        let useDef = NSUserDefaults.standardUserDefaults()
        
        projetoArray = NSMutableArray(array: manager.fetchDataForEntity("Projeto", predicate: NSPredicate(format: "user = %@", useDef.valueForKey("username") as! String)))
        
        let refreshButton = UIBarButtonItem(title: "Atualizar", style: UIBarButtonItemStyle.Plain, target: self, action: "atualizarButton:")
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let toolbar = UIToolbar(frame: CGRectMake(-16, self.view.frame.size.height - 50, self.view.frame.size.width, 50))
        toolbar.items?.append(refreshButton)
        
        self.view.addSubview(toolbar)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "atualizarButton:")
        self.navigationItem.rightBarButtonItem = addButton
        
        
        //GitSearch.teste()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.atualizaDados()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailView: DetailViewController = DetailViewController()
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        let projeto = projetoArray.objectAtIndex(indexPath.row) as! Projeto
        center.postNotificationName("setContent", object: nil, userInfo: ["Projeto": projetoArray.objectAtIndex(indexPath.row)])
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    func loading() {
        self.blurView.hidden = false
        self.ativIndicator.startAnimating()
    }
    
    func stopLoading() {
        self.blurView.hidden = true
        self.ativIndicator.stopAnimating()
    }
    
    func atualizaDados() {
        let useDef = NSUserDefaults.standardUserDefaults()
        projetoArray = NSMutableArray(array: manager.fetchDataForEntity("Projeto", predicate: NSPredicate(format: "user = %@", useDef.valueForKey("username") as! String)))
        self.tableView.reloadData()
    }
    
    func atualizarButton(sender:UIButton!){
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            dispatch_async(dispatch_get_main_queue(), {
                self.loading()
            })
            
            let useDef = NSUserDefaults.standardUserDefaults()
            GitSearch.atualizaDados(useDef.valueForKey("username") as! String)
            
            self.atualizaDados()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.stopLoading()
            })
            
        })
        
        
//        let useDef = NSUserDefaults.standardUserDefaults()
//        GitSearch.atualizaDados(useDef.valueForKey("username") as! String)
//        
//        self.atualizaDados()
    }
    
    //    func refreshList(sender: AnyObject) {
    //        let context = self.manager.context
    //
    //
    //        var jsonArray: NSMutableArray = NSMutableArray()
    //
    //        for item in jsonArray {
    //
    //        }
    //
    //    }
    
    func insertNewObject(sender: AnyObject) {
        let context = self.manager.context
        //let entity = self.fetchedResultsController.fetchRequest.entity!
        
        let useDef = NSUserDefaults.standardUserDefaults()
        
        GitSearch.preencheDados(useDef.valueForKey("username") as! String)
        
        self.atualizaDados()
        
    }
    
    // MARK: - Segues
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "showDetail" {
    //            if let indexPath = self.tableView.indexPathForSelectedRow() {
    //            let object = self.projetoArray.objectAtIndex(indexPath.row) as! NSManagedObject
    //            (segue.destinationViewController as! DetailViewController).detailItem = object
    //            }
    //        }
    //    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projetoArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.manager.context
            //            let predicate: NSPredicate = NSPredicate(format: "nome = %@", projetoArray.objectAtIndex(indexPath.row).valueForKey("nome") as! String)
            //            let results = manager.fetchDataForEntity("Projeto", predicate: predicate)
            //            let objeto: NSManagedObject = results.firstObject as! NSManagedObject
            context.deleteObject(projetoArray.objectAtIndex(indexPath.row) as! NSManagedObject)
            projetoArray.removeObjectAtIndex(indexPath.row)
            self.tableView.reloadData()
            
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        println("Vai configurar")
        let esseProjeto = projetoArray.objectAtIndex(indexPath.row) as! Projeto
        println("conteudo: \(esseProjeto.nome)")
        cell.textLabel!.text = esseProjeto.nome
        cell.detailTextLabel?.text = esseProjeto.lastUpdate
        
        println(esseProjeto.nome + "foi montado")
    }
}
