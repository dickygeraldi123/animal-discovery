//
//  Object+Ext.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import Foundation

extension String {
    func convertToDictionary() -> Any? {
        let data = self.data(using: .utf8)!
        do {
            let output = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return output
        } catch {
            print(error)
        }
        return nil
    }
}
