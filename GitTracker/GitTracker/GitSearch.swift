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
    
    
//    static func teste() {
//        var arrayUsuario = NSMutableArray()
//        var arrayMackMobile = NSMutableArray()
//        let auth = "?client_id=5b018f27daf42c91a1da&client_secret=15217ff9ca9d46c2e1d23f774f9eb0ca78eb0161"
//        var url1 = "https://api.github.com/users/Andre113/repos\(auth)"
//        var url2 = "https://api.github.com/users/mackmobile/repos\(auth)"
//        self.searchURL(url1, arrayLocal: arrayUsuario)
//        self.searchURL(url2, arrayLocal: arrayMackMobile)
//        
//        var arrayIntersec = self.interseccao(arrayUsuario, array2: arrayMackMobile)
//        var validados = self.validarPull(arrayIntersec, username:"Andre113")
//        
//        var labels = self.buscarLabel(validados.lastObject as! NSDictionary)
//        for label in labels {
//            println(label["name"] as! String)
//            println(label["url"] as! String)
//        }
//    }
    
    static func buscarRepos(username:String) -> NSArray{
        var arrayUsuario = NSMutableArray()
        var arrayMackMobile = NSMutableArray()
        
        let auth = "?client_id=5b018f27daf42c91a1da&client_secret=15217ff9ca9d46c2e1d23f774f9eb0ca78eb0161"
        
        var cont = true
        var page = 1
        while(cont) {
            var url1 = "https://api.github.com/users/\(username)/repos\(auth)&page=\(page)"
            cont = self.searchURL(url1, arrayLocal: arrayUsuario)
            page++
        }
        cont = true
        page = 1
        
        while(cont){
            var url2 = "https://api.github.com/users/mackmobile/repos\(auth)&page=\(page)"
            cont = self.searchURL(url2, arrayLocal: arrayMackMobile)
            page++
        }
        
        var arrayIntersec = self.interseccao(arrayUsuario, array2: arrayMackMobile)
        return self.validarPull(arrayIntersec, username: username)
    }
    
    
    static func preencheDados(username:String){
        //var dados:NSMutableArray = NSMutableArray()
        
        var pullRequests = self.buscarRepos(username)
        
        for pull in pullRequests {
            var pullRequest = pull as! NSDictionary
            
            var projeto:Projeto = NSEntityDescription.insertNewObjectForEntityForName("Projeto", inManagedObjectContext: CoreDataManager.sharedInstance.context) as! Projeto
            let url = pullRequest.objectForKey("url")
            let arr:[String] = url!.componentsSeparatedByString("/") as! [String]
                
            projeto.nome = arr[arr.count-3]
            projeto.user = ((pullRequest.objectForKey("user"))?.objectForKey("login") as? String)!
            projeto.lastUpdate = ((pullRequest.objectForKey("updated_at")) as? String)!
            
            var labels = self.buscarLabel(pullRequest)
            
            for label in labels{
                var newLabel = NSEntityDescription.insertNewObjectForEntityForName("Label", inManagedObjectContext: CoreDataManager.sharedInstance.context) as! Label
                
                newLabel.desc = label.objectForKey("name") as! String
                newLabel.cor = label.objectForKey("color") as! String
                newLabel.umProjeto = projeto
                projeto.addLabel(newLabel)
                
            }
        }
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func apagarRepos(username:String){
        let userData:NSArray = CoreDataManager.sharedInstance.fetchDataForEntity("Projeto", predicate: NSPredicate(format: "user = %@", username))
        
        var repos = 0
        
        if userData.count > 0 {
            for repo in userData {
                let repoToDelete:Projeto = repo as! Projeto
                CoreDataManager.sharedInstance.context.deleteObject(repoToDelete)
                repos++
            }
        }
        println("Deletados dados de \(repos) repositorios.")
    }
    
    static func autoUpdate(username:String) {
        //atualizaDados(username)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
            while(true){
                
                println("Checando atualizações...")
                
                let changes = self.atualizaDados(username)
                
                if changes.count > 0 {
                    let notif = UILocalNotification()
                    notif.alertTitle = "Repositorios Atualizados!"
                    
                    if changes.count == 1 {
                        notif.alertBody = "\(changes.firstObject!) atualizado."
                    }
                    else {
                        notif.alertBody = "\(changes.firstObject!) e outros \(changes.count-1) repos atualizados."
                    }
                    
                    notif.applicationIconBadgeNumber = 1
                    notif.fireDate = NSDate()
                    UIApplication.sharedApplication().scheduleLocalNotification(notif)
                }
                if changes.count < 1 {
                    let notif = UILocalNotification()
                    notif.alertTitle = "Repositorios sincronizados!"
                    
                    notif.alertBody = "Nada novo por aqui."
                    
                    notif.applicationIconBadgeNumber = 1
                    notif.fireDate = NSDate()
                    UIApplication.sharedApplication().scheduleLocalNotification(notif)
                }
                
                //intervalo entre updates
                NSThread.sleepForTimeInterval(1800)
            }
        })
        
    }
    
    static func atualizaDados(username:String) -> NSMutableArray{
        let changes = NSMutableArray()
        
        let useDef = NSUserDefaults.standardUserDefaults()
        
        //busca os dados já persistidos
        let oldData:NSArray = CoreDataManager.sharedInstance.fetchDataForEntity("Projeto", predicate: NSPredicate(format: "user = %@", useDef.valueForKey("username") as! String))
        
        //busca os dados atuais
        var pullRequests = self.buscarRepos(username)
        
        
        //compara para ver se precisa alterar algo; adiciona repositorios novos se nao houver registro com mesmo nome na base de dados, apaga repositorios que nao tem mais correspondencia nos dados atualizados
        for newProj in pullRequests {
            let newRepo = newProj as! NSDictionary
            
            let url: AnyObject? = newRepo.objectForKey("url")
            let arr:[String] = url!.componentsSeparatedByString("/") as! [String]
            
            let newNome = arr[arr.count-3] as String
            
            //flag que controla se o repo encontrado no github existe no banco de dados local
            var existsInDB = false
            for oldProj in oldData {
                let oldRepo = oldProj as! Projeto
                
                
                //se encontrar correspondencia do novo proj com o antigo
                if oldRepo.nome == newNome {
                    existsInDB = true
                    
                    //se as datas de lastupdate forem diferentes, é preciso atualizar o projeto no coredata
                    if oldRepo.lastUpdate != (newRepo.valueForKey("updated_at") as! String){
                        
                        oldRepo.nome = newNome
                        
                        oldRepo.user = ((newRepo.objectForKey("user"))?.objectForKey("login") as? String)!
                        
                        oldRepo.lastUpdate = newRepo.objectForKey("updated_at") as! String
                        
                        //remove as labels antigas
                        for label in oldRepo.labels {
                            let oldLabel = label as! Label
                            CoreDataManager.sharedInstance.context.deleteObject(oldLabel)
                        }
                        
                        oldRepo.resetLabels()
                        
                        
                        //adiciona as labels atualizadas
                        var labels = self.buscarLabel(newRepo)
                        
                        for label in labels{
                            var newLabel = NSEntityDescription.insertNewObjectForEntityForName("Label", inManagedObjectContext: CoreDataManager.sharedInstance.context) as! Label
                            
                            newLabel.desc = label.objectForKey("name") as! String
                            newLabel.cor = label.objectForKey("color") as! String
                            newLabel.umProjeto = oldRepo
                            oldRepo.addLabel(newLabel)
                        }
                        println("\(oldRepo.nome) updated!")
                        changes.addObject(oldRepo.nome)
                    }else {
                        println("\(oldRepo.nome) UP TO DATE")
                    }
                }//fim do bloco de correspondecia de nomes
            }//fim do bloco de comparacao entre repo no git e no bd
            
            //se nao encontrou no bd um repo que existe na nuvem, criar novo
            if !existsInDB {
                var projeto:Projeto = NSEntityDescription.insertNewObjectForEntityForName("Projeto", inManagedObjectContext: CoreDataManager.sharedInstance.context) as! Projeto
                projeto.nome = newNome
                var login = ((newRepo.objectForKey("user"))?.objectForKey("login") as? String)!
                projeto.user = login.lowercaseString
                projeto.lastUpdate = ((newRepo.objectForKey("updated_at")) as? String)!
                
                var labels = self.buscarLabel(newRepo)
                
                for label in labels{
                    var newLabel = NSEntityDescription.insertNewObjectForEntityForName("Label", inManagedObjectContext: CoreDataManager.sharedInstance.context) as! Label
                    
                    newLabel.desc = label.objectForKey("name") as! String
                    newLabel.cor = label.objectForKey("color") as! String
                    newLabel.umProjeto = projeto
                    projeto.addLabel(newLabel)
                }
                changes.addObject(projeto.nome)
            }
        }//fim da iteracao sobre os repos no git
        
        //testar agora se existe algum repo no banco de dados local que nao existe no git, e entao apaga-lo
        for oldProj in oldData {
            let oldRepo = oldProj as! Projeto
            var existsInGit = false
            
            for newProj in pullRequests {
                let newRepo = newProj as! NSDictionary
                
                let url: AnyObject? = newRepo.objectForKey("url")
                let arr:[String] = url!.componentsSeparatedByString("/") as! [String]
                
                let newNome = arr[arr.count-3] as String
                
                if oldRepo.nome == newNome {
                    existsInGit = true
                }
            }
            
            //se o oldRepo nao existe no git, deve ser deletado do banco de dados local
            if !existsInGit {
                
                //um pouco de redundancia, por precaucao
                for label in oldRepo.labels {
                    let oldLabel = label as! Label
                    CoreDataManager.sharedInstance.context.deleteObject(oldLabel)
                }
                
                CoreDataManager.sharedInstance.context.deleteObject(oldRepo)
            }
        }
        
        CoreDataManager.sharedInstance.saveContext()
        
        return changes
        
        
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
    
    
    //busca os resultados de uma dada URL e adiciona-os ao array passado. retorna false caso nao haja qualquer dado na url (pagina em branco)
    static func searchURL(url: String, arrayLocal: NSMutableArray) -> Bool{
        //        let urlString:String = "https://api.github.com/users/Andre113/repos"
        //        let urlString: String = "file:///Users/AndreLucas/Documents/repos.html"
        //        let urlSearch:NSURL = NSURL(string: urlString)!
        //
        //        if let jsonData: NSData = NSData(contentsOfURL: urlSearch){
        //            var error:NSErrorPointer = NSErrorPointer()
        
        let resultado: AnyObject = (self.geralSearch(url) as? AnyObject)!
        
        if let repositorios = resultado as? NSArray{
            if repositorios.count < 1 {
                return false
            }
            var repositorio: NSDictionary
            
            for repositorio in repositorios{
                let url = repositorio["url"] as! String
                
                arrayLocal.addObject(url)
//                println(url)
            }
        }
        
        return true
        
//        println("***")
//        self.searchOwner()
    }
    
    static func interseccao(array1: NSMutableArray, array2: NSMutableArray) -> NSMutableArray{
        var arraySaida = NSMutableArray()
        
        println("Fazer array de intersecção. Abaixo os forks: ")
        
        for cadaUrl in array1 {
            var splitString:[String] = cadaUrl.componentsSeparatedByString("/") as! [String]
            for cadaOutraUrl in array2 {
                var split2:[String] = cadaOutraUrl.componentsSeparatedByString("/") as! [String]
                if splitString.last == split2.last{
                    println(splitString.last!)
                    arraySaida.addObject(splitString.last!)
                }
            }
        }
//        println("***")
        return arraySaida
    }
    
    static func validarPull(arrayLocal: NSMutableArray, username:String) -> NSMutableArray{
        println("Validar pulls")
        let auth = "client_id=5b018f27daf42c91a1da&client_secret=15217ff9ca9d46c2e1d23f774f9eb0ca78eb0161"
        var arrayPulls = NSMutableArray()
        
        for repository in arrayLocal{
            var url = "https://api.github.com/repos/mackmobile/\(repository)/issues?state=all&\(auth)"
            let resultado: AnyObject = self.geralSearch(url)
            let repositorio:NSArray = resultado.allObjects
            for pullR in repositorio {
                let pullRequest = pullR as! NSDictionary
                if let user = pullRequest["user"] as? NSDictionary{
                    if let login = user["login"] as? String{
                      let loginFormatado = login.lowercaseString
                        if loginFormatado == username {
                            println("Adicionar", repository)
                            arrayPulls.addObject(pullRequest)
                        }
                    }
                }
            }
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
