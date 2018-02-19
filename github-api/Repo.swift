//
//  Repo.swift
//  github-api
//
//  Created by Emiro on 17/2/18.
//  Copyright © 2018 Emiro. All rights reserved.
//

import UIKit

class Repo: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var isFork: Bool
    var stargazers: Int
    var lastTime: String
    var link: String
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let isFork = "isFork"
        static let stargazers = "stargazers"
        static let lastTime = "lastTime"
        static let link = "link"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("repos")
    
    //MARK: Initialization
    init(name: String, isFork: Bool, stargazers: Int, lastTime: String, link: String) {
        //Init properties
        self.name = name
        self.isFork = isFork
        self.stargazers = stargazers
        self.lastTime = lastTime
        self.link = link
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(isFork, forKey: PropertyKey.isFork)
        aCoder.encode(stargazers, forKey: PropertyKey.stargazers)
        aCoder.encode(lastTime, forKey: PropertyKey.lastTime)
        aCoder.encode(link, forKey: PropertyKey.link)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
        let isFork = aDecoder.decodeBool(forKey: PropertyKey.isFork)
        let stargazers = aDecoder.decodeInteger(forKey: PropertyKey.stargazers)
        let lastTime = aDecoder.decodeObject(forKey: PropertyKey.lastTime) as? String
        let link = aDecoder.decodeObject(forKey: PropertyKey.link) as? String
        
        // Must call designated initializer.
        self.init(name: name!, isFork: isFork, stargazers: stargazers, lastTime: lastTime!, link: link!)
        
    }
    
    //MARK: Public Methods
    func getIsForkText() -> String {
        if (self.isFork) {
            return "Yes"
        } else {
            return "No"
        }
    }
}
