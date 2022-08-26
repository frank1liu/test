//
//  RequestCommunicator.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//


import Foundation

class RequestCommunicator<requestBaseTypeT: RequestBaseType>: NSObject {

    typealias RequestCompletionHandler = (Result<CommunicatorResponse, NetworkError>) -> Void
        
    public func request(type: requestBaseTypeT, completionHandler: @escaping RequestCompletionHandler) {
        switch type.task {
        case .requestParameters(let parameters):
            if parameters.count != 1 {
                requestWithURL(type, parameters: parameters, completion: completionHandler)
            }
            else {
                requestWithURL2(type, parameters: parameters, completion: completionHandler)
            }
        }
    }
    
    // ================request functions=====================
    /// normal request with callback
    private func fetchedDataByDataTask(from request: URLRequest, target: requestBaseTypeT, completion:  @escaping RequestCompletionHandler) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let result = self.convertToResult(response: response as? HTTPURLResponse, data: data, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    
    // MARK: - reqeust with query string of parameters.
    private func requestWithURL(_ target: requestBaseTypeT, parameters: [String: Any], completion: @escaping RequestCompletionHandler) {
        let url = URL(target: target)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
       
        urlComponents.queryItems = []
        
        for (key, value) in parameters {
            guard let value = value as? String else { return }
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        guard let queryedURL = urlComponents.url else { return }
        
        var request = URLRequest(url: queryedURL)
        
        request.httpMethod = target.method.rawValue
        if request.allHTTPHeaderFields?["Content-Type"] == nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        fetchedDataByDataTask(from: request, target: target, completion: completion)
    }
    
    private func requestWithURL2(_ target: requestBaseTypeT, parameters: [String: Any], completion: @escaping RequestCompletionHandler) {
        let url = URL(target: target)
        
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        guard let queryedURL = urlComponents.url else { return }
        
        var urlString = queryedURL.absoluteString
        urlString = urlString + "/" + (parameters["username"] as! String)
        
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = target.method.rawValue
        if request.allHTTPHeaderFields?["Content-Type"] == nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        fetchedDataByDataTask(from: request, target: target, completion: completion)
    }
    
    // handle response
    private func convertToResult(response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<CommunicatorResponse, NetworkError> {
        
        var prettyString = ""
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data ?? "{ dataEmpty : 'empty' }".data(using: .utf8)!, options: .allowFragments)
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            prettyString = String(data: jsonData, encoding: .utf8) ?? ""
        
        } catch let error {
            prettyString = error.localizedDescription
        }
                
        switch (response, data, error) {
        case let (.some(response), data, .none) :
            let newResponse = CommunicatorResponse(statusCode: response.statusCode, data: data ?? Data())
            return .success(newResponse)
            
        case let (.some(response), _ , .some(error)):
            let result = CommunicatorResponse(statusCode: response.statusCode, data: data ?? Data())
            let error = NetworkError(message: error.localizedDescription, response: result)
            return .failure(error)
            
        case let (_, _ , .some(error)):
            let error = NetworkError(message: error.localizedDescription, response: nil)
            return .failure(error)
            
        default:
            let error = NetworkError(message: NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil).localizedDescription, response: nil)
            return .failure(error)
        }
    }
}

// URL extension
public extension URL {
    init<T: RequestBaseType>(target: T) {
        if target.path.isEmpty {
            self = target.baseURL
        } else {
            self = target.baseURL.appendingPathComponent(target.path)
        }
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: false)
        append(data!)
    }
}
