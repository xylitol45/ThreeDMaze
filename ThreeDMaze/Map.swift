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
        
        var _nowall:[String]=[]
        //
        let _max = max
        var _x = 1
        var _y = 1
        var _z = 1
        
        var _map:[Field]=[Field](count: _max*_max*_max, repeatedValue: Field())
        var _roads:[Int]=[]
        
        var _xx = 0
        var _yy = 0
        var _zz = 0
        
        let _vecs=[[1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]]
        var _v=0
        var _key = ""
        
        _map[_x+_y*_max+_z*_max*_max].wall = false
        
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
                            
                            println("hit _x:\(_x) _y:\(_y) _z:\(_z) _xx:\(_xx) _yy:\(_yy) _zz:\(_zz)")
                            
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
                    
                    println("x:\(_x) y:\(_y) z:\(_z)")
                    
                    _xyz = _x + (_y * _max) + (_z * _max * _max)
                    _map[_xyz].wall = false
                    
                    _x += _xx
                    _y += _yy
                    _z += _zz
                    println("x:\(_x) y:\(_y) z:\(_z)")
                    _map[_x+(_y*_max)+(_z * _max*_max)].wall = false
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
}