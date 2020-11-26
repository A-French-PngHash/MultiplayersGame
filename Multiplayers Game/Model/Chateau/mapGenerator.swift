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
    
    func generateMap(players : Int, team : Array<Teams>) -> (Array<Castle>, Array<Ways>){
        var combinationPossible = false
        var castles : Array<Castle> = []
        var ways : Array<Ways> = []
        var compteur = 0
        while combinationPossible == false {
            compteur += 1
            castles = []
            ways = []
            var restart = false //Security break
            var numberOfChateau = 6
            if players == 3 {
                numberOfChateau = 7
            } else if players == 4 {
                numberOfChateau = 8
            }
            for i in 0...numberOfChateau - 1{ //Génération des emplacements
                let castle = Castle()
                var possible = false
                var count = 0 //Security break
                while possible == false {
                    count += 1
                    castle.x = Int.random(in: 100...900)
                    castle.y = Int.random(in: 100...900)
                    if castles.count != 0 {
                        possible = true
                        for i in castles {
                            let xDistance = (castle.x - i.x) * (castle.x - i.x)
                            let yDistance = (castle.y - i.y) * (castle.y - i.y)
                            let distance = round(sqrt(Double(xDistance) + Double(yDistance)))
                            var max = 310
                            if players == 2 {
                                max = 380
                            } else if players == 3{
                                max = 335
                            }
                            
                            
                            if distance < Double(max){
                                possible = false
                            }
                            if count == 100 {
                                restart = true
                                possible = true
                                break
                            }
                        }
                    } else {
                        possible = true
                    }
                }
                if restart {
                    break
                } else {
                    castle.id = i
                    castle.team = .neutral
                    castles.append(castle)
                }
            }
            
            if restart == false { //Security break
                //On connecte les chateaux
                for castle in castles {
                    for destination in castles {
                        if destination.id != castle.id {
                            let xDistance = (castle.x - destination.x) * (castle.x - destination.x)
                            let yDistance = (castle.y - destination.y) * (castle.y - destination.y)
                            let distance = round(sqrt(Double(xDistance) + Double(yDistance)))
                            var max = 600
                            if players == 3 {
                                max = 450
                            } else if players == 4{
                                max = 400
                            }
                            if distance < Double(max) { //On peut créer une route
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
                combinationPossible = true
                for i in counter {
                    if i < 2 || i > 2 * players{
                        combinationPossible = false
                        break
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
                    for i in 0...players - 1 {
                        castles[i].team = team[i]
                    }
                    return(castles, ways)
                }
            } else { //End of security break. On restart la boucle
                combinationPossible = false
            }
        }
        return([Castle](), [Ways]())
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
