//
//  StoreCell.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 30.03.22.
//

import SnapKit

final class StoreCell: UITableViewCell {
    
    static let identifier = "StoreCellIdentifier"
    
    // MARK: - Subviews
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = Constants.cornerRadius
        image.layer.shadowRadius = Constants.cornerRadius
        image.layer.shadowColor = UIColor.systemGray.cgColor
        image.layer.shadowOpacity = 1
        return image
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeLayoutConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func makeLayoutConstrains() {
        addSubview(logoImage)
        addSubview(storeNameLabel)
        
        logoImage.snp.makeConstraints { maker in
            maker.height.width.equalTo(self.snp.height).multipliedBy(0.8)
            maker.left.equalToSuperview().inset(Constants.horizontalSpacing)
            maker.centerY.equalToSuperview()
        }
        storeNameLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(logoImage.snp.right).offset(Constants.horizontalSpacing)
            maker.height.equalToSuperview().multipliedBy(0.5)
            maker.right.equalToSuperview().inset(Constants.horizontalSpacing)
        }
    }
    
    private struct Constants {
        static let verticalSpacing: CGFloat = 5
        static let horizontalSpacing: CGFloat = 3
        static let cornerRadius: CGFloat = 7
    }
    
}
