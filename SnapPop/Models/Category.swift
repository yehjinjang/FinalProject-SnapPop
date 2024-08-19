//
//  Category.swift
//  SnapPop
//
//  Created by 이인호 on 8/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

struct Category: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    let userId: String
    let title: String
    let alertStatus: Bool
    
    init(userId: String, title: String, alertStatus: Bool) {
        self.userId = userId
        self.title = title
        self.alertStatus = alertStatus
    }
}

// MARK: - Category Extension
extension Category {
    static func generateSampleCategories() -> [Category] {
        return [
            Category(userId: UUID().uuidString, title: "탈모 관리", alertStatus: true),
            Category(userId: UUID().uuidString, title: "팔자 주름 관리", alertStatus: false),
            Category(userId: UUID().uuidString, title: "운동 계획", alertStatus: true),
            Category(userId: UUID().uuidString, title: "식단 관리", alertStatus: false)
        ]
    }
}
