//
//  BottomSheetRouter.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 22.01.2022.
//

import UIKit

protocol BottomSheetRouterProtocol: AnyObject {
}

final class BottomSheetRouter: BottomSheetRouterProtocol {

    // MARK: Properties
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
