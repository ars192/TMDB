//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    var getFullImagePath: ((String)->(String))?
    private let reuseIdentifier1 = "cell"
    private let reuseIdentifier2 = "cell2"
    private let viewModel = MovieDetailViewModel()
    private var isRateSet = false
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        return tableView
    }()

    var movie: DetailedMovie? {
        didSet {
            guard let movie = movie else {return}
            if let getFullImagePath = getFullImagePath, let posterPath = movie.posterPath {
                imageString = getFullImagePath(posterPath)
            }
            if let movie_genres = movie.genres {
                setupGenreLabels(movie_genres)
            }
            titleStr = movie.originalTitle
            rate = movie.voteAverage
        }
    }

    fileprivate let bottomGradientContainerView: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate let topGradientContainerView: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate var imageView: CustomImageView = {
        let imageView = CustomImageView()
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
            if let imageString = imageString {imageView.loadImageFromUrl(urlString: imageString)}
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

//MARK: - Actions
extension MovieDetailViewController {
    @objc
    func dismissVC() {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - UITableView
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier1, for: indexPath) as! ImageViewCell
                if let getFullImagePath = getFullImagePath, let poster_path =  movie?.posterPath {
                    cell.imageString = getFullImagePath(poster_path)
                }
                cell.genres = movie?.genres
                cell.isSet = isRateSet
                cell.titleStr = movie?.originalTitle
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! RateDetailCell
                cell.overview = movie?.overview
                cell.rateTMDB = movie?.voteAverage
                cell.isSet = isRateSet

                return cell
            } else {
                let cell = UITableViewCell()
                return cell
            }
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return UIScreen.main.bounds.width * 1.3
            }else {
                return UITableView.automaticDimension
            }
        }else {
            return UITableView.automaticDimension
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 2 {
            let headerView = HeaderView()
            headerView.label.text = section == 1 ? "Reviews" : "Recommendations"
            return headerView
        }
        return UIView()
    }

}

////MARK: - ConfigUI
extension MovieDetailViewController {
    fileprivate func configUI() {
        view.backgroundColor = UIColor.backgroundColor
        [tableView, backButton].forEach {
            view.addSubview($0)
        }
        isRateSet = true

        makeConstraints()
    }

    fileprivate func makeConstraints() {
        tableView.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.bottom.equalTo(view.safeAreaLayoutGuide)
            m.right.left.equalToSuperview()
        }

        backButton.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuide).offset(10)
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

    func setupGenreLabels(_ genres: [Genre]) {

    }
}
