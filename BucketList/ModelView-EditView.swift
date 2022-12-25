//
//  ModelView-EditView.swift
//  BucketList
//
//  Created by Arthur Sh on 25.12.2022.
//

import Foundation

extension EditView {
    @MainActor class ViewModel: ObservableObject {
        enum LoadingStates {
            case loading, loaded, failed
        }

        @Published  var name: String
        @Published  var description: String
        
        @Published  var currentLoadingState = LoadingStates.loading
        @Published  var pages = [Page]()

        var location: Location
        
        //MARK: using location passed in to initialize name and description properties and stashes away in location
        init(location: Location) {
            name = location.name
            description = location.description
            self.location = location
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
        
    }
}
