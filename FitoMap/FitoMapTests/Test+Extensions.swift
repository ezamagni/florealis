//
//  Test+Extensions.swift
//  FitoMapTests
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import Foundation

extension SexagesimalDegree {
    func toDMSList() -> [Int] {
        return [dec, minutes, Int(seconds)]
    }
}
