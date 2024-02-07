// ContentView.swift
import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = TaskManagerViewModel()  // Assuming TaskManagerViewModel is an ObservableObject
    @State private var showFinishedTasks = false
    @State var tasks: [Task] = []
    @State private var editMode: EditMode = .inactive
    @State public var DateDue = Date()
    @State private var taskName = ""
    @State private var tasksBySpace: [String: [String]] = [:]
    @State private var isAddingSectionVisible = false
    @State private var selectedSpace: String?

    var body: some View {
        NavigationView {
            VStack {
                Text("Task Manager App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                HStack {
                    TextField("Enter task", text: $viewModel.taskName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Add Task") {
                        if let selectedSpace = selectedSpace {
                            viewModel.addTaskToSpace(taskName: taskName, spaceName: "")
                        } else {
                            viewModel.addTask(taskName: viewModel.taskName)
                        }
                    }
                    .padding()
                }

                // Display spaces and tasks
                List {
                    // List spaces
                    ForEach(Array(tasksBySpace.keys.sorted()), id: \.self) { space in
                        Section(header: Text(space)) {
                            // List tasks within each space
                            ForEach(tasksBySpace[space] ?? [], id: \.self) { task in
                                NavigationLink(destination: TaskDetailView(
                                    taskName: $viewModel.tasks[index].taskName,
                                    isCompleted: $viewModel.tasks[index].isCompleted,
                                    onSave: { newName in
                                        viewModel.editTaskName(at: index, newName: newName)
                                    }
                                )) {
                                    HStack {
                                        Button(action: {
                                            viewModel.toggleTaskCompletion(at: index)
                                        }) {
                                            Image(systemName: viewModel.tasks[index].isCompleted ? "checkmark.square" : "square")
                                        }
                                        .foregroundColor(viewModel.tasks[index].isCompleted ? .green : .primary)
                                        .padding(EdgeInsets())

                                        
                                        GeometryReader { geometry in
                                            Text(viewModel.tasks[index].taskName)
                                                .font(.system(size: fontSize(for: taskName, in: geometry.size)))
                                                .minimumScaleFactor(0.5)
                                                .lineLimit(1)
                                                .frame(width: geometry.size.width, alignment: .leading)
                                                .padding()
                                        }

                                        Toggle("", isOn: $viewModel.tasks[index].isCompleted)
                                            .labelsHidden()
                                            .toggleStyle(SliderToggleStyle())
                                    }
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteTask)
            }
            .navigationBarItems(leading: menuButton, trailing: editButton)
            .navigationBarItems(trailing: addSpace)
            .navigationBarTitle("Active Tasks", displayMode: .inline)
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(viewModel)
    }

    // ... rest of the code
    
    private var editButton: some View {
           Button(action: {
               
               if editMode == .active {
                   editMode = .inactive
               } else {
                   editMode = .active
               }
           }) {
               Text(editMode == .active ? "Done" : "Edit")
           }
       }

    private var addSpace: some View {
        Button("Add Space") {
            isAddingSectionVisible.toggle()
        }
    }

    private var menuButton: some View {
        Menu {
            Button("Finished Tasks") {
                showFinishedTasks = true
            }
        } label: {
            Image(systemName: "line.horizontal.3")
                .imageScale(.large)
        }
    }

    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: DateDue)
    }
    
    private func fontSize(for text: String, in size: CGSize) -> CGFloat {
            // Adjust the logic based on your requirements
            let maxLength = 10 // Maximum length before shrinking the font
            let scaleFactor: CGFloat = 1 // Adjust this value as needed

            let effectiveLength = min(text.count, maxLength)
            let scaleFactorApplied = CGFloat(maxLength - effectiveLength) * scaleFactor

            return max(12, 28 - scaleFactorApplied) // Minimum font size is 12
        }

        private var fontSize: CGFloat {
            return fontSize(for: viewModel.taskName, in: CGSize(width: 100, height: 20)) // Adjust size as needed
        }
    
    func addTask(taskName: String) {
            // Create a new task using the provided taskName
        let newTask = Task(taskName: "Your Task Name", isCompleted: false)

            // Add the new task to your tasks array
            tasks.append(newTask)
            
            // Clear the taskName for the next input
            self.taskName = ""
        }

    
   
}

struct SliderToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Toggle("", isOn: configuration.$isOn)
            .toggleStyle(SwitchToggleStyle(tint: configuration.isOn ? .green : .red))
            .labelsHidden()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TaskManagerViewModel())
    }
}


