//
//  TitleCollectionViewCell.swift
//  Movie Selection
//
//  Created by Hafiz on 22/09/2024.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let posterView = UIImageView()
        posterView.contentMode = .scaleAspectFill
        return posterView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
//        print("\(url)")
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
}
