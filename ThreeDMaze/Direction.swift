//
//  Direction.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/11.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import Foundation

enum Direction {
    case N
    case S
    case E
    case W
    case C
    case F
    
    func toString()->String {
        switch self {
        case .N:
            return "N";
        case .W:
            return "W";
        case .S:
            return "S";
        case .E:
            return "E";
        case .C:
            return "C";
        case .F:
            return "F";
        }
        
    }
    
    func toValue()->Int {
        let _xyz = self.xyz()
        return _xyz[0]+_xyz[1]+_xyz[2]
    }

    
    func opposite()->Direction {
        switch self {
        case .N: return .S;
        case .W: return .E;
        case .S: return .N;
        case .E: return .W;
        case .C: return .F;
        case .F: return .C;
        }
    }
    
    func right(head:Direction)->Direction {
        
        switch self {
        case .N:
            switch head {
            case .C: return .E;
            case .F: return .W;
            case .E: return .F;
            case .W: return .C;
            default:break;
            }
        case .S:
            switch head {
            case .C: return .W;
            case .F: return .E;
            case .E: return .C;
            case .W: return .F;
            default:break;
            }
        case .E:
            switch head {
            case .C: return .S;
            case .F: return .N;
            case .N: return .C;
            case .S: return .F;
            default:break;
            }
        case .W:
            switch head {
            case .C: return .N;
            case .F: return .S;
            case .N: return .F;
            case .S: return .C;
            default:break;
            }
        case .C:
            switch head {
            case .N: return .W;
            case .S: return .E;
            case .E: return .N;
            case .W: return .S;
            default:break;
            }
        case .F:
            switch head {
            case .N: return .E;
            case .S: return .W;
            case .E: return .S;
            case .W: return .N;
            default:break;
            }
        default:break;
            
        }
        
        return .C
        
    }
    
    func rotate(head:Direction, rotation:Rotation)->[Direction] {
        
        var _res = [self,head]
        var _front = self
        var _head = head
        
        if rotation == .UP {
            let _opp = _front.opposite()
            _front = _head
            _head = _opp
        } else if rotation == .DOWN {
            let _opp = _head.opposite()
            _head = _front
            _front = _opp
        } else if rotation == .RIGHT {
            _front =  _front.right(_head)
        } else if rotation == .LEFT {
            _front = _front.right(_head)
            _front = _front.opposite()
        }
        return [_front, _head]
    }
    
    
    func xyz()->[Int] {
        switch self {
        case .N:
            return [0,1,0];
        case .S:
            return [0,-1,0];
        case .E:
            return [1,0,0];
        case .W:
            return [-1,0,0];
        case .C:
            return [0,0,1];
        case .F:
            return [0,0,-1];
        }
    }
    
    func calcXyz(head:Direction, x:Int, y:Int, z:Int, xx:Int, yy:Int, zz:Int)->[Int] {
        
        var _xyz:[Int] = [xx,yy,zz]
        
        switch self {
        case .N:
            switch head {
            case .C:_xyz = [xx,yy,zz] //
            case .F:_xyz=[(-1*xx), yy,(-1*zz)]
            case .E:_xyz=[zz,yy, (-1 * xx)]
            case .W:_xyz = [(-1 * zz),yy, xx]
            default:break;
            }
        case .S:
            switch head {
            case .C:_xyz=[(-1*xx),(-1*yy),zz] //
            case .F:_xyz=[xx, (-1*yy),(-1*zz)] //
            case .E:_xyz=[zz,(-1*yy),xx]
            case .W:_xyz=[(-1*zz), (-1*yy),(-1*xx)]
            default:break;
            }
        case .E:
            switch head {
            case .C:_xyz=[(yy),(-1*xx),zz] //
            case .F:_xyz=[yy, xx, (-1*zz)]
                
            case .N:_xyz=[yy, zz, xx]
            case .S:_xyz=[yy, (-1*zz), (-1 * xx)]
                
            default:break;
            }
        case .W:
            switch head {
            case .C:_xyz=[(-1*yy),(xx),zz] //
            case .F:_xyz=[(-1*yy),(-1*xx),(-1*zz)]
            case .N:_xyz=[(-1*yy),zz,(-1*xx)]
            case .S:_xyz=[(-1*yy),(-1*zz),(xx)]
            default:break;
            }
        case .C:
            switch head {
            case .N:_xyz=[ (-1*xx), zz, (yy)]
            case .S:_xyz=[ (xx), (-1*zz), (yy)] //
            case .E:_xyz=[ zz, (xx), yy] //
            case .W:_xyz=[ (-1*zz), (-1*xx), yy] //
            default:break;
            }
        case .F:
            switch head {
            case .N:_xyz=[ (xx), (-1*zz), (-1*yy)] //
            case .S:_xyz=[ (-1*xx),      (-1*zz), (-1*yy)]
            case .E:_xyz=[ (zz),  (-1*xx), (yy)]
            case .W:_xyz=[ (-1*zz), (xx), (-1*yy)]
            default:break;
            }
            break;
        default:break;
        }
        
        return [_xyz[0]+x, _xyz[1]+y, _xyz[2]+z]
    }
    
    
}
