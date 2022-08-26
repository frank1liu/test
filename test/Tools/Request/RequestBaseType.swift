//
//  RequestBaseType.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//

import Foundation

public protocol RequestBaseType {
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: RequestMethod { get }
    
    var sampleData: Data { get }
    
    var task: RequestTasks { get }

    var headers: [String: String]? { get }
}
