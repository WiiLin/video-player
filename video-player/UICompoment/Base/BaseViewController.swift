//
//  BaseViewController.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import Combine
import UIKit

class BaseViewController<VM: BaseViewModel>: UIViewController {
    // MARK: - 📌 Constants

    // MARK: - 🔶 Properties

    var cancellables = Set<AnyCancellable>()
    let viewModel: VM

    // MARK: - 🧩 Subviews

    // MARK: - 🔨 Initialization

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(type(of: self)) deinit")
    }

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        viewModel = VM()
        super.init(coder: coder)
    }

    // MARK: - 🖼 View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeViewModelOutputs()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }

    func setupUI() { /* should override */ }

    func observeViewModelOutputs() {
        viewModel.hudSubject
            .sink { show in
                if show {
                    print("showHUD")
                } else {
                    print("hideHUD")
                }
            }
            .store(in: &cancellables)

        viewModel.showErrorSubject
            .sink { [weak self] error in
                guard let self else { return }
                UIAlertController.showError(error, controller: self)
            }
            .store(in: &cancellables)
    }
}

// MARK: - 🏗 UI

private extension BaseViewController {}

// MARK: - 👆 Actions

private extension BaseViewController {}

// MARK: - 🔒 Private Methods

private extension BaseViewController {}

// MARK: - 🚌 Public Methods
