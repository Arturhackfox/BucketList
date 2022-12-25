//
//  EditView.swift
//  BucketList
//
//  Created by Arthur Sh on 23.12.2022.
//

import SwiftUI

struct EditView: View {
    @StateObject private var viewmodel: ViewModel
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void  // give this thing a location and expect nothing back
     
    var body: some View {
        NavigationView {
            Form {
                Section{
                    TextField("Enter name", text: $viewmodel.name)
                }
                Section {
                    TextField("Enter description", text: $viewmodel.description)
                }
                Section("NearBy") {
                    ForEach(viewmodel.pages, id: \.pageid) { page in
                        Text(page.title)
                            .font(.headline)
                        + Text(": ")
                        + Text(page.description)
                            .italic()
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar{
                Button("Save") {
                    var newLocation = viewmodel.location
                    newLocation.id = UUID()
                    newLocation.name = viewmodel.name
                    newLocation.description = viewmodel.description
                    
                    // pass that newLocation back to whoever called this
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewmodel.loadDataNearBy()
            }
        }
    }
  
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        
        //MARK: creates new @StateObject with new initital value 
        _viewmodel = StateObject(wrappedValue: ViewModel(location: location))
    }
    
}



struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
