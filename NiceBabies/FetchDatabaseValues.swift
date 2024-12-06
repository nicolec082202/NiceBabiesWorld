import Foundation
import FirebaseFirestore
import FirebaseAuth

func fetchUserData(for data: String, completion: @escaping (Any?, Error?) -> Void) {
    // Get the currently authenticated user
    guard let user = Auth.auth().currentUser else {
        print("No authenticated user")
        completion(nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
        return
    }

    // Reference to Firestore
    let db = Firestore.firestore()

    // Reference to the user's document
    let userDocRef = db.collection("users").document(user.uid)

    // Fetch the document
    userDocRef.getDocument { (document, error) in
        if let error = error {
            print("Error fetching user data: \(error.localizedDescription)")
            completion(nil, error)
            return
        }

        if let document = document, document.exists {
            // Parse the requested data field
            let documentData = document.data()
            if let value = documentData?[data] {
                completion(value, nil)
            } else {
                print("Field '\(data)' not found in user document")
                completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Field '\(data)' not found"]))
            }
        } else {
            print("Document does not exist")
            completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document not found"]))
        }
    }
}
