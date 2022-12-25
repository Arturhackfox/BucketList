//
//  ViewModel-ContentView.swift
//  BucketList
//
//  Created by Arthur Sh on 25.12.2022.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published  var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        @Published private(set) var locations: [Location]
        @Published  var selectedPlace: Location?
        
        @Published var isUnlocked = false
        
        let savePath = FileManager.directoryPath.appendingPathComponent("SavedPlaces")
        
        @Published var isAlertShowing = false
        @Published var alertMessage = ""
        @Published var alertTitle = ""
        
        //MARK: ON the launch reads data from documents directory 
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)

            } catch {
               locations = []
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "We need authentication to display your places."
                
                //MARK: EVALUATE -> Scan
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in  // <- Thats the results of evaluate
                    
                    if success {
                        //MARK: Evaluate results success or failure won't run on the main actor, they will run on the Background task, to fix -> @MainActor in 
                        Task{ @MainActor in
                            self.isUnlocked = true    // <- Whole closure runs on the MainActor
                        }
                    } else {
                        // failed to authenticate
                        Task { @MainActor in
                            self.isAlertShowing = true
                            self.alertTitle = "Failed to authenticate"
                            self.alertMessage = "try again"
                        }
                    }
                }
            } else {
                // user don't have biometrics on his phone
                Task { @MainActor in {
                    self.isAlertShowing = true
                    self.alertTitle = "Seems like you don't have biometric authentication"
                    self.alertMessage = "try another unlock option"
                }
                }
            }
        }
        
        //MARK: Saves to a users document directory (can take as much storage as i want)
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Failed to save")
            }
            
            
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                // it will pass new updated value and replace the old one
                locations[index] = location
                save()
            }
        }
        
    }
}
