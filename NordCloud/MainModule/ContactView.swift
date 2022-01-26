//
//  ContactView.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 26.01.2022.
//

import UIKit
import SnapKit

class ContactView: UIView {

    private let firstLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let thirdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(thirdLabel)

        firstLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }

        secondLabel.snp.makeConstraints {
            $0.leading.equalTo(firstLabel.snp.leading)
            $0.trailing.equalTo(firstLabel.snp.trailing)
            $0.top.equalTo(firstLabel.snp.bottom)
            $0.bottom.equalToSuperview()
        }

        thirdLabel.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    func configure(contact: Client) {
        if let name = contact.name {
            firstLabel.text = name
            secondLabel.text = contact.address
            firstLabel.isHidden = false
            secondLabel.isHidden = false
            thirdLabel.isHidden = true
        } else {
            firstLabel.text = nil
            secondLabel.text = nil
            thirdLabel.text = contact.address
            firstLabel.isHidden = true
            secondLabel.isHidden = true
            thirdLabel.isHidden = false
        }
        setNeedsLayout()
    }
}
