//
//  Utilities.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/28/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import Foundation

class Utilities: NSObject {
    
    static let shared = Utilities()
    
    func notFirstTime() -> Bool {
        let notFirstTimeProp = UserDefaults.standard.bool(forKey: appKeys.notFirstTimeKey)
        return notFirstTimeProp
    }
    
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$")
        // Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:
        
        return passwordTest.evaluate(with: password)
    }
    
}
