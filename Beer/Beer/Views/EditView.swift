import SwiftUI

struct EditView: View {
    @ObservedObject var beer:BeerModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    @State var image: Data?
    @State var country = ""
    @State var review:Double?
    @State var id = UUID()
    @State var BeerTypeArray = ["Lager","Blond ALE","Pale ALE/IPA","Amber ALE","Red ALE","Brown ALE",
                           "Porter","Stout"]
    @State private var showSavedAlert = false
    @State var beerType = "Lager"
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    VStack(alignment: .leading){
                        Text("Name")
                            .font(.title3)
                            .foregroundColor(.black)
                        TextField("\(beer.name ?? "")", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Country")
                            .font(.title3)
                            .foregroundColor(.black)
                        TextField("\(beer.country ?? "")", text: $country)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Select Type")
                            .font(.title3)
                            .foregroundColor(.black)
                        
                        Picker("Select Type", selection: $beerType){
                            ForEach(BeerTypeArray, id:\.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        .labelsHidden()
                        HStack{
                            Spacer()
                            Button("Save"){
                                image = beer.image
                                review = beer.review
                                moc.delete(beer)
                                let newBeer = BeerModel(context: moc)
                                newBeer.id = UUID()
                                newBeer.name = name
                                newBeer.country = country
                                newBeer.type = beerType
                                newBeer.review = Double((review ?? 0)/3)
                                newBeer.image = image
                                newBeer.review = review ?? 0.0
                                try? moc.save()
                                showSavedAlert = true
                            }
                            .alert("Saved Correctly", isPresented: $showSavedAlert){
                                
                                Button("OK", role: .cancel) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                            .padding()
                            .background(Color(.systemOrange))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(beer: .init())
    }
}
