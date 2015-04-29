//
//  GitSearch.swift
//  GitTracker
//
//  Created by Andre Lucas Ota on 29/04/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GitSearch: NSObject {
    
    let clientID = "5b018f27daf42c91a1da"
    let clientSecret = "15217ff9ca9d46c2e1d23f774f9eb0ca78eb0161"
    
    
    static func teste() {
        var arrayUsuario = NSMutableArray()
        var arrayMackMobile = NSMutableArray()
        let auth = "?client_id=5b018f27daf42c91a1da&client_secret=15217ff9ca9d46c2e1d23f774f9eb0ca78eb0161"
        var url1 = "https://api.github.com/users/Andre113/repos\(auth)"
        var url2 = "https://api.github.com/users/mackmobile/repos\(auth)"
        self.searchURL(url1, arrayLocal: arrayUsuario)
        self.searchURL(url2, arrayLocal: arrayMackMobile)
        
        var arrayIntersec = self.interseccao(arrayUsuario, array2: arrayMackMobile)
        var validados = self.validarPull(arrayIntersec, username:"Andre113")
        
        var labels = self.buscarLabel(validados.lastObject as! NSDictionary)
        for label in labels {
            println(label["name"] as! String)
            println(label["url"] as! String)
        }
    }
    
    static func preencheDados(username:String){
        var dados:NSMutableArray = NSMutableArray()
        
        var arrayUsuario = NSMutableArray()
        var arrayMackMobile = NSMutableArray()
        let auth = "?client_id=5b018f27daf42c91a1da&client_secret=15217ff9ca9d46c2e1d23f774f9eb0ca78eb0161"
        var url1 = "https://api.github.com/users/\(username)/repos\(auth)"
        var url2 = "https://api.github.com/users/mackmobile/repos\(auth)"
        self.searchURL(url1, arrayLocal: arrayUsuario)
        self.searchURL(url2, arrayLocal: arrayMackMobile)
        
        var arrayIntersec = self.interseccao(arrayUsuario, array2: arrayMackMobile)
        var validados = self.validarPull(arrayIntersec, username: username)
        
        for validadoArray in validados {
            var validado = validadoArray as! NSDictionary
            var projeto:Projeto = NSEntityDescription.insertNewObjectForEntityForName("Projeto", inManagedObjectContext: CoreDataManager.sharedInstance.context) as! Projeto
            let url = validado.objectForKey("url")
            let arr:[String] = url!.componentsSeparatedByString("/") as! [String]
                
            projeto.nome = arr[arr.count-3]
            projeto.user = ((validado.objectForKey("user"))?.objectForKey("login") as? String)!
        }
        
        CoreDataManager.sharedInstance.saveContext()
        var labels = self.buscarLabel(validados.lastObject as! NSDictionary)
        
    }
    
    static func geralSearch(url: String) -> AnyObject{
        let urlSearch:NSURL = NSURL(string: url)!
        if let jsonData: NSData = NSData(contentsOfURL: urlSearch){
            var error:NSErrorPointer = NSErrorPointer()
            
            let resultado: AnyObject = (NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error:error))!
            
            return resultado
        }
        else{
            println("Erro. Url inválida")
            return NSObject()
        }
    }
    
    static func searchURL(url: String, arrayLocal: NSMutableArray){
        //        let urlString:String = "https://api.github.com/users/Andre113/repos"
        //        let urlString: String = "file:///Users/AndreLucas/Documents/repos.html"
        //        let urlSearch:NSURL = NSURL(string: urlString)!
        //
        //        if let jsonData: NSData = NSData(contentsOfURL: urlSearch){
        //            var error:NSErrorPointer = NSErrorPointer()
        
        let resultado: AnyObject = (self.geralSearch(url) as? AnyObject)!
        
        if let repositorios = resultado as? NSArray{
            var repositorio: NSDictionary
            
            for repositorio in repositorios{
                let url = repositorio["url"] as! String
                
                arrayLocal.addObject(url)
                println(url)
            }
        }
//        println("***")
        //        self.searchOwner()
    }
    
    static func interseccao(array1: NSMutableArray, array2: NSMutableArray) -> NSMutableArray{
        var arraySaida = NSMutableArray()
        
        for cadaUrl in array1 {
            var splitString:[String] = cadaUrl.componentsSeparatedByString("/") as! [String]
            for cadaOutraUrl in array2 {
                var split2:[String] = cadaOutraUrl.componentsSeparatedByString("/") as! [String]
                if splitString.last == split2.last{
//                    println("SAO IGUAIS!!!")
//                    println(splitString.last)
                    arraySaida.addObject(splitString.last!)
                }
            }
        }
//        println("***")
        return arraySaida
    }
    
    static func validarPull(arrayLocal: NSMutableArray, username:String) -> NSMutableArray{
        let auth = "?client_id=5b018f27daf42c91a1da&client_secret=15217ff9ca9d46c2e1d23f774f9eb0ca78eb0161"
        var arrayPulls = NSMutableArray()
        
        for repositorio in arrayLocal{
            var url = "https://api.github.com/repos/mackmobile/\(repositorio)/issues\(auth)"
            let resultado: AnyObject = self.geralSearch(url)
            let repositorio:NSArray = resultado.allObjects
            for pullR in repositorio {
                let pullRequest = pullR as! NSDictionary
                if let user = pullRequest["user"] as? NSDictionary{
                    if let login = user["login"] as? String{
                        if login == username {
//                            println("Adicionar")
                            arrayPulls.addObject(pullRequest)
                        }
                    }
                }
            }
//            println("**************")
        }
        return arrayPulls
    }
    
    static func buscarLabel(pullRequest: NSDictionary) -> NSArray{
        var arraySaida = NSMutableArray()
        
        let labels: NSArray = pullRequest["labels"] as! NSArray
        
        
//        for eachLabel in labels{
//            let label: NSDictionary = eachLabel as! NSDictionary
//            let newLabel = LabelT()
//            newLabel.desc = eachLabel["name"] as! String
//            newLabel.cor = eachLabel["color"] as! String
//            arraySaida.addObject(newLabel)
//        }
        
        return labels
    }
}
