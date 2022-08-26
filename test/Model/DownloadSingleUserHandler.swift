//
//  DownloadSingleUserHandler.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//

import Foundation

/// A custom model conform protocol DownloadModelProtocol
struct DownloadSingleUserHandler: Convertible, DownloadModelProtocol {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
    let name:String
    let company:String
    let blog:String
    let location:String
    let email:String
    let hireable:String
    let bio:String
    let twitter_username:String
    let public_repos:Int
    let public_gists:Int
    let followers:Int
    let following:Int
    let created_at:String
    let updated_at:String

    // protocol properties
    var index: Int
    var indexPath: IndexPath
    var downloaded: Bool
    
    static func updateSearcSingleUserhResults(_ data: Data, section: Int) -> [DownloadSingleUserHandler]? {

        var errorMessage: String = ""
        var users: [DownloadSingleUserHandler] = []
        var trackDictionary: [String : Any] = [:]
        
        do {
            trackDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            
        } catch let parseError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return nil
        }
        
        var index = 0
        
        if  let login = trackDictionary["login"] as? String,
            let id = trackDictionary["id"] as? Int,
            let node_id = trackDictionary["node_id"] as? String,
            let avatar_url = trackDictionary["avatar_url"] as? String,
            let gravatar_id = trackDictionary["gravatar_id"] as? String,
            let url = trackDictionary["url"] as? String,
            let html_url = trackDictionary["html_url"] as? String,
            let followers_url = trackDictionary["followers_url"] as? String,
            let following_url = trackDictionary["following_url"] as? String,
            let gists_url = trackDictionary["gists_url"] as? String,
            let starred_url = trackDictionary["starred_url"] as? String,
            let subscriptions_url = trackDictionary["subscriptions_url"] as? String,
            let organizations_url = trackDictionary["organizations_url"] as? String,
            let repos_url = trackDictionary["repos_url"] as? String,
            let events_url = trackDictionary["events_url"] as? String,
            let received_events_url = trackDictionary["received_events_url"] as? String,
            let type = trackDictionary["type"] as? String,
            let site_admin = trackDictionary["site_admin"] as? Bool,
            
            let name = trackDictionary["name"] as? String,
            let public_repos = trackDictionary["public_repos"] as? Int,
            let public_gists = trackDictionary["public_gists"] as? Int,
            let followers = trackDictionary["followers"] as? Int,
            let following = trackDictionary["following"] as? Int,
            let created_at = trackDictionary["created_at"] as? String,
            let updated_at = trackDictionary["updated_at"] as? String {
            
            let indexPath = IndexPath(item: index, section: section)
            
            users.append(DownloadSingleUserHandler(login: login, id: id, node_id: node_id, avatar_url: avatar_url, gravatar_id: gravatar_id, url: url, html_url: html_url, followers_url: followers_url, following_url: following_url, gists_url: gists_url, starred_url: starred_url, subscriptions_url: subscriptions_url, organizations_url: organizations_url, repos_url: repos_url, events_url: events_url, received_events_url: received_events_url, type: type, site_admin: site_admin, name: name, company: trackDictionary["company"] as? String ?? "", blog: trackDictionary["blog"] as? String ?? "", location: trackDictionary["location"] as? String ?? "", email: trackDictionary["email"] as? String ?? "", hireable: trackDictionary["hireable"] as? String ?? "", bio: trackDictionary["bio"] as? String ?? "", twitter_username: trackDictionary["twitter_username"] as? String ?? "", public_repos: public_repos, public_gists: public_gists, followers: followers, following: following, created_at: created_at, updated_at: updated_at, index: index, indexPath: indexPath, downloaded: false))
            
            index += 1
        } else {
            errorMessage += "Problem parsing trackDictionary\n"
        }
    
        return users
    }
}

