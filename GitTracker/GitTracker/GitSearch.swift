//
//  GitSearch.swift
//  GitTracker
//
//  Created by Andre Lucas Ota on 29/04/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import Foundation

class GitSearch: NSObject {
    func main() {
        var arrayUsuario = NSMutableArray()
        var arrayMackMobile = NSMutableArray()
        
        var url1 = "file:///Users/AndreLucas/Documents/HTML/reposAndre113.html"
        var url2 = "file:///Users/AndreLucas/Documents/HTML/reposMackMobile.html"
        self.searchURL(url1, arrayLocal: arrayUsuario)
        self.searchURL(url2, arrayLocal: arrayMackMobile)
        
        self.interseccao(arrayUsuario, array2: arrayMackMobile)
    }
    
    func geralSearch(url: String) -> AnyObject{
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
    
    func searchURL(url: String, arrayLocal: NSMutableArray){
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
        println("***")
        //        self.searchOwner()
    }
    
    func interseccao(array1: NSMutableArray, array2: NSMutableArray) -> NSMutableArray{
        var arraySaida = NSMutableArray()
        
        
    }
    
    //    func searchOwner(){
    ////        for url: String in self.arrayRepositorio{
    ////            let urlSearch:NSURL = NSURL(string: url)!
    ////            if let jsonData: NSData = NSData(contentsOfURL: urlSearch{
    ////            var error:NSErrorPointer = NSErrorPointer()
    //        var url: String = "file:///Users/AndreLucas/Documents/insideRepos.html"
    //
    //        let resultado: AnyObject = (self.geralSearch(url) as? AnyObject)!
    //            if let parent = resultado["parent"] as? NSDictionary{
    //                if let owner = parent["owner"] as? NSDictionary{
    //                    if let login = owner["login"] as? String{
    //                        println(login)
    //                        if (login == "mackmobile"){
    //                            println("Nome válido, coloca no array")
    //                            self.arrayRepositorio.append(url)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    ////    }

}
