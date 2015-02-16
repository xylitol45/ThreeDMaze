//
//  Player.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/15.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import Foundation

class Player {
    var front:Direction = .N
    var head:Direction = .C
    var x:Int = 3
    var y:Int = 5
    var z:Int = 1
    
    init(front:Direction, head:Direction, x:Int, y:Int, z:Int){
        self.front = front
        self.head = head
        self.x = x
        self.y = y
        self.z = z
    }
    
}