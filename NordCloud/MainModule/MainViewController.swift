//
//  MainViewController.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 22.01.2022.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private var viewModel: MainViewModelProtocol?

    // MARK: Properties
    let calls = [Calls]()

    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("mainViewControllerTitleLabel", comment: "")
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func loadView() {
        super.loadView()

        view.addSubview(titleLabel)
        view.addSubview(tableView)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }


    // MARK: Methods
    func setup(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel

        viewModel.getCalls()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainCell.self, forCellReuseIdentifier: "cell")

        loadView()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.calls.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainCell
        if let call = viewModel?.calls[indexPath.row] {
            cell.configure(model: call)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelect(at: indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: MainViewModelHandlerProtocol {
    func didLoadCalls() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
