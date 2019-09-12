//
//  Counter.swift
//  Project1
//
//  Created by Adrimi on 08/08/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//


import UIKit

class Counter: Codable {
    var counter: Int 
    init(counter: Int = 0) {
        self.counter = counter
    }
}
