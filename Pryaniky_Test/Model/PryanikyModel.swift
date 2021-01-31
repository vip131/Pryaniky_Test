//
//  Model.swift
//  Pryaniky_Test
//
//  Created by Admin on 29.01.2021.
//  Copyright © 2021 DmitryChaschin. All rights reserved.
//

import Foundation

struct PryanikyModel {
    
    struct Objects {
        struct Text {
            let name: String
            let text: String
        }
        
        struct picture {
            let name: String
            let url: String
            let text: Text
        }
        
        struct Selector {
            let name: String
            let variant: Int
            
        }
    }
    
    
    let view : [String]
    let data:[Objects]
}
