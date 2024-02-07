//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by Adam Steinberg on 1/27/24.
//

import Foundation

// TaskDetailView.swift

import SwiftUI

struct TaskDetailView: View {
    @Binding var taskName: String
    @Binding var isCompleted: Bool
    var onSave: (String) -> Void
    @State public var DateDue = Date()
    


    var body: some View {
        
        
        Form {
            Section(header: Text("Task Details")) {
                TextField("Task Name", text: $taskName)
                Toggle("Done:", isOn: $isCompleted)
                DatePicker("Date Due:", selection: $DateDue, displayedComponents: [.date, .hourAndMinute])
            }

            Section {
                Button("Save") {
                    onSave(taskName)
                }
            }
        }
        .navigationTitle("Task Details")
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(taskName: .constant("Sample Task"), isCompleted: .constant(false), onSave: { _ in })
    }
}
