//
//  MainCell.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 22.01.2022.
//

import UIKit
import SnapKit

class MainCell: UITableViewCell {

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = NSLocalizedString("mainCellFormatTime", comment: "")
        return dateFormatter
    }()

    private let mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowOpacity = 0.2
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
        return mainView
    }()

    private let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let fotoImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "call")
        return imageview
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("mainCellDurationLabel", comment: "")
        label.textColor = .lightGray
        label.font = .italicSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeToCallLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("mainCellTimeToCallLabel", comment: "")
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contactView: ContactView = {
        let view = ContactView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        loadView()
    }

    func configure(model: Request) {
        contactView.configure(contact: model.client)
        timeToCallLabel.text = dateFormatter.string(from: model.created)
        let duration = model.duration
        let newDuration = duration.dropFirst(3)
        durationLabel.text = String(newDuration)
    }

    func loadView() {
        self.addSubview(mainView)
        self.mainView.addSubview(firstStackView)
        self.firstStackView.addSubview(fotoImageView)
        self.firstStackView.addSubview(durationLabel)
        self.addSubview(contactView)
        self.mainView.addSubview(timeToCallLabel)

        mainView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(6)
            $0.bottom.equalToSuperview().offset(-6)
        }

        firstStackView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        fotoImageView.snp.makeConstraints {
            $0.leading.equalTo(firstStackView.snp.leading).offset(20)
            $0.top.equalTo(firstStackView.snp.top).offset(16)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }

        contactView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(90)
            $0.trailing.equalTo(timeToCallLabel.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
        })

        durationLabel.snp.makeConstraints {
            $0.top.equalTo(fotoImageView.snp.bottom)
            $0.leading.equalTo(fotoImageView.snp.leading)
            $0.bottom.equalToSuperview()
        }

        timeToCallLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.equalTo(70)
        }
    }
}
