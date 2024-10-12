//
//  ContentView.swift
//  Beer
//
//  Created by Kacper Domagała on 17/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var presentDeleted = false
    @FetchRequest(sortDescriptors: []) var beerArray: FetchedResults<BeerModel>
    
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())]
    var body: some View {
        NavigationView{
            ScrollView {
                if(beerArray.isEmpty){
                    VStack{
                        Text("There are no beers in your collection.")
                            .foregroundColor(.secondary)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                }else{
                    LazyVGrid(columns: layout, content: {
                        ForEach(beerArray) { beer in
                            NavigationLink{
                                BeerView(beer:beer)
                            } label: {
                                Cell(beer: beer)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    })
                }
            }
            .navigationTitle("Your Collection")
            .toolbar{
                NavigationLink( destination: AddNew()){
                    Label("", systemImage: "plus")
                        
                }
            }
        }
        .searchable(text: $searchText){
            ForEach(beerArray){ beer in
                let beerName = beer.name ?? ""
                let beerCountry = beer.country ?? ""
                if(beerName.contains(searchText) || beerCountry.contains(searchText)){
                    Cell(beer: beer)
                }
            }
        }
    }
    
}
func forTrailingZero(_ temp: Double) -> String {
    let tempVar = String(format: "%g", temp)
    return tempVar
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
