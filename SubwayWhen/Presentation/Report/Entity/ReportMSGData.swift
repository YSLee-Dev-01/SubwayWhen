//
//  ReportMSGData.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2023/02/21.
//

import Foundation

struct ReportMSGData : Equatable{
    var selectedLine: SubwayLineData
    var nowStation : String
    var destination : String
    var trainCar : String
    var contants : String
    var brand : String
    
    init(selectedLine: SubwayLineData = .not, nowStation: String = "", destination: String = "", trainCar: String = "", contants: String = "", brand: String = "") {
        self.selectedLine = selectedLine
        self.selectedLine = selectedLine
        self.nowStation = nowStation
        self.destination = destination
        self.trainCar = trainCar
        self.contants = contants
        self.brand = brand
    }
}
