// Task.swift

import Foundation

struct Task: Identifiable, Hashable, Codable {
    var id = UUID()
    var taskName: String
    var isCompleted: Bool
}
