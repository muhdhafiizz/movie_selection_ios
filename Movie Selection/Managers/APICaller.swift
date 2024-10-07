//
//  APICaller.swift
//  Movie Selection
//
//  Created by Hafiz on 22/09/2024.
//

import Foundation

struct Constants{
    static let apiKey = "ed1d324b4a4d89fb2832a33d486ad45c"
    static let baseURL = "https://api.themoviedb.org/"
    static let youtubeApiKey = "AIzaSyAnHw4FQBN2vB4kj_dJ0aOtT4m7uLRujWE"
    static let youtubeBaseURL = "https://www.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedRetrieveData
}

class APICaller {
    static let apiCall = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/trending/movie/day?api_key=\(Constants.apiKey)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedRetrieveData))
            }
        }
        task.resume()
    }
    
    func getTrendingTVSeries(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/trending/tv/day?api_key=\(Constants.apiKey)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                //                    print (results)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedRetrieveData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/upcoming?api_key=\(Constants.apiKey)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                //                    print (results)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedRetrieveData))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/popular?api_key=\(Constants.apiKey)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                //                    print (results)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/top_rated?api_key=\(Constants.apiKey)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                                    print (results)
            } catch {
                completion(.failure(APIError.failedRetrieveData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/discover/movie?api_key=\(Constants.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedRetrieveData))
                print("Error fetching discover movies: \(error)")
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.failedRetrieveData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedRetrieveData))
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }
    
    func getYotubeTrailer(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(query)&key=\(Constants.youtubeApiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("Error: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                    return
                }
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("Response String: \(responseString ?? "No response data")")
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
//                print(results)
            } catch {
                completion(.failure(APIError.failedRetrieveData))
                print("Decoding error: \(error)")
            }
        }
        task.resume()

    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)3/search/movie?api_key=\(Constants.apiKey)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedRetrieveData))
                print("Error fetching discover movies: \(error)")
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.failedRetrieveData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedRetrieveData))
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }
}
