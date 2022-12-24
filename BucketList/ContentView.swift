//
//  ContentView.swift
//  BucketList
//
//  Created by Arthur Sh on 22.12.2022.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    @State private var locations = [Location]()
    
    @State private var selectedPlace: Location?
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack{
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text(location.name)
                            .fixedSize() // gives full size no matter what
                    }
                    .onTapGesture {
                        //transfer currently tapped location to selected one
                        selectedPlace = location
                    }
                }
            }
                .ignoresSafeArea()
    
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 35, height: 35)
            
            
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    
                    Button{
                        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                        
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(.black.opacity(0.75))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
            
        }
        .sheet(item: $selectedPlace) { place in
            EditView(location: place) { newLocation in
                if let index = locations.firstIndex(of: place) {
                    // it will pass new updated value and replace the old one
                    locations[index] = newLocation
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
