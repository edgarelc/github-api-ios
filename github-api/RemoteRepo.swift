//
//  RestAPI.swift
//  github-api
//
//  Created by Emiro on 17/2/18.
//  Copyright © 2018 Emiro. All rights reserved.
//

import UIKit
import Alamofire

class RemoteRepo {
    func get(completion: @escaping ([Repo]?) -> Void){
        //Default is get so no need to define method
        Alamofire.request("https://api.github.com/users/Shopify/repos").responseJSON { response in
            //Make sure tags are valide
            guard let json = response.result.value as? [[String: Any]] else {
                print("Invalid tag information received from the service")
                completion([Repo]())
                return
            }
            
            //Map data to build Repos
            let remoteRepos = json.flatMap({ (remoteRepoDict) -> Repo in
                let name = remoteRepoDict["name"] as? String
                let isFork = remoteRepoDict["fork"] as? Bool
                let stargazers = remoteRepoDict["stargazers_count"] as? Int
                let lastTime = remoteRepoDict["updated_at"] as? String
                let link = remoteRepoDict["url"] as? String
                
                return Repo(name: name!, isFork: isFork!, stargazers: stargazers!, lastTime: lastTime!, link: link!)
            })
        
            //Call completion function as this is done asynchronously
            completion(remoteRepos)
        }
    }
}
