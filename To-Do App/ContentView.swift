//
//  ContentView.swift
//  To-Do App
//
//  Created by Uroš Katanić on 10.1.22..
//

import SwiftUI

enum Prirorited:String, Identifiable, CaseIterable{
    var id: UUID{
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "Height"
}

extension Prirorited{
    var title: String{
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

private func styleForPriority(_ value: String) -> Color {
    let priority = Prirorited(rawValue: value)
    
    switch priority {
        case .low:
            return Color.green
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        default:
            return Color.black
    }
}


struct ContentView: View {
    @State private var title: String = ""
    @State private var selectedPriority: Prirorited = .medium
    @State private var showingAlert = false
    @Environment (\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dataCreated", ascending: false)]) private var allTasks: FetchedResults<Task>
    
    private func saveTask(){
        do {
            let task = Task(context: viewContext)
            task.tile = title
            task.priritiy = selectedPriority.rawValue
            task.dataCreated = Date()
            try viewContext.save()
            
            
            }
        catch{
                print(error.localizedDescription)
            }
    }
    
    private func updateTask(_ task: Task){
        task.isFavorite = !task.isFavorite
        
        do{
            try viewContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = allTasks[index]
            viewContext.delete(task)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
       
            VStack{
                VStack{
                    Text("All Tasks")
                        .font(.title)
                }
                TextField("Entre title", text: $title)
                    .textFieldStyle(.roundedBorder)
                Picker("Prirorite", selection: $selectedPriority){
                    ForEach(Prirorited.allCases){
                        prioriti in
                        Text(prioriti.title).tag(prioriti)
                    }
                }.pickerStyle(.segmented)
    
                VStack{
                    List{
                        ForEach(allTasks) { task in
                                HStack{
                                    Circle()
                                      .fill(styleForPriority(task.priritiy!))
                                      .frame(width: 15, height: 15)
                                    Spacer().frame(width: 20)
                                    Text(task.tile ?? "")
                                    
                                    Spacer()
                                    Image(systemName: task.isFavorite ? "heart.fill": "heart")
                                        .foregroundColor(.red)
                                        .onTapGesture {
                                            updateTask(task)
                                        }
                                }
                        }.onDelete(perform: deleteTask)
                    }
                    
                }

                Spacer()
                Button("Save"){
                    if(self.title == ""){
                        print("empty")
                        showingAlert=true
            
                    }
                    else{
                        saveTask()
                        self.title = ""
                    }
                }.alert("Title can't be empty", isPresented: $showingAlert ){Button("OK"){}}
                
                .padding(10)
                .frame(maxWidth: .infinity)
                
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
