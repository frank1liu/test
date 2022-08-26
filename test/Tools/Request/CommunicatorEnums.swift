//
//  CommunicatorEnums.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//


import Foundation

enum NetworkError: Error {
    case errorMessage(String, response: CommunicatorResponse?)
    
    init(message: String, response: CommunicatorResponse?) {
        self = .errorMessage(message, response: response)
    }
}

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

