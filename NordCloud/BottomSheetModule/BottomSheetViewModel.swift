//
//  BottomSheetViewModel.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 22.01.2022.
//

import Foundation

protocol BottomSheetViewModelProtocol: AnyObject {
}

final class BottomSheetViewModel: BottomSheetViewModelProtocol {

    // MARK: Properties
    private let router: BottomSheetRouter

    init(router: BottomSheetRouter) {
        self.router = router
    }
}
