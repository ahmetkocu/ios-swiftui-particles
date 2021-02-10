//
//  File.swift
//  
//
//  Created by helloworld on 10.02.2021.
//

import Foundation

public struct Particle {
    var radius: Float
    var x: Float
    var y: Float
    var vx: Int
    var vy: Int
    var alpha: Float
}

extension Particle : Hashable {
    public static func == (lhs: Particle, rhs: Particle) -> Bool {
        return lhs.x == rhs.x
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
    }
}
