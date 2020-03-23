//
//  Game.swift
//  castle
//
//  Created by Titouan Blossier on 22/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import SpriteKit
import UIKit

class Game {
    private var ways : Array<Way> {
        get {
            return MapData.shared.ways
        }
        set {
            MapData.shared.ways = newValue
        }
    }
    private var bases : Array<Base> {
        get {
            return MapData.shared.bases
        }
    }
    
    func second() {
        increasePoid()
    }
    
    private func increasePoid() {
        for base in bases{
            if base.poid != ChateauSize.maxSize && base.team != .neutral{
                base.poid += 1
            }
        }
    }
    
    func sendUnit(beginId : Int, way : Way) -> (Bool , Int, CGPoint){ //Return if possible and the poid and the position
        
        let poid = base(id: beginId).poid
        var unitPoid = 0
        if poid == 1 || poid == 2 || base(id: beginId).team == .neutral{
            return (false, 0, CGPoint(x: 0, y: 0))
        }else {
            unitPoid = Int(round(Float(poid!) / 2))
        }
        
        //Updating Data
        base(id : beginId).poid -= unitPoid
        return(true, unitPoid, way.destinationPoint)
    }
    
    func unitArrived(beginId : Int, unit : Unit, destinationId : Int) -> (Bool, Teams){
        for base in bases {
            if base.id == destinationId {
                if base.team == unit.team { //La base etait a un joueur qui a envoyé des renforts dessus
                    base.poid += unit.poid
                    if base.poid > ChateauSize.maxSize {
                        base.poid = ChateauSize.maxSize
                    }
                } else {
                    base.poid -= unit.poid
                    if base.poid < 0 { //La base etait a un joueur ou neutre et un autre joueur l'a capture
                        base.team = unit.team
                        base.poid *= -1
                        base.poid += 1
                    } else if base.poid == 0 {
                        base.team = unit.team
                        base.poid = 1
                    }
                    for i in 0...ways.count - 1{
                        if ways[i].beginId == base.id {
                            ways[i].wayTeam = base.team
                        }
                    }
                }
                return checkWin()
            }
        }
        return(false, .neutral)
    }
    
    func base(id : Int) -> Base {
        for i in bases {
            if i.id == id {
                return i
            }
        }
        return Base() //Never happen
    }
    
    private func checkWin() -> (Bool, Teams) {
        var team : Teams!
        for i in bases {
            if i.team != .neutral && team == nil {
                team = i.team
            } else if i.team != team && i.team != .neutral{
                return (false, .neutral)
            }
        }
        return (true, team)
    }
}
