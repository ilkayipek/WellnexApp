//
//  CompleteTaskInstanceDelegate.swift
//  WellnexApp
//
//  Created by MacBook on 21.05.2025.
//

protocol CompleteTaskInstanceDelegate: AnyObject {
    func taskInstanceComleted(_ newIntance: TaskInstanceModel, index: Int)
}
