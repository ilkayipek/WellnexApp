//
//  HourSelectsionsDelegate.swift
//  WellnexApp
//
//  Created by MacBook on 17.05.2025.
//

protocol HourSelectsionsDelegate: AnyObject{
    func updateHourSelectedIndexes(dayIndex:Int,hourSelectedIndexes: [Int])
}
