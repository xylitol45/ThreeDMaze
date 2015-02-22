//
//  Map.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/13.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import Foundation

class Map {
    
    class func create(max:Int)->[Field] {
        
        // var _nowall:[String]=[]
        //
        let _max = max
        var _x = 1
        var _y = 1
        var _z = 1
        
        var _map:[Field]=[Field]()
        
        for _ in 0..<_max*_max*_max {
            _map += [Field()]
        }
        var _roads:[Int]=[]
        
        var _xx = 0
        var _yy = 0
        var _zz = 0
        
        let _vecs=[[1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]]
        var _v=0
        var _key = ""
        
//        for _f in _map {
//            println(_f.wall ? "ttt" : "fff")
//        }

        
        _map[_x+_y*_max+_z*_max*_max].wall = false
        
//        for _f in _map {
//            println(_f.wall ? "ttt" : "fff")
//        }
        
        
        while(true) {
            while(true) {
                var _flg=false
                _v = Int(arc4random_uniform(UInt32(_vecs.count)))
                for i in 0..<_vecs.count {
                    
                    _xx = _vecs[(_v+i) % 6][0]
                    _yy = _vecs[(_v+i) % 6][1]
                    _zz = _vecs[(_v+i) % 6][2]
                    
                    if ((!(_xx < 0 && _x < 3)) &&  (!(_xx > 0 && _x > (_max-4)))
                        && (!(_yy < 0 && _y < 3)) && (!(_yy > 0 && _y > (_max-4)))
                        && (!(_zz < 0 && _z < 3)) && (!(_zz > 0 && _z > (_max-4)))
                        ) {
                            
//                        println("hit _x:\(_x) _y:\(_y) _z:\(_z) _xx:\(_xx) _yy:\(_yy) _zz:\(_zz)")
                            
                        var _n = _map[(_x+_xx*2)+(_y+_yy*2)*_max+(_z+_zz*2)*_max*_max]
                            // var _key1 = "w\(_x+_xx*2+(_y+_yy*2)*_max)"
                            //                    var _key2 = "w\(_x+_xx*1+(_y+_yy*1)*16)"
                        if _n.wall == true {
                            _flg=true
                            break
                        }
                    }
                    
                }
                
                
                if (_flg) {
                    
                    var _xyz = 0
                    
                    _x += _xx
                    _y += _yy
                    _z += _zz
                    
//                    println("x:\(_x) y:\(_y) z:\(_z)")
                    
                    _xyz = _x + (_y * _max) + (_z * _max * _max)
                    _map[_xyz].wall = false
                    _map[_xyz].coin = true
                    
                    _x += _xx
                    _y += _yy
                    _z += _zz
                    println("x:\(_x) y:\(_y) z:\(_z)")
                    _map[_x+(_y*_max)+(_z * _max*_max)].wall = false
                    _map[_x+(_y*_max)+(_z * _max*_max)].coin = true
                    _roads += [_x+_y * _max + _z*_max*_max]
                    continue
                }
                
                break
            }
            
            if _roads.count == 0 {
                break
            }
            
            var _road = _roads[0]
            _roads.removeAtIndex(0)
            
            // x,y,z
            _x = _road % _max
            _y = ((_road - _x) % (_max*_max)) / _max
            _z = (_road - _x - _y * _max) / (_max*_max)
            
            println("road:\(_road) x:\(_x) y:\(_y) z:\(_z)")
            
        }

        return _map
    }
    
    class func getField(x:Int, y:Int, z:Int, map:[Field], max:Int)->Field {
        
        if (x < 0 || x >= max || y < 0 || y >= max || z < 0 || z >= max) {
            return Field()
        }
        
        let _n = x + y * max + z * max * max;
        if ( _n < 0 || _n >= map.count) {
            return Field()
        }
        return map[_n]
    }
    
    
}