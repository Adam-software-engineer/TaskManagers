// TaskManagerViewModel.swift

import SwiftUI

class TaskManagerViewModel: ObservableObject {
    @Published var taskName = ""
    @Published var tasks: [Task] = []
    @Published var finishedTasks: [Task] = []
    @State private var tasksBySpace: [String: [String]] = [:]

    

    init() {
        // Load saved tasks and finished tasks from UserDefaults
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks") {
            let decoder = JSONDecoder()
            if let decodedTasks = try? decoder.decode([Task].self, from: savedTasks) {
                tasks = decodedTasks
            }
        }

        if let savedFinishedTasks = UserDefaults.standard.data(forKey: "finishedTasks") {
            let decoder = JSONDecoder()
            if let decodedFinishedTasks = try? decoder.decode([Task].self, from: savedFinishedTasks) {
                finishedTasks = decodedFinishedTasks
            }
        }
    }

    func addTask() {
        tasks.append(Task(taskName: taskName, isCompleted: false))
        taskName = ""
        saveTasks()
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    func toggleTaskCompletion(at index: Int) {
        tasks[index].isCompleted.toggle()
    }

    func deleteFinishedTask(at offsets: IndexSet) {
        finishedTasks.remove(atOffsets: offsets)
        saveFinishedTasks()
    }

    func editTaskName(at index: Int, newName: String) {
        tasks[index].taskName = newName
        saveTasks()
    }

    public func saveTasks() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    public func saveFinishedTasks() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(finishedTasks) {
            UserDefaults.standard.set(encoded, forKey: "finishedTasks")
        }
    }
    
    func addTaskToSpace(taskName: String, spaceName: String) {
            // Check if the space already exists
        if var existingSpaceTasks = tasksBySpace[spaceName] {
            viewModel.addTaskToSpace(taskName: taskName, spaceName: "")

            existingSpaceTasks.append(taskName)
            tasksBySpace[spaceName] = existingSpaceTasks
        } else {
            // If the space doesn't exist, create a new space
            tasksBySpace[spaceName] = [taskName]
        }

            // Now, you can add the task to your main tasks list or handle it based on your requirements
            addTask(taskName: taskName)
        }
}


