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
            for i in 0...players * 2{ //Génération des emplacements
                let castle = Castle()
                var possible = false
                while possible == false {
                    castle.x = Int.random(in: 100...900)
                    castle.y = Int.random(in: 100...900)
                    if castles.count != 0 {
                        possible = true
                        for i in castles {
                            let xDistance = (castle.x - i.x) * (castle.x - i.x)
                            let yDistance = (castle.y - i.y) * (castle.y - i.y)
                            let distance = round(sqrt(Double(xDistance) + Double(yDistance)))
                            var max = 300
                            if players == 4 {
                                max = 250
                            } else if players == 3 {
                                max = 280
                            }
                            if distance < Double(max){
                                possible = false
                            }
                        }
                    } else {
                        possible = true
                    }
                }
                castle.id = i
                castle.team = .neutral
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
            
            //On check si les routes sont bien
            var counter : Array<Int> = []
            for _ in 0...castles.count - 1 {
                counter.append(0)
            }
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
            
            if combinationPossible {//Pour eviter que la map ne soit un rond
                var stayTwo = true
                for i in counter {
                    if i != 2 {
                        stayTwo = false
                    }
                }
                if stayTwo {
                    combinationPossible = false
                }
            }
        }
        
        //Transforming it into a comprehensive map :
        
        let teams : Array<Teams> = [.green, .yellow, .orange, .blue]
        for i in 0...players - 1 {
            castles[i].team = teams[i]
        }
        return(castles, ways)
    }
}

class Castle {
    var x : Int!
    var y : Int!
    var id : Int!
    var team : Teams!
}
class Ways {
    var beginId : Int!
    var destinationId : Int!
}
