//
//  ProfileView.swift
//  Beer
//
//  Created by Kacper Domagała on 11/05/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @State var logged = false
    @State var email = ""
    @State var password = ""
    @State var username = ""
    
    
    @State var showingRegistration = false
    @State private var errorMessage: String?
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                if(logged == false){
                    VStack{
                        Spacer()
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading)
                            .padding(.trailing)
                        Button(action: {
                            print(email)
                            print(password)
                            loginUser()
                        }, label: {
                            Text("Log In")
                        })
                        .padding()
                        .background(Color(.systemOrange))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button(action: {
                            print("Create account")
                            showingRegistration = true
                        }, label: {
                            Text("Create an account")
                                .foregroundColor(.blue)
                        })
                        .padding(.top)
                        
                        
                    }
                } else {
                    GlobeView(logged: $logged)
                }
                    
            }
            .navigationTitle(logged != false ? "Profile" : "Log in")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    if logged {
                        Button(action: logout, label: {
                            Text("Log out")
                                .foregroundColor(.blue)
                        })
                    }
                }
            }
        }
        .onAppear{
            checkAuthState()
        }
        .overlay(
            ZStack{
                if showingRegistration {
                    //Close view when clicked outside
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showingRegistration = false
                        }
                    //Registration View to make an account!
                    RegistrationView(showingRegistration: $showingRegistration, loggedIn: $logged)
                        .frame(width: 250, height: 280)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
        })
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func logout() {
            do {
                try Auth.auth().signOut()
                logged = false
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    
    private func getData(user: User?) {
        guard let user = user else {
            errorMessage = "Unexpected error: User not found."
            showingAlert = true
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.getDocument { document, error in
            if let error = error {
                errorMessage = "Failed to retrieve user data: \(error.localizedDescription)"
                showingAlert = true
                return
            }
            
            guard let document = document, document.exists else {
                errorMessage = "User data not found."
                showingAlert = true
                return
            }
            let data = document.data()
            print(data ?? "")
            username = data?["username"] as? String ?? ""
            // Extract more data here like a picture.
        }
    }

    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showingAlert = true
                return
            }
            // User logged in successfully
            guard let user = authResult?.user else {
                errorMessage = "Unexpected error: User not found."
                showingAlert = true
                return
            }
            //get username etc
            getData(user: user)
            logged = true
        }
    }
        //check previous session
    private func checkAuthState() {
        if let user = Auth.auth().currentUser {
            // User is signed in
            logged = true
            getData(user: user)
        } else {
            // No user is signed in
            logged = false
        }
    }
}

#Preview {
    ProfileView()
}
