//
//  Card.swift
//  Animated Set
//
//  Created by Abdalla Elsaman on 7/18/19.
//  Copyright © 2019 Dumbies. All rights reserved.
//

import Foundation

struct Card {
    
    init(color: Varient, kind: Varient, count: Varient, shadding: Varient) {
        self.varient1 = color
        self.varient2 = kind
        self.varient3 = count
        self.varient4 = shadding
    }
    
    enum Varient: Int {
        case one = 1, two, three
    }
    
    // Indentifiers
    
    let varient1: Varient
    let varient2: Varient
    let varient3: Varient
    let varient4: Varient
    
    
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (
            (lhs.varient1 == rhs.varient1) &&
                (lhs.varient2 == rhs.varient2) &&
                (lhs.varient3 == rhs.varient3) &&
                (lhs.varient4 == rhs.varient4)
        )
    }
    
}
