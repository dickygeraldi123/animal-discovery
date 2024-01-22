//
//  Object+Ext.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import Foundation
import SystemConfiguration

func Dlog(_ message: String,
          function: String = #function,
          file: String = #file,
          line: Int = #line,
          column: Int = #column) {
    #if DEBUG
    let string = "\n====================================================\nfile: \(file)\nfunction: \(function)\nline: \(line)\ncolumn: \(column)\nMESSAGE: \(message)\n\n\n"
    print("\(string)")
    #else
    #endif
}

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

extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
