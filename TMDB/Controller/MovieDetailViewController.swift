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

    fileprivate lazy var rootView = MovieDetailView(delegate: self)
    
    var movie: DetailedMovie? {
        didSet {
            guard let movie = movie else {return}
            if let getFullImagePath = getFullImagePath, let posterPath = movie.posterPath {
                rootView.setImageString(getFullImagePath(posterPath))
            }
            rootView.setTitle(movie.originalTitle!)
            rootView.setRate(movie.voteAverage)
        }
    }

    override func loadView() {
        view = rootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension MovieDetailViewController: MovieDetailDelegate {
    func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc
//    func dismissVC() {
//        self.navigationController?.popViewController(animated: true)
////        self.dismiss(animated: true, completion: nil)
//    }
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
                cell.isSet = rootView.isRateSet
                cell.titleStr = movie?.originalTitle
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! RateDetailCell
                cell.overview = movie?.overview
                cell.rateTMDB = movie?.voteAverage
                cell.isSet = rootView.isRateSet

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

//////MARK: - ConfigUI
//extension MovieDetailViewController {
//    fileprivate func configUI() {
//        view.backgroundColor = UIColor.backgroundColor
//        [tableView, backButton].forEach {
//            view.addSubview($0)
//        }
//        isRateSet = true
//
//        makeConstraints()
//    }
//
//    fileprivate func makeConstraints() {
//        tableView.snp.makeConstraints { (m) in
//            m.top.equalToSuperview()
//            m.bottom.equalTo(view.safeAreaLayoutGuide)
//            m.right.left.equalToSuperview()
//        }
//
//        backButton.snp.makeConstraints { (m) in
//            m.top.equalTo(view.safeAreaLayoutGuide).offset(10)
//            m.left.equalToSuperview().offset(10)
//            m.height.width.equalTo(40)
//        }
//    }
//
//    func setupGradientLayer() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.backgroundColor.cgColor]
//        gradientLayer.locations = [0.5, 1]
//        bottomGradientContainerView.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = imageView.bounds
//        gradientLayer.frame.origin.y -= imageView.bounds.height
//    }
//
//}
