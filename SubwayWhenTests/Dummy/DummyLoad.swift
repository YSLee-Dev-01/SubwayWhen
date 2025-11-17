//
//  DummyLoad.swift
//  SubwayWhenTests
//
//  Created by 이윤수 on 2023/03/01.
//

import Foundation

@testable import SubwayWhen

let arrivalData = DummyLoad().fileLoad("StationArrivalRequestDummy.json")
let arrivalErrorData = DummyLoad().fileLoad("StationArrivalRequestErrorDummy.json")
let seoulStationSchduleData = DummyLoad().fileLoad("SeoulStationScheduleDummy.json")
let korailStationSchduleData = DummyLoad().fileLoad("KorailStationScheduleDummy.json")
let stationNameSearchData = DummyLoad().fileLoad("StationNameSearchDummy.json")
let vicinityData = DummyLoad().fileLoad("KakaoLocationAPIDummy.json")
let shinbundangSinsaStationData = DummyLoad().fileLoad("ShinbundangSinsaStationScheduleDummy.json")
let subwayNoticeData = DummyLoad().fileLoad("SubwayNoticeDummy.json")
let subwayNoticeInfiniteData = DummyLoad().fileLoad("SubwayNoticeDummyInfiniteDate.json")

let arrivalDummyData = try! JSONDecoder().decode(LiveStationModel.self, from: arrivalData)
let seoulScheduleDummyData = try! JSONDecoder().decode(ScheduleStationModel.self, from: seoulStationSchduleData)
var korailScheduleDummyData : [KorailScdule] = {
    let json = try! JSONDecoder().decode(KorailHeader.self, from: korailStationSchduleData)
    
    let dummySort = json.body.sorted{
        Int($0.time ?? "0") ?? 0 < Int($1.time ?? "1") ?? 1
    }
    return dummySort.filter{
        ((Int(String($0.trainCode.last ?? "9")) ?? 9) % 2) == 1
    }
}()
let shinbundagSinsaStationScheduleDummyData = try! JSONDecoder().decode([ShinbundangScheduleModel].self, from: shinbundangSinsaStationData)
let seoulScheduleToResultScheduleTransformDummyData = seoulScheduleDummyData.SearchSTNTimeTableByFRCodeService.row
    .map {
        ResultSchdule(startTime: $0.startTime , type: .Seoul, isFast: $0.isFast, startStation: $0.startStation, lastStation: $0.lastStation)
    }

let stationNameSearcDummyhData = try! JSONDecoder().decode(SearchStaion.self, from: stationNameSearchData)
let vicinityStationsDummyData = try! JSONDecoder().decode(VicinityStationsData.self, from: vicinityData)

let totalArrivalDummyData = arrivalDummyData.realtimeArrivalList.map {TotalRealtimeStationArrival(realTimeStationArrival: $0, backStationName: "", nextStationName: "", nowStateMSG: $0.useState)}
let subwayLineData = SubwayLineData(rawValue: "03호선")!
let mainCellDummyData =  MainTableViewCellData(upDown: "상행", arrivalTime: "100분뒤", previousStation: "", subPrevious: "", code: "1",  stationName: "교대", lastStation: "",  isFast: "", group: "", id: "-", stationCode: "340", exceptionLastStation: "", type: .real, backStationId: "1003000339", nextStationId: "1003000341", korailCode: "",  stateMSG: "도착", subwayLineData: subwayLineData)

let detailSendModelDummyData = DetailSendModel(upDown: "상행", stationName: "교대", lineNumber: "03호선", stationCode: "340", lineCode: "1003", exceptionLastStation: "", korailCode: "")

let detailArrivalDataRequestDummyModel = DetailArrivalDataRequestModel(upDown: "상행", stationName: "교대", line: SubwayLineData(rawValue: "03호선")!, exceptionLastStation: "")

let url = "Test.url"
let arrivalGyodaeStation3Line = SaveStation(id: "-", stationName: "교대", stationCode: "340", updnLine: "상행", line: "03호선", lineCode: "1003", group: .one, exceptionLastStation: "", korailCode: "")
let scheduleGyodaeStation3Line = ScheduleSearch(stationCode: "340", upDown: "상행", exceptionLastStation: "", line: "03호선", korailCode: "", stationName: "교대")
let scheduleK215K1Line = ScheduleSearch(stationCode: "K215", upDown: "하행", exceptionLastStation: "", line: "", korailCode: "K1", stationName: "선릉")
let scheduleSinsaShinbundagLine = ScheduleSearch(stationCode: "D04", upDown: "하행", exceptionLastStation: "", line: "신분당선", korailCode: "", stationName: "신사")
let searchDeafultList = ["교대", "강남", "서초"]
let locationData = LocationData(lat: 37.49388026940836, lon: 127.01360357128935)
let vicinityTransformData: [VicinityTransformData] =  [
    .init(id: "1", name: "교대", line: "3호선", distance: "1000m"),
    .init(id: "2", name: "강남", line: "2호선", distance: "1500m"),
    .init(id: "3", name: "고속터미널", line: "9호선", distance: "2000m"),
    .init(id: "4", name: "사당", line: "4호선", distance: "3000m")
]
let searchQueryRecommend = [
    SearchQueryRecommendData(queryName: "강남", stationName: "강남구청", line: "7, 수인"),
    SearchQueryRecommendData(queryName: "마포", stationName: "마포구청", line: "6")
]

let subwayNotice = SubwayNotice(title: "4호선 혜화역 하선 열차 무정차 통과 종료", content: "4호선 혜화역 특정장애인단체 불법시위로 인한 하선 열차 무정차 통과는 09:30분부로 종료되어 열차 정상운행 중입니다. 11-12 09:13:09 11-17 09:33:01", occurredAt: "2025-11-17T09:33:01", lineNames: "4호선", createdDate: "20251117", isNonstop: "Y", direction: "하행", exceptionEndedAt: "2025-11-17T09:30:00")
let subwayNoticeInfiniteDate = SubwayNotice(title: "4호선 혜화역 하선 열차 무정차 통과 종료", content: "4호선 혜화역 특정장애인단체 불법시위로 인한 하선 열차 무정차 통과는 09:30분부로 종료되어 열차 정상운행 중입니다. 11-12 09:13:09 11-17 09:33:01", occurredAt: "2099-11-17T09:33:01", lineNames: "4호선", createdDate: "20991117", isNonstop: "Y", direction: "하행", exceptionEndedAt: "2099-11-17T09:30:00")

let urlResponse = HTTPURLResponse(url: URL(string: url)!,
                                  statusCode: 200,
                                  httpVersion: nil,
                                  headerFields: nil)

class DummyLoad{
    func fileLoad(_ fileName : String) -> Data{
        let data : Data
        let bundle = Bundle(for: type(of: self))
        
        guard let file = bundle.url(forResource: fileName, withExtension: nil) else {
            fatalError("Error File을 불러올 수 없음")
        }
        
        do{
            data = try Data(contentsOf: file)
        }catch{
            fatalError("Error File을 불러올 수 없음")
        }
        
        return data
    }
}
