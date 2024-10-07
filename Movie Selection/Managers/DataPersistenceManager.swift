//
//  DataPersistenceManager.swift
//  Movie Selection
//
//  Created by Hafiz on 24/09/2024.
//

import Foundation
import UIKit
import CoreData

enum DownloadError: Error {
    case failedToSave
    case failedToFetch
    case failedToDelete
}

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.title = model.title
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.media_type = model.media_type
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DownloadError.failedToSave))
            print(error.localizedDescription)
        }
    }
    
    func fetchingTitleFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DownloadError.failedToFetch))

            print(error.localizedDescription)
        }
        
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DownloadError.failedToDelete))

            print(error.localizedDescription)
        }
    }
}
