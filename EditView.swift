//
//  EditView.swift
//  BucketList
//
//  Created by Arthur Sh on 23.12.2022.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String
    @State private var description: String
    
    var location: Location
    
    var onSave: (Location) -> Void  // give this thing a location and expect nothing back
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    TextField("Enter name", text: $name)
                }
                Section {
                    TextField("Enter description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar{
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID() 
                    newLocation.name = name
                    newLocation.description = description
                    
                    // pass that newLocation back to whoever called this
                    onSave(newLocation)
                    dismiss()
                }
        }
        }
    }
    
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}



struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
