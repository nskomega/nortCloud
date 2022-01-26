//
//  ModuleBuilder.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 22.01.2022.
//

import UIKit

class ModuleBuilder {

    static func mainVC() -> UIViewController {

        let viewController = MainViewController()
        let router = MainRouter(viewController: viewController)
        router.presenter = viewController
        let callService = CallService()
        let viewModel = MainViewModel(router: router, callService: callService, handler: viewController)
        viewController.setup(viewModel: viewModel)
        viewController.view.backgroundColor = .white
        return viewController
    }

    static func detailVC(call: Request) -> UIViewController {

        let viewController = BottomSheetViewController(call: call)
        let router = BottomSheetRouter(viewController: viewController)
        let viewModel = BottomSheetViewModel(router: router)
        viewController.setup(viewModel: viewModel)
        viewController.view.backgroundColor = .white
        return viewController
    }
}
