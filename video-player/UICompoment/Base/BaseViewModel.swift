//
//  BaseViewModel.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import Combine
import Foundation

class BaseViewModel: NSObject {
    // MARK: - Properties

    var cancellables = Set<AnyCancellable>()

    var hudSubject = PassthroughSubject<Bool, Never>()

    var showErrorSubject = PassthroughSubject<Error, Never>()

    override required init() {
        super.init()
        observeOutputs()
    }

    deinit {
        print("\(type(of: self)) deinit")
    }

    func viewDidLoad() { /* should override */ }

    func viewWillAppear() { /* should override */ }

    func viewDidAppear() { /* should override */ }

    func viewWillDisappear() { /* should override */ }

    func viewDidDisappear() { /* should override */ }

    func observeOutputs() { /* should override */ }
}
