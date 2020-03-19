//
//  AsyncOperation.swift
//  Good Kids v3
//
//  Created by Aleksandr Ozhogin on 18/3/20.
//  Copyright © 2020 Aleksandr Ozhogin. All rights reserved.
//

import UIKit

class AsyncOperation: Operation {
    enum State: String {
        case Ready, Executing, Finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue
        }
    }

    var state = State.Ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    let additionQueue = OperationQueue()
    func asyncAdd_OpQ(lhs: Int, rhs: Int, callback: @escaping (Int) -> ()) {
        additionQueue.addOperation {
            sleep(1) // the delay here should be less than the delay before Playground.current.finishedExecution() kicks in
            callback(lhs + rhs)
        }
    }
}

extension AsyncOperation {
    override var isReady: Bool {
        return super.isReady && state == .Ready
    }

    override var isFinished: Bool {
        return state == .Finished
    }

    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .Finished
            return
        }
        main()
        state = .Executing
    }
    
    override func cancel() {
        state = .Finished
    }
    
    
}
