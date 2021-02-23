//
//  ReservationModel.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import Foundation

struct ReservationModel: Decodable {
    let available: [TimeRangeModel]
    let booked: [TimeRangeModel]
}
