//
//  SnapService.swift
//  SnapPop
//
//  Created by 이인호 on 8/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class SnapService {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func saveImage(data: Data, completion: @escaping (Result<String, Error>) -> Void)  {
        let path = UUID().uuidString
        let fileReference = storage.child(path)
        
        fileReference.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            fileReference.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadUrl = url?.absoluteString else { return }
                
                print(downloadUrl)
                completion(.success(downloadUrl))
            }
        }
    }
      
    func saveSnap(categoryId: String, imageUrls: [String], completion: @escaping (Result<Snap, Error>) -> Void) {
        let snap = Snap(imageUrls: imageUrls, createdAt: Date())
        
        do {
            try db.collection("Users")
                .document(AuthViewModel.shared.currentUser?.uid ?? "")
                .collection("Categories")
                .document(categoryId)
                .collection("Snaps")
                .addDocument(from: snap) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success((snap)))
                }
        } catch {
            completion(.failure(error))
        }
    }

    func loadSnap(categoryId: String, snapDate: Date, completion: @escaping (Result<Snap, Error>) -> Void) {
        // 날짜 equal 비교가 안되서 start <= snapDate < end 로 찾음
        let components = Calendar.current.dateComponents([.year, .month, .day], from: snapDate)
    
        guard let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        else {
            fatalError("Could not find start date or calculate end date.")
        }
        
        db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Snaps")
            .whereField("createdAt", isGreaterThanOrEqualTo: start)
            .whereField("createdAt", isLessThan: end)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let document = querySnapshot?.documents.first else { return }
                
                do {
                    let snap = try document.data(as: Snap.self)
                    completion(.success(snap))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    func loadSnapsForMonth(categoryId: String, year: Int, month: Int, completion: @escaping (Result<[Snap], Error>) -> Void) {
        let calendar = Calendar.current
        guard let startOfMonth = calendar.date(from: DateComponents(year: year, month: month)),
              let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
            completion(.failure(NSError(domain: "InvalidDate", code: 0, userInfo: nil)))
            return
        }
        
        db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Snaps")
            .whereField("createdAt", isGreaterThanOrEqualTo: startOfMonth)
            .whereField("createdAt", isLessThan: startOfNextMonth)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = querySnapshot?.documents else { return }
                
                let snaps = documents.compactMap { document in
                    try? document.data(as: Snap.self)
                }
                
                completion(.success(snaps))
            }
    }
    
    func loadSnaps(categoryId: String, completion: @escaping (Result<[Snap], Error>) -> Void) {
        db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Snaps")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                guard let documents = querySnapshot?.documents else { return }
                
                let snaps = documents.compactMap { document in
                    try? document.data(as: Snap.self)
                }
                
                completion(.success(snaps))
            }
    }
    
    func updateSnap(categoryId: String, snap: Snap, newImageUrls: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        if let snapId = snap.id {
            var imageUrls = snap.imageUrls
            imageUrls.append(contentsOf: newImageUrls)
            
            db.collection("Users")
                .document(AuthViewModel.shared.currentUser?.uid ?? "")
                .collection("Categories")
                .document(categoryId)
                .collection("Snaps")
                .document(snapId)
                .updateData(["imageUrls": imageUrls]) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
        }
    }
    
    func deleteImage(categoryId: String, snap: Snap, imageUrlToDelete: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let snapId = snap.id {
            var imageUrls = snap.imageUrls
            if let index = imageUrls.firstIndex(of: imageUrlToDelete) {
                imageUrls.remove(at: index)
            }
            
            db.collection("Users")
                .document(AuthViewModel.shared.currentUser?.uid ?? "")
                .collection("Categories")
                .document(categoryId)
                .collection("Snaps")
                .document(snapId)
                .updateData(["imageUrls": imageUrls]) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    let imageRef = Storage.storage().reference(forURL: imageUrlToDelete)
                    imageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(()))
                    }
                }
        }
    }
}
