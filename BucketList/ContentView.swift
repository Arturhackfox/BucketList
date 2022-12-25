//
//  ContentView.swift
//  BucketList
//
//  Created by Arthur Sh on 22.12.2022.
//

import MapKit
import SwiftUI

struct ContentView: View {
   
    @StateObject private var viewmodel = ViewModel()
    
    var body: some View {
        if viewmodel.isUnlocked {
            ZStack{
                Map(coordinateRegion: $viewmodel.mapRegion, annotationItems: viewmodel.locations) { location in
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
                            viewmodel.selectedPlace = location
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
                            viewmodel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding(20)
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
                
            }
            .sheet(item: $viewmodel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewmodel.update(location: newLocation)
                }
            }
        } else {
            Button {
                viewmodel.authenticate()
            } label: {
                Text("Authenticate")
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(12)
            }
            .alert(viewmodel.alertTitle, isPresented: $viewmodel.isAlertShowing) {
                Button("Ok") { }
            } message: {
                Text(viewmodel.alertMessage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
