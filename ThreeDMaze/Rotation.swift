//
//  Rotation.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/11.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import Foundation

enum Rotation {
    case RIGHT
    case LEFT
    case UP
    case DOWN
    
    func toInt()->Int {
        switch self {
        case .RIGHT: return 0;
        case .LEFT: return 1;
        case .UP: return 2;
        case .DOWN: return 3;
        }
    }
}
