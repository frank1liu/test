//
//  CommunicatorResponse.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//

import Foundation

struct CommunicatorResponse {
    
    let statusCode: Int
    
    let data: Data
    
    let request: URLRequest?
    
    let response: HTTPURLResponse?
    
    init(statusCode: Int, data: Data, request: URLRequest? = nil, response: HTTPURLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.response = response
    }
}
