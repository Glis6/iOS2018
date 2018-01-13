//
//  DrawingService.swift
//  DrawingApp
//
//  Created by Gilles Vercammen on 1/3/18.
//  Copyright © 2018 Gilles Vercammen. All rights reserved.
//

protocol DrawingService {
    func getAll(completion: @escaping ([Drawing]?) -> Void)
    
    func save(_ drawing: Drawing, completion: @escaping () -> Void)
}
