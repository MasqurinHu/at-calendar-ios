//
//  DataSourceSpec.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import Foundation

protocol DataSourceSpec {}
protocol NormalApiDataSourceSpec: DataSourceSpec {
    func getCalendart(with timeIntervalSince1970: Int, doneHandle: @escaping ((Result<ReservationModel, Error>) -> Void))
}
