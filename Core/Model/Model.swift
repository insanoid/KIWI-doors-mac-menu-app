//
//  Model.swift
//  KIWI
//
//  Created by Karthik on 09/12/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Foundation
import Marshal


/// Generic protocol for all models to follow.
public protocol Model: Unmarshaling {
    init(object: MarshaledObject)
}
