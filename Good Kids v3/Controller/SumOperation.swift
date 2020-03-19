//
//  SumOperation.swift
//  Good Kids v3
//
//  Created by Aleksandr Ozhogin on 18/3/20.
//  Copyright © 2020 Aleksandr Ozhogin. All rights reserved.
//

import UIKit

class SumOperation: AsyncOperation {
    let lhs: Int
    let rhs: Int
    var result: Int?
    
    init(lhs: Int, rhs: Int) {
        self.lhs = lhs
        self.rhs = rhs
        super.init()
    }
    override func main() {
        asyncAdd_OpQ(lhs: lhs, rhs: rhs) { result in
            self.result = result
            self.state = .Finished
        }
    }
}
