//
//  RepositorySpec.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import Foundation

protocol RepositorySpec {}
protocol CalendartRepositorySpec: RepositorySpec {
    func getCalendart(with timeIntervalSince1970: Int, doneHandle: @escaping ((Result<[(Date, Bool)], Error>) -> Void))
}
