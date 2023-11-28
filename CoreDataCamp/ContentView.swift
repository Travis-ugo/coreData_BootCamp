//
//  ContentView.swift
//  CoreDataCamp
//
//  Created by Travis Okonicha on 03/08/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
    
    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    private var fruits: FetchedResults<FruitEntity>
    
    @State var textField: String = ""
    @State var  fruitET: FruitEntity? = nil

    var body: some View {
        NavigationView {
            VStack {
                TextField("Type a new fruit", text: $textField)
                    .padding()
                    .background(Color.gray.brightness(0.3).cornerRadius(10))
                    .padding(.horizontal)

                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
//                                updateItems(fruit: fruit)
                                fruitET = fruit
                                textField = fruit.name ?? ""
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button( action: {
                            guard let fruitETs = fruitET else { return }
                            fruitETs.name = textField
                            updateItems(fruit: fruitETs)
                            textField = ""
                        }) {
                            Label("Add Item", systemImage: "minus")
                        }
                    }
                    
                    ToolbarItem {
                        Button(action: {
                            saveNewfruit()
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    
                }
                .navigationTitle("CoreBootBitch")
                Text("Select an item")
            }
        }
    }

    
    private func saveNewfruit() {
        if !textField.isEmpty {
            addItem(name: textField)
            textField = ""
        }
    }
    
    private func addItem(name: String) {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name = name
            saveFruit()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { fruits[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else { return }
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            saveFruit()
        }
    }
    
    private func updateItems(fruit: FruitEntity) {
        withAnimation {
            let currentName = fruit.name ?? ""
            let newName = currentName
            
            fruit.name = newName
            saveFruit()
        }
    }
    
    
    private func saveFruit() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
