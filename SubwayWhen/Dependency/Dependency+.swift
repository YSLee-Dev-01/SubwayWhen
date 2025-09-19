//
//  Dependency+.swift
//  SubwayWhenNetworking
//
//  Created by 이윤수 on 9/20/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var totalLoad: TotalLoadTCADependencyProtocol {
        get {self[TotalLoadModelDependencyKey.self]}
        set {self[TotalLoadModelDependencyKey.self] = newValue}
    }
    
    var locationManager: LocationManagerProtocol {
        get{self[LocationManagerTCADependencyKey.self]}
        set{self[LocationManagerTCADependencyKey.self] = newValue}
    }
    
    var notificationManager: NotificationManagerProtocol {
        get{self[NotificationTCADependencyKey.self]}
        set{self[NotificationTCADependencyKey.self] = newValue}
    }
}
