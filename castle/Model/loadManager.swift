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
    
    //MARK: - Get the brute data
    
    private func getMapsFor(player : Int) -> NSDictionary{
//        let dictionnary = NSDictionary(contentsOf: Bundle.main.url(forResource: "maps", withExtension: ".plist")!)! as! Dictionary<String, NSDictionary>
//        let maps = dictionnary["\(player)playersMaps"]
//        let mapNumber = Int.random(in: 0...maps!.count - 1)
//        return maps![String(mapNumber)]! as! NSDictionary
        
    }
    
    func loadMapFor(player : Int, size : CGSize) {
        
        self.data = MapGenerator.shared.generateMap(players: player)
        
        self.size = size
        //let data = getMapsFor(player: player) as! Dictionary<String, NSDictionary>
        var bases : Array<Base> = []
        for i in data.0 {
            bases.append(getBaseObjectFor(data: i))
        }
        
        var ways : Array<Way> = []
        for i in data["Ways"]!{
            ways.append(getWayObjectFor(data: i.value as! NSDictionary, bases : bases))
        }
        MapData.shared.ways = ways
        MapData.shared.bases = bases
    }
    
    //MARK: - Way
    private func getWayObjectFor(data : NSDictionary, bases : Array<Base>) -> Way{
        for base in bases {
            let beginId = Int(truncating: data["beginId"] as! NSNumber)
            if base.id == beginId{
                let beginPoint = base.position
                let destinationId = Int(truncating: data["destinationId"] as! NSNumber)
                var destinationPoint : CGPoint = CGPoint(x: 0, y: 0)
                for i in bases {
                    if i.id == destinationId {
                        destinationPoint = i.position
                    }
                }
                let x = (beginPoint.x - destinationPoint.x) / 2 + destinationPoint.x
                let y = (beginPoint.y - destinationPoint.y) / 2 + destinationPoint.y
                
                let endPoint = CGPoint(x: x, y: y)
            
                let team = base.team
                let way = Way(beginPoint: beginPoint, endPoint: endPoint, destinationPoint: destinationPoint, destinationId: destinationId, beginId : beginId, wayTeam: team!)
                return way
            }
        }
        return Way(beginPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 0), destinationPoint: CGPoint(x: 0, y: 0), destinationId: 0, beginId: 0, wayTeam: .neutral)
    }
    
    //MARK: - Base
    private func getBaseObjectFor(data : Array<Castle>) -> Base{
        let team = getTeam(teamColor: data["team"] as! String)
        let position = posFor(x: CGFloat(truncating: data["posX"] as! NSNumber), y: CGFloat(truncating: data["posY"] as! NSNumber))
        let id = Int(truncating: data["Id"] as! NSNumber)
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

