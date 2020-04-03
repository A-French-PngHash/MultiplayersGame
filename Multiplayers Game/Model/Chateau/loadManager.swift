//
//  loadManager.swift
//  castle
//
//  Created by Titouan Blossier on 06/02/2020.
//  Copyright © 2020 Titouan Blossier. All rights reserved.
//
import UIKit
import Foundation

class LoadManager {
    static let shared = LoadManager()
    private init() { }
    
    var data : (Array<Castle>, Array<Ways>)!
    var size : CGSize!
    
    func loadMapFor(player : Int, size : CGSize, team : Array<Teams>) {
        
        self.data = MapGenerator.shared.generateMap(players: player, team : team)
        self.size = size
        
        var bases : Array<Base> = []
        for i in data.0 {
            bases.append(getBaseObjectFor(data: i))
        }
        
        var ways : Array<Way> = []
        for i in data.1{
            ways.append(getWayObjectFor(data: i, bases : bases))
        }
        MapData.shared.ways = ways
        MapData.shared.bases = bases
    }
    
    //MARK: - Way
    private func getWayObjectFor(data : Ways, bases : Array<Base>) -> Way{
        for base in bases {
            let beginId = data.beginId
            if base.id == beginId{
                let beginPoint = base.position
                let destinationId = data.destinationId
                var destinationPoint : CGPoint = CGPoint(x: 0, y: 0)
                for i in bases {
                    if i.id == destinationId {
                        destinationPoint = i.position
                    }
                }
                let x = (beginPoint.x - destinationPoint.x ) / 2 + destinationPoint.x
                let y = (beginPoint.y - destinationPoint.y ) / 2 + destinationPoint.y
                
                let endPoint = CGPoint(x: x, y: y)
            
                let team = base.team
                let way = Way(beginPoint: beginPoint, endPoint: endPoint, destinationPoint: destinationPoint, destinationId: destinationId!, beginId : beginId!, wayTeam: team!, angle : 0)
                return way
            }
        }
        return Way(beginPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 0), destinationPoint: CGPoint(x: 0, y: 0), destinationId: 0, beginId: 0, wayTeam: .neutral, angle : 0)
    }
    
    //MARK: - Base
    private func getBaseObjectFor(data : Castle) -> Base{
        let team = data.team
        let position = posFor(x: CGFloat(Double(data.x) / 1000), y: CGFloat(Double(data.y) / 1000))
        let id = data.id
        let base = Base()
        base.position = position
        base.id = id
        base.team = team
        return base
    }
    
    
    //MARK: - Tool functions
    private func getTeam(teamColor : String) -> Teams {
        var team : Teams = .orange
        if teamColor == "green" {
            team = .green
        } else if teamColor == "blue" {
            team = .blue
        } else if teamColor == "yellow" {
            team = .yellow
        } else if teamColor == "neutral" {
            team = .neutral
        }
        return team
    }
    
    private func posFor(x : CGFloat, y : CGFloat) -> CGPoint{
        return CGPoint(x: x * size.width, y: size.height - (y * size.height))
    }
}

