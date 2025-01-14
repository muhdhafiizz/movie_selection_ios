//
//  HomeViewController.swift
//  Movie Selection
//
//  Created by Hafiz on 20/09/2024.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingSeries = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    var randomSelectedMovie: Title?
    var headerView: DisplayMovieHeaderView?
    
    let sectionTitle: [String] = ["Trending Movie","Trending TV Series", "Popular", "Top Movies", "Upcoming Movies"]
    
    
    private let homeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(homeTableView)
        view.backgroundColor = .systemBackground
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        configureNavBar()
        
        headerView = DisplayMovieHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeTableView.tableHeaderView = headerView
        configureDisplayMovieHeader()
    }
    
    func configureDisplayMovieHeader(){
        APICaller.apiCall.getTrendingMovies{ [weak self] result in
            switch result {
            case .success(let titles):
                let selectedMovie = titles.randomElement()
                self?.randomSelectedMovie = selectedMovie
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedMovie?.title ?? "" , posterURL: selectedMovie?.poster_path ?? ""))
            case .failure (let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configureNavBar(){
        var image = UIImage(named: "netflixlogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems =
            [
                UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
                UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            ]
        
        navigationController?.navigationBar.tintColor = .white
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }
    
    
        
        
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath)
                as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            APICaller.apiCall.getTrendingMovies {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingSeries.rawValue:
            APICaller.apiCall.getTrendingTVSeries {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.apiCall.getPopularMovies {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        case Sections.TopRated.rawValue:
            APICaller.apiCall.getTopRatedMovies {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.apiCall.getUpcomingMovies {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizedFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDeligate {
    func collectionViewTableViewCellDelegate(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModels) {
        DispatchQueue.main.async{ [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
