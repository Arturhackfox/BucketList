//
//  EditView.swift
//  BucketList
//
//  Created by Arthur Sh on 23.12.2022.
//

import SwiftUI

struct EditView: View {
    enum LoadingStates {
        case loading, loaded, failed
    }
    
    
    @Environment(\.dismiss) var dismiss
    @State private var name: String
    @State private var description: String
    
    @State private var currentLoadingState = LoadingStates.loading
    @State private var pages = [Page]()
    
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
                Section("NearBy") {
                    ForEach(pages, id: \.pageid) { page in
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
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    // pass that newLocation back to whoever called this
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                 await loadDataNearBy()
            }
        }
    }
    
    //MARK: Downloads data from Wikipedia 
    func loadDataNearBy() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        if let url = URL(string: urlString) {
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                
                currentLoadingState = .loaded
            } catch {
                currentLoadingState = .failed
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
