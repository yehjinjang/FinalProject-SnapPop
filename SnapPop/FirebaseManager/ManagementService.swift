//
//  ManagementService.swift
//  SnapPop
//
//  Created by 이인호 on 8/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class ManagementService {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    let dateFormatter = DateFormatter()
    
    func saveManagement(categoryId: String, management: Management, completion: @escaping (Result<Management, Error>) -> Void) {
        let documentRef = db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Managements")
            .document()
        
        var managementWithID = management
        managementWithID.id = documentRef.documentID
        
        do {
            try documentRef.setData(from: managementWithID) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(managementWithID))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadManagements(categoryId: String, completion: @escaping (Result<[Management], Error>) -> Void) {
        db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Managements")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = querySnapshot?.documents else { return }
                
                let managements = documents.compactMap { document in
                    try? document.data(as: Management.self)
                }
                
                completion(.success(managements))
            }
    }
    
    func updateManagement(categoryId: String, managementId: String, updatedManagement: Management, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("Users")
                .document(AuthViewModel.shared.currentUser?.uid ?? "")
                .collection("Categories")
                .document(categoryId)
                .collection("Managements")
                .document(managementId)
                .setData(from: updatedManagement, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateCompletion(categoryId: String, managementId: String, date: Date, isCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Managements")
            .document(managementId)
            .updateData(["completions.\(dateString)": isCompleted ? 1 : 0]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func deleteManagement(categoryId: String, managementId: String, completion: @escaping (Error?) -> Void) {
        db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Managements")
            .document(managementId)
            .delete { error in
                if let error = error {
                    completion(error)
                }
            }
    }
    
    func addManagementException(categoryId: String, managementId: String, exceptionDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: exceptionDate)

        db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Managements")
            .document(managementId)
            .updateData([
                "exceptionDates": FieldValue.arrayUnion([dateString])
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func getManagementExceptions(categoryId: String, managementId: String, completion: @escaping (Result<[Date], Error>) -> Void) {
        db.collection("Users")
            .document(AuthViewModel.shared.currentUser?.uid ?? "")
            .collection("Categories")
            .document(categoryId)
            .collection("Managements")
            .document(managementId)
            .getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = document, document.exists else {
                    completion(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Management document not found"])))
                    return
                }
                
                let exceptionDates = document.data()?["exceptionDates"] as? [String] ?? []
                let dates = exceptionDates.compactMap { dateString -> Date? in
                    self.dateFormatter.date(from: dateString)
                }
                
                completion(.success(dates))
            }
    }
}