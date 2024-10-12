//
//  RegistrationView.swift
//  Beer
//
//  Created by Kacper Domagała on 20/05/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct RegistrationView: View {
    @Binding var showingRegistration: Bool
    @Binding var loggedIn: Bool
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    var body: some View {
        VStack{
            Text("Create an account!")
                .font(.headline)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading,2)
                .padding(.trailing,2)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading,2)
                .padding(.trailing,2)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading,2)
                .padding(.trailing,2)
            SecureField("Confirm password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading,2)
                .padding(.trailing,2)
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            Button(action: {registerUser()}) {
                Text("Register")
                    .padding()
                    .cornerRadius(10)
                    .foregroundColor(.blue)
            }
            
        }
        .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
    }
    private func registerUser() {
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showingAlert = true
            return
        }
        print("Creating a user.")
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
                return
            }
            
            guard let user = authResult?.user else {
                alertMessage = "User creation failed."
                showingAlert = true
                return
            }
            
            // Save additional user data to Firestore
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "username": username,
                "email": email,
                //more fields here
            ]) { error in
                if let error = error {
                    alertMessage = "Failed to save user data: \(error.localizedDescription)"
                    showingAlert = true
                    return
                }
            }
            showingRegistration = false
        }
    }
}

#Preview {
    RegistrationView(showingRegistration: .constant(false), loggedIn: .constant(false))
}
