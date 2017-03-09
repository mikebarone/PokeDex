//
//  Pokemon.swift
//  PokeDex
//
//  Created by Mike Barone on 2017-03-07.
//  Copyright © 2017 Mike Barone. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    
    private var _pokemonURL: String!
    
    var nextEvolutionName: String {
        return _nextEvolutionName == nil ? "" : _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        return _nextEvolutionId == nil ? "" : _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        return _nextEvolutionLevel == nil ? "" : _nextEvolutionLevel
    }
    
    var nextEvolutionTxt: String {
        return _nextEvolutionTxt == nil ? "" : _nextEvolutionTxt
    }
    
    var attack: String {
        return _attack == nil ? "" : _attack
    }
    
    var weight: String {
        return _weight == nil ? "" : _weight
    }
    
    var height: String {
        return _height == nil ? "" : _height
    }
    
    var defense: String {
        return _defense == nil ? "" : _defense
    }
    
    var type: String {
        return _type == nil ? "" : _type
    }
    
    var description: String {
        return _description == nil ? "" : _description
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String,String>], types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descrArr = dict["descriptions"] as? [Dictionary<String,String>], descrArr.count > 0 {
                    if let url = descrArr[0]["resource_uri"] {
                        let descrURL = "\(URL_BASE)\(url)"
                        Alamofire.request(descrURL).responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? Dictionary<String,AnyObject> {
                                if let description = descDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>], evolutions.count > 0 {
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvolution
                            
                            if let url = evolutions[0]["resource_uri"] as? String {
                                let newStr = url.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoId
                                if let lvlExist = evolutions[0]["level"] {
                                    if let lvl = lvlExist as? Int {
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                            
                        }
                    }
                }
                
                
            }
            
            completed()
            
        }
    }
}
