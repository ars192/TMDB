//
//  MovieDetailView.swift
//  TMDB
//
//  Created by Arystan on 2/11/21.
//


import UIKit

protocol MovieDetailDelegate {
    func dismissVC()
}
class MovieDetailView: UIView {
    
    public var isRateSet = false
    private let reuseIdentifier1 = "cell"
    private let reuseIdentifier2 = "cell2"
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = UIFont.medium()
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.refreshControl = UIRefreshControl()
        tableView.register(ImageViewCell.self, forCellReuseIdentifier: reuseIdentifier1)
        tableView.register(RateDetailCell.self, forCellReuseIdentifier: reuseIdentifier2)
        tableView.separatorStyle = .none
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    fileprivate let bottomGradientContainerView: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate let topGradientContainerView: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
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
        label.numberOfLines = 2
        return label
    }()

    //Might be more than one
    fileprivate var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        return label
    }()

    fileprivate var rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        label.textAlignment = .right
        return label
    }()
    
    fileprivate var titleStr: String? {
        didSet {
            titleLabel.text = titleStr
        }
    }

    fileprivate var rate: Double? {
        didSet {
            if let rate = rate {rateLabel.text = String(rate)}
        }
    }

    fileprivate var imageString: String? {
        didSet {
            guard let imageString = imageString,
                  let url = URL(string: imageString) else {
                return
            }
            imageView.setImage(with: url)
        }
    }
    
    init(delegate: MovieDetailDelegate & UITableViewDelegate & UITableViewDataSource) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.tableView.dataSource = delegate
        self.tableView.delegate = delegate
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var delegate: MovieDetailDelegate?
    
    @objc private func dismissVC() {
        delegate?.dismissVC()
    }
    
    public func setRate(_ n: Double?) {
        rate =  n
    }
    
    public func setTitle(_ str: String) {
        titleStr = str
    }
    
    public func setImageString(_ str: String) {
        imageString = str
    }
}

extension MovieDetailView {
    fileprivate func configUI() {
        backgroundColor = UIColor.backgroundColor
        [tableView, backButton].forEach {
            addSubview($0)
        }
        isRateSet = true

        makeConstraints()
    }

    fileprivate func makeConstraints() {
        tableView.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.bottom.equalTo(safeAreaLayoutGuide)
            m.right.left.equalToSuperview()
        }

        backButton.snp.makeConstraints { (m) in
            m.top.equalTo(safeAreaLayoutGuide).offset(10)
            m.left.equalToSuperview().offset(10)
            m.height.width.equalTo(40)
        }
    }

    func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.backgroundColor.cgColor]
        gradientLayer.locations = [0.5, 1]
        bottomGradientContainerView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = imageView.bounds
        gradientLayer.frame.origin.y -= imageView.bounds.height
    }
}
