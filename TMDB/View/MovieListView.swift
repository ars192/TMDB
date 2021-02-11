//
//  MovieListView.swift
//  TMDB
//
//  Created by Arystan on 2/11/21.
//

import UIKit

protocol MovieListViewDelegate {
    func updateList()
}

class MovieListView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.itemSize.width - 30, height: self.itemSize.height)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: movieReusableCell)
        collectionView.backgroundColor = UIColor.backgroundColor
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl = self.refreshControl
        return collectionView
    }()
    
    private var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = .white
        view.addTarget(self, action: #selector(updateList), for: .valueChanged)
        return view
    }()
    
    public var delegate: MovieListViewDelegate?
    
    private var itemSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.5)
    }
    private let movieReusableCell = "movieReusableCell"
    
    init(delegate: (UICollectionViewDelegate & UICollectionViewDataSource & MovieListViewDelegate)) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.collectionView.dataSource = delegate
        self.collectionView.delegate = delegate
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    public func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc private func updateList() {
        delegate?.updateList()
    }
}

extension MovieListView {
    fileprivate func configUI() {
        backgroundColor = UIColor.backgroundColor
        [collectionView].forEach { addSubview($0) }
        makeConstraints()
    }

    fileprivate func makeConstraints() {
        collectionView.snp.makeConstraints { (m) in
            m.edges.equalTo(safeAreaLayoutGuide)
        }
    }

}
