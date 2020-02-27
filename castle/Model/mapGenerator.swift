//
//  mapGenerator.swift
//  castle
//
//  Created by Titouan Blossier on 28/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//

import Foundation

class MapGenerator {
    static let shared = MapGenerator()
    private init() { }
    
    func generateMap(players : Int) -> (Array<Castle>, Array<Ways>){
        var combinationPossible = false
        
        var castles : Array<Castle> = []
        var ways : Array<Ways> = []
        
        while combinationPossible == false {
            castles = []
            ways = []
            for i in 0...players * 3 - 1{ //Génération des emplacements
                let castle = Castle()
                var possible = false
                while possible == false {
                    castle.x = Int.random(in: 100...900)
                    castle.y = Int.random(in: 100...900)
                    if castles.count != 0 {
                        for i in castles {
                            let xDistance = (castle.x - i.x) * (castle.x - i.x)
                            let yDistance = (castle.y - i.y) * (castle.y - i.y)
                            let distance = round(sqrt(Double(xDistance) + Double(yDistance)))
                            if distance > 300{
                                possible = true
                            }
                        }
                    } else {
                        possible = true
                    }
                }
                castle.id = i
                castles.append(castle)
            }
            
            
            //On connecte les chateaux
            for castle in castles {
                for destination in castles {
                    if destination.id != castle.id {
                        let xDistance = (castle.x - destination.x) * (castle.x - destination.x)
                        let yDistance = (castle.y - destination.y) * (castle.y - destination.y)
                        let distance = round(sqrt(Double(xDistance) + Double(yDistance)))
                        if distance < 400 { //On peut créer une route
                            let way = Ways()
                            way.beginId = castle.id
                            way.destinationId = destination.id
                            ways.append(way)
                        }
                    }
                }
            }
            
            //On check si les rotues sont bien
            var counter : Array<Int> = [0, 0, 0, 0, 0, 0, 0, 0, 0]
            for way in ways {
                counter[way.beginId] += 1
            }
            print(counter)
            combinationPossible = true
            for i in counter {
                if i < 2 || i > 2 * players{
                    combinationPossible = false
                }
            }
        }
        
        //Transforming it into a comprehensive map :
        return(castles, ways)
    }
}

class Castle {
    var x : Int!
    var y : Int!
    var id : Int!
}
class Ways {
    var beginId : Int!
    var destinationId : Int!
}
