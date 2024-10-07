//
//  TitleTableViewCell.swift
//  Movie Selection
//
//  Created by Hafiz on 23/09/2024.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.clipsToBounds = true
        return title
    }()
    
    private let playButton: UIButton = {
        let playButton = UIButton()
        let buttonImage = (UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)))
        playButton.setImage(buttonImage, for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.tintColor = .white
        return playButton
    }()
    
    private let titlePosterView: UIImageView = {
        let posterView = UIImageView()
        posterView.contentMode = .scaleAspectFit
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.clipsToBounds = true
        return posterView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        contentView.addSubview(titlePosterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        applyConstraint()
    }
    
    private func applyConstraint(){
        
        let titlePosterViewConstraints = [
            titlePosterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlePosterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlePosterView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        let playButtonConstraint = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraint)
    }
    
    public func configure(with model: TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        titlePosterView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
