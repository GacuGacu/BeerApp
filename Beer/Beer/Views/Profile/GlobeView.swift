//
//  GlobeView.swift
//  Beer
//
//  Created by Kacper Domagała on 20/05/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct GlobeView: View {
    @Binding var logged: Bool
    @State var showDeleteAlert = false
    
    var body: some View {
        ScrollView{
            VStack{
                //MapView()
                Spacer()
                Button {
                    showDeleteAlert = true
                } label: {
                    Text("Delete account")
                        .foregroundColor(.red)
                        .padding()
                }
            }

        }
        .alert("Do you want to delete your account?", isPresented: $showDeleteAlert) {
            Button (role: .destructive) {
                deleteAccount()
            } label: {
                Text("Confirm")
                    .foregroundColor(.red)
            }
            Button("Cancel", role: .cancel){}
        }
    }
    
    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            print("No user signed in.")
            return
        }
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(user.uid)
        userDocRef.delete { error in
            if let error = error {
                print("Error deleting user data from Firestore: \(error.localizedDescription)")
            } else {
                user.delete { error in
                    if let error = error {
                        print("Error deleting user account: \(error.localizedDescription)")
                    } else {
                        print("User account deleted successfully.")
                    }
                }
            }
        }
    logged = false
    }
        
}

#Preview {
    GlobeView(logged: .constant(true))
}
