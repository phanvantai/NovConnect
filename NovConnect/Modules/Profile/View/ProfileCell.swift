//
//  ProfileCell.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: PostViewModel? {
        didSet {
            configureUI()
        }
    }
    
    // MARK: - Views
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        guard let viewModel = viewModel else { return }
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
}
