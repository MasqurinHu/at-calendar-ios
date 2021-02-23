//
//  DummyApiDataSource.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/24.
//

import Foundation

struct DummyApiDataSource: NormalApiDataSourceSpec {

    func getCalendart(with timeIntervalSince1970: Int, doneHandle: @escaping ((Result<ReservationModel, Error>) -> Void)) {
        guard
            let path = Bundle.main.path(forResource: "booked", ofType: "json"),
            let jsonString = try? String(contentsOfFile: path, encoding: .utf8),
            let jsonData = jsonString.data(using: .utf8) else {
            doneHandle(.failure(ApiError.apierror))
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let returnData = try? decoder.decode(ReservationModel.self, from: jsonData) else {
            doneHandle(.failure(ApiError.decoderError))
            return
        }
        doneHandle(.success(returnData))
    }
}
