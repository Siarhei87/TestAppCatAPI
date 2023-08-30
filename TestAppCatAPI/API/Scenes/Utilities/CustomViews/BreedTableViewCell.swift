//
//  BreedTableViewCell.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation
import UIKit

class BreedTableViewCell: UITableViewCell {
    let breedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let breedGroupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let originLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Allow multiple lines
        return label
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBreedValue(name: String?, group: String?, origin: String?) {
        breedNameLabel.text = "Name: \(name ?? "")"
        breedGroupLabel.text = "Group: \(group ?? "")"
        originLabel.text = "Origin: \(origin ?? "")"
    }

    private func setupViews() {
        addSubview(infoStackView)
        addSubview(breedGroupLabel)
        
        infoStackView.addArrangedSubview(breedNameLabel)
        infoStackView.addArrangedSubview(originLabel)

        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            breedGroupLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            breedGroupLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            breedGroupLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
