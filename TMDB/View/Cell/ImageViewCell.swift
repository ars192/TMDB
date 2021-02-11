//
//  ImageViewCell.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import UIKit

class ImageViewCell: UITableViewCell {
    var isSet: Bool?

    fileprivate let gradientContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate let topGradientContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate var containerForLabel: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var titleStr: String? {
        didSet {
            titleLabel.text = titleStr
        }
    }
    
    var genres: [Genre]? {
        didSet {
            setupGenreLabels(genres)
        }
    }
    
    fileprivate var mainPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        return stackView
    }()
    
    var imageString: String? {
        didSet {
            guard let imageString = imageString,
                  let url = URL(string: imageString) else {
                return
            }
            mainPosterImageView.setImage(with: url)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

//MARK: - Actions
extension ImageViewCell {
    
}

//MARK: - ConfigUI
extension ImageViewCell {
    fileprivate func configUI() {
        backgroundColor = .clear
        setupGradientLayer()
        [mainPosterImageView, containerForLabel, stackView].forEach {
            addSubview($0)
        }
        
        [titleLabel].forEach {
            containerForLabel.addSubview($0)
        }
        
        makeConstraints()
    }
    
    fileprivate func makeConstraints() {
        mainPosterImageView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        
        
        gradientContainerView.snp.makeConstraints { (m) in
            m.right.left.bottom.equalToSuperview()
            m.height.equalTo(200)
        }
        
        topGradientContainerView.snp.makeConstraints { (m) in
            m.right.left.top.equalToSuperview()
            m.height.equalTo(150)
        }
        
        containerForLabel.snp.makeConstraints { (m) in
            m.right.equalTo(safeAreaLayoutGuide).offset(-20)
            m.left.equalTo(safeAreaLayoutGuide).offset(20)
            m.bottom.equalTo(safeAreaLayoutGuide)
            m.height.equalTo(110)
        }
        
        titleLabel.snp.makeConstraints { (m) in
            m.top.left.equalToSuperview()
            m.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (m) in
            m.left.right.equalTo(containerForLabel)
            m.bottom.equalToSuperview()
            m.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.backgroundColor.cgColor]
        gradientLayer.locations = [0.3, 1]
        gradientContainerView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 200))

        mainPosterImageView.addSubview(gradientContainerView)
        mainPosterImageView.bringSubviewToFront(gradientContainerView)
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.colors = [UIColor.backgroundColor.cgColor, UIColor.clear.cgColor]
        gradientLayer2.locations = [0, 1]
        topGradientContainerView.layer.addSublayer(gradientLayer2)
        gradientLayer2.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 150))
        
        mainPosterImageView.addSubview(topGradientContainerView)
        mainPosterImageView.bringSubviewToFront(topGradientContainerView)
    }
    
    fileprivate func setupGenreLabels(_ genres: [Genre]?) {
        if !(isSet ?? false) {
            guard let genres = genres else { return }
            var counter = 0
            genres.forEach { genre in
                if counter == 4 {
                    return
                }
                let button = UIButton()
                button.setTitle(genre.name, for: .normal)
                button.titleLabel?.textColor = UIColor.customGray
                button.titleLabel?.font = UIFont.medium(size: 14)
                button.titleLabel?.numberOfLines = 1
                button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                button.layer.borderWidth = 1
                button.layer.cornerRadius = 5
                button.layer.borderColor = UIColor.customGray.cgColor
                button.translatesAutoresizingMaskIntoConstraints = false
                button.isUserInteractionEnabled = false
                stackView.addArrangedSubview(button)
                counter += 1
            }
        }
        
    }
}
