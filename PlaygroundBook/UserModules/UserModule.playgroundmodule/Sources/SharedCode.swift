/*
 See the Introduction Page for an overview over my submission.
 */

import Foundation

enum E : Error {
    case generic(String)
}

extension Data {
    
    func asString() -> String {
        self.compactMap { String(format: "%02x", $0) }.joined()
    }
    
}
