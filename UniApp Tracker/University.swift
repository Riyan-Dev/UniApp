//
//  Universities.swift
//  CS IA
//
//  Created by Muhammad Riyan on 24/06/2020.
//  Copyright © 2020 Muhammad Riyan. All rights reserved.
//

import Foundation

struct University: Codable, Identifiable, Hashable {
    let id: Int
    let universityName: String
    let SATReq: Int
    let tuition: String
    let website: String
    
    var image: String {
        "image\(id)"
    }
    var logo: String {
        "logo\(id)"
    }
}
