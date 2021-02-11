//
//  MainViewModel.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import Foundation

final class MainViewModel {
    private(set) var movie: Movies = Movies()
    private(set) var movieList: [Movie] = [Movie]()
    var searching: Bool = false
    var genresDict: [Int: String] = [Int: String]()
    var hasInternetConnection: Bool = true
    private let api: API = .shared
    
    func getList(page: Int, success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        api.fetchItems(endPoint: TMDBEndPoint.fetchMovies(page), type: Movies.self) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                if page == 1 {
                    self.movie = .init()
                    self.movieList.removeAll()
                }
                self.movie = response
                if let movieList = self.movie.results {
                    if self.searching {
                        self.searching = false
                        self.movieList = movieList
                    } else{
                        self.movieList.append(contentsOf: movieList)
                    }
                }
                success()
            case let .failure(error):
                self.searching = false
                failure(error)
            }
        }
    }
    
    
    func getMovieDetails(movie_id: Int, success: @escaping (DetailedMovie) -> Void, failure: @escaping (ServiceError) -> Void) {
        api.fetchItems(endPoint: TMDBEndPoint.fetchMovieDetail(movie_id), type: DetailedMovie.self) { [weak self] (result) in
            switch result {
            case let .success(response):
                self?.searching = false
                success(response)
            case let .failure(ServiceError):
                failure(ServiceError)
            }
        }
    }
  
    func searchByText(_ text: String, page: Int, success: @escaping () -> Void, failure: @escaping (ServiceError) -> Void) {
        if !text.isEmpty {
            api.fetchItems(endPoint: TMDBEndPoint.searchMovies(page, text), type: Movies.self) { [weak self] (result) in
                switch result {
                case let .success(response):
                    self?.movie = response
                    if let movieList = response.results {
                        if self?.searching == false {
                            self?.movieList = movieList
                            self?.searching = true
                            success()
                        } else {
                            self?.movieList.append(contentsOf:  movieList)
                            success()
                        }
                    }
                case let .failure(error):
                    self?.searching = true
                    self?.movie = Movies()
                    if let error = error as? ServiceError {
                        self?.movieList = []
                        failure(error)
                    }
                    
                }
            }
        }
//        if !text.isEmpty {
//            searchByTextApi(text, page: page)
//                .observeOn(MainScheduler.instance)
//                .subscribe(onNext: { [unowned self] movie in
//                    self.movie = movie
//                    if let movieList = movie.results {
//                        if self.searching == false {
//                            self.movieList = movieList
//                            self.searching = true
//                        }else {
//                            self.movieList.append(contentsOf: movieList)
//                        }
//                    }
//                    print("Count is: ", self.movieList.count)
//                    success()
//                }, onError: { [unowned self] error in
//                    self.searching = true
//                    self.movie = Movies()
//                    if let error = error as? ServiceError {
//                        self.movieList = []
//                        failure(error)
//                    }
//
//                }).disposed(by: disposeBag)
//        }
    }
//    
//    
//    func getGenres(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
//        getGenresApi()
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] genres in
//                guard let genres = genres.genres else {return}
//                genres.forEach { (genre) in
//                    self.genresDict[genre.id] = genre.name
//                }
//                    success()
//                }, onError: { error in
//                    failure(error)
//                }).disposed(by: disposeBag)
//    }
//    
//    fileprivate func getGenresApi() -> Genres {
//        return ApiClient.shared.request(ApiRouter.getGenres)
//    }
}

