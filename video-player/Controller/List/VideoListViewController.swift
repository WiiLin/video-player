//
//  VideoListViewController.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import UIKit

protocol VideoListView: BaseView {
    var onGoToDetail: ((Video) -> Void)? { get set }
}

class VideoListViewController: BaseViewController<VideoListViewModel>, VideoListView {
    // MARK: - 📌 Constants

    // MARK: - 🔶 Properties

    var onGoToDetail: ((Video) -> Void)?

    // MARK: - 🧩 Subviews

    @IBOutlet var tableView: UITableView!

    // MARK: - 🔨 Initialization

    override init(viewModel: VideoListViewModel) {
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 🖼 View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func observeViewModelOutputs() {
        super.observeViewModelOutputs()
        viewModel.fetchDataSuccessOutput
            .sink { [weak self] in
                guard let self = self else { return }
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    override func setupUI() {
        super.setupUI()

        title = "List"

        tableView.register(UINib(nibName: "\(VideoCell.self)", bundle: nil), forCellReuseIdentifier: "\(VideoCell.self)")

        tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))

        tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
    }
}

// MARK: - 🏗 UI

private extension VideoListViewController {}

// MARK: - 👆 Actions

private extension VideoListViewController {}

// MARK: - 🔒 Private Methods

private extension VideoListViewController {}

// MARK: - 🚌 Public Methods

extension VideoListViewController {}

// MARK: - UITableViewDelegate

extension VideoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let video = viewModel.dataSource[indexPath.row]
        onGoToDetail?(video)
    }
}

// MARK: - UITableViewDataSource

extension VideoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as! VideoCell
        let video = viewModel.dataSource[indexPath.row]
        cell.configure(data: video)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
}
