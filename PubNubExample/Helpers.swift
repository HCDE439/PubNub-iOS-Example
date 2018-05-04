//
//  Helpers.swift
//  PubNubExample
//
//  Created by Blake Tsuzaki on 5/4/18.
//  Copyright © 2018 HCDE439. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
