//
//  DownloadNews.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//

import Foundation

enum DownloadNews {
    case downloadUsers(since: String, per_page: String)
    case downloadSingleUser(username: String)
}

extension DownloadNews: RequestBaseType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com/users")!
    }
    
    var path: String {
        return ""
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    var task: RequestTasks {
        switch self {
        case .downloadUsers(let since, let per_page):
            let params: [String : Any] = [
                "since" : since,
                "per_page" : per_page
            ]
            return .requestParameters(parameters: params)
            
        case .downloadSingleUser(let username):
            let params: [String : Any] = [
                "username" : username,
            ]
            return .requestParameters(parameters: params)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
