//
//  ViewController.swift
//  TMDB
//
//  Created by Arystan on 2/8/21.
//

import Foundation
import UIKit
import SnapKit
//import RxSwift
//import SVProgressHUD
//import DZNEmptyDataSet

enum FilterType {
    case favourites, popular
}

class ViewController: UIViewController {
    fileprivate let viewModel = MainViewModel()
    fileprivate let movieReusableCell = "movieReusableCell"
    fileprivate var filterType: FilterType = .popular
    
    var itemSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.5)
    }
    
    fileprivate lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a movie"
        searchController.searchBar.backgroundColor = UIColor.backgroundColor
        searchController.searchBar.barStyle = UIBarStyle.black
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Popular", "Favourites", "Search"]
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.itemSize.width - 30, height: self.itemSize.height)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: movieReusableCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.backgroundColor
        collectionView.refreshControl = refreshControl
//        collectionView.emptyDataSetSource = self
//        collectionView.emptyDataSetDelegate = self
        collectionView.refreshControl = self.refreshControl
        return collectionView
    }()
    
    private var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(updateList), for: .valueChanged)
        return view
    }()

    private var movies: Movies = Movies()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRequest()
//        getMovieList(page: 1)
//        makeRequest()
        configUI()
    }
//    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
//MARK: - Requests
extension ViewController {
    fileprivate func makeRequest() {
        let dispatchGroup = DispatchGroup()
        getGenres(dg: dispatchGroup)
        dispatchGroup.notify(queue: .global()) { [unowned self] in
            self.getMovieList(page: 1)
        }
    }

    fileprivate func getMovieList(page: Int) {
        viewModel.getList(page: page) { [weak self] in
            guard let self = self else { return }
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        } failure: { _ in
            //TODO: - Расписать Service Error
        }

    }
    
    fileprivate func getFavourites() {

    }

    fileprivate func getMovieDetails(movie_id: Int) {
        viewModel.getMovieDetails(movie_id: movie_id, success: { [weak self] movie_details in
            guard let wSelf = self else { return }
            wSelf.goToMovieDetails(movie_details)
        }) { [weak self] (error) in
            guard let wSelf = self else { return }
            wSelf.checkError(error: error)
        }
    }

    fileprivate func getGenres(dg: DispatchGroup) {
        dg.enter()
        dg.leave()
    }

    fileprivate func searchByText(text: String, page: Int) {
        viewModel.searchByText(text, page: page, success: { [weak self] in
            guard let wSelf = self else { return }
            wSelf.collectionView.reloadData()
        }) {[weak self] (error) in
            guard let wSelf = self else { return }
            wSelf.checkError(error: error)
        }
    }
}
//MARK: - Actions
extension ViewController {
    private func goToMovieDetails(_ movie_details: DetailedMovie) {
        let vc = MovieDetailViewController()
        vc.movie = movie_details
        vc.getFullImagePath = { [unowned self] posterPath in
            return self.getFullImageString(imageString: posterPath)
        }
        navigationController?.pushViewController(vc, animated: true)
//        navigationController?.present(vc, animated: true, completion: nil)
    }

    @objc
    private func updateList() {
        getMovieList(page: 1)
    }
}
//MARK: - Methods
extension ViewController {
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func getFullImageString(imageString: String) -> String {
        return Constants.Url.imageURL + imageString
    }

    func getGenreByID(id: Int) -> String? {
        if viewModel.genresDict.keys.contains(id) {
            return viewModel.genresDict[id]!
        }
        return nil
    }
}

//MARK: - UISearchDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: false, completion: nil)
        if let text = searchBar.text {
            viewModel.searching = false
//            viewModel.movieList = [Movie]()
//            viewModel.movie = Movies()
            searchByText(text: text, page: 1)
        }
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            searchController.dismiss(animated: false, completion: nil)
            getMovieList(page: 1)
        }else if selectedScope == 1 {
            searchController.dismiss(animated: false, completion: nil)
            getFavourites()
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.selectedScopeButtonIndex = 2
    }
}


//MARK: - UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("viewModel.movieList.count: \(viewModel.movieList.count)")
        return viewModel.movieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieReusableCell, for: indexPath) as! MovieViewCell
        cell.getFullImagePath = { [unowned self] posterPath in
            return self.getFullImageString(imageString: posterPath)
        }
        cell.movie = viewModel.movieList[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchController.isActive {
            searchController.dismiss(animated: false, completion: nil)
        }
        print(viewModel.movieList[indexPath.row])
        if let id = viewModel.movieList[indexPath.row].id {
            getMovieDetails(movie_id: id)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Pagination
        guard let totalPages = viewModel.movie.totalPages, let current_page = viewModel.movie.page else { return }
        if indexPath.row == viewModel.movieList.count - 1 && viewModel.movieList.count > 0  && totalPages > current_page {
            let next_page = current_page + 1
            if viewModel.searching {
                if let text = searchController.searchBar.text {
                    searchByText(text: text, page: next_page)
                }
            }else if filterType == .popular {
                getMovieList(page: next_page)
            }
        }
    }
}

////MARK: - ConfigUI
extension ViewController {
    fileprivate func configUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
//        searchController.searchBar.rx.text.asObservable()
//            .map { $0 ?? "" }
//            .bind(to: collectionView.)
        
        view.backgroundColor = UIColor.backgroundColor
        [collectionView].forEach {
            view.addSubview($0)
        }
        
        makeConstraints()
    }
    
    fileprivate func makeConstraints() {
        collectionView.snp.makeConstraints { (m) in
            m.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController {
    func checkError(error: ServiceError) {
        switch error {
            case .decodingError:
                break
            case .domainError(_):
                break
        }
    }
}
