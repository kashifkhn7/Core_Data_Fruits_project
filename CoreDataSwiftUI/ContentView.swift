//
//  ContentView.swift
//  CoreDataSwiftUI
//
//  Created by MUHAMMAD KASHIF on 05/11/2022.
//
// jump into the world of Core Data! We will first create a new Xcode project, review some of the template Core Data code that Apple provide us, and then we will customize the code for our iOS application. In this video we will implement CRUD functions by learning how to Create, Read, Update, and Delete data within Core Data. As noted in the title, this video explores how to use the @FetchRequest, which enables us to easily connect Core Data to our SwiftUI View

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)]) var fruits: FetchedResults<FruitEntity>
    
    @State var textFieldText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20){
                TextField("Add something here...", text: $textFieldText)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.black)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal,20)
                Button {
                    addItem()
                } label: {
                    Text("Submit".uppercased())
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.horizontal,20)
                }

                
                List {
                    ForEach(fruits) { fruit in
                        NavigationLink {
                            Text("Fruit is\(fruit)")
                        } label: {
                            Text(fruit.name ?? "")
                        }
                        .onTapGesture {
                            updateFruit(fruit: fruit)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Fruits")
            .navigationBarItems(
                leading: EditButton() ,
                trailing:
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
            )
        }
    }

    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name = textFieldText
            saveItem()
            textFieldText = ""
        }
    }
    private func updateFruit(fruit: FruitEntity){
        withAnimation {
            let currentName = fruit.name ?? ""
            let newname = currentName + "!"
            fruit.name = newname
            saveItem()
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { fruits[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else{ return}
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)

           saveItem()
        }
    }
    
    private func saveItem(){
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
