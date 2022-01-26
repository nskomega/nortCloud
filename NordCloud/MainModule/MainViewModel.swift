//
//  MainViewModel.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 22.01.2022.
//

import Foundation

protocol MainViewModelHandlerProtocol: AnyObject {
    func didLoadCalls()
}

protocol MainViewModelProtocol: AnyObject {
    var calls: [Request] { get }
    var handler: MainViewModelHandlerProtocol? { get }
    func getCalls()
    func didSelect(at: Int)
}

class Storage {
    static var calls: [Request] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "calls"),
                  let calls = try? JSONDecoder().decode([Request].self, from: data)
            else {
                return []
            }
            return calls
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "calls")
            }
        }
    }
}

final class MainViewModel: MainViewModelProtocol {

    // MARK: Properties
    private let router: MainRouter
    private let callService: CallService
    private(set) var calls: [Request] = [] {
        didSet {
            Storage.calls = calls
        }
    }
    private(set) var handler: MainViewModelHandlerProtocol?

    init(router: MainRouter, callService: CallService, handler: MainViewModelHandlerProtocol?) {
        self.router = router
        self.callService = callService
        self.handler = handler
    }

    // MARK: Methods
    func getCalls() {
        callService.getCalls() { calls in
            self.calls = calls?.requests ?? Storage.calls
            self.handler?.didLoadCalls()
        }
    }

    func didSelect(at index: Int) {
        router.showBottomViewController(calls[index])
    }
}
