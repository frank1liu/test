//
//  ConvertableProtocol.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//

import Foundation

protocol Convertible: Codable { }
extension Convertible {
    func convertToDic() -> [String : Any]? {
        var dic: [String : Any]?
        
        do {
            let data = try JSONEncoder().encode(self)
            dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
            
        } catch let error {

        }
        
        return dic
    }
    
    static func convertToModel(dic: [String : Any]) -> Self? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: [])
            let decoder = JSONDecoder()
            let model = try decoder.decode(Self.self, from: data)
            
            return model
            
        } catch _ {

            return nil
        }
    }
    
}
