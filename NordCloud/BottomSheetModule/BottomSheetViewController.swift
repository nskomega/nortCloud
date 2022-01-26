//
//  BottomSheetViewController.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 22.01.2022.
//

import UIKit
import SnapKit

class BottomSheetViewController: UIViewController {

    private var viewModel: BottomSheetViewModelProtocol?
    private var call: Request

    // MARK: Properties
    let defaultHeight: CGFloat = 150
    var currentContainerHeight: CGFloat = 150
    let dismissibleHeight: CGFloat = 149
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64

    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?

    // MARK: - Subviews
    private let busNumLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("bottomSheetViewControllerBusNumLabel", comment: "")
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("bottomSheetViewControllerNameLabel", comment: "")
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let telefonLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("bottomSheetViewControllerTelefonLabel", comment: "")
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [busNumLabel, nameLabel, telefonLabel])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Initialization
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }

    init(call: Request) {
        self.call = call
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        telefonLabel.text = call.businessNumber.number

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)

        setupConstraints()
        setupPanGesture()
    }

    @objc func handleCloseAction() {
        animateDismissView()
    }

    override func loadView() {
        super.loadView()

        setupView()

        view.addSubview(dimmedView)
        view.addSubview(containerView)

        dimmedView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }

        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        containerViewBottomConstraint?.isActive = true
    }

    func setupConstraints() {
        containerView.addSubview(contentStackView)

        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)

        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }

    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y

        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }

    // MARK: Methods
    func setupView() {
        view.backgroundColor = .clear
    }

    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }

    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }

    func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }

    func setup(viewModel: BottomSheetViewModelProtocol) {
        self.viewModel = viewModel
        loadView()
    }
}
