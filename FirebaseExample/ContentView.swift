//
//  ContentView.swift
//  FirebaseExample
//
//  Created by Nien Lam on 10/20/21.
//

import SwiftUI
import Firebase

// Data to store in the Firebase.
struct MyData: Codable {
    let timeStamp: String
}


struct ContentView: View {
    var body: some View {
        Button("Add Data") {
            // Create reference with unique id.
            let ref = Database.database().reference(withPath: UUID().uuidString)
            
            // Get current time.
            let timeStamp = Date().formatted(date: .numeric, time: .standard)
            
            // Create a new data object.
            let myData = MyData(timeStamp: timeStamp)

            // Encode object to JSON.
            let jsonEncoder = JSONEncoder()
            let jsonData    = try! jsonEncoder.encode(myData)
            let json        = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // Write to database.
            ref.setValue(json)
        }
        .onAppear {
            // Firebase setup.
            FirebaseApp.configure()
            
            // TODO: Added url.
            // NOTE: Url is visible in Firebase console for project.
            let url = "https://"

            let rootRef = Database.database(url: url).reference()
            
            // Observe whenever a record is added.
            rootRef.observe(.childAdded, with: { snapshot in
                
                // Convert data into JSON.
                let dict = snapshot.value as? [String : AnyObject] ?? [:]
                let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: [])
                
                // Map JSON to your data structure.
                let decoder = JSONDecoder()
                if let myData = try? decoder.decode(MyData.self, from: jsonData) {
                    // Print data.
                    print("📝:", myData)
                } else {
                    print("❌ Error mapping data.")
                    return
                }
            
            })
        }
    }
}
