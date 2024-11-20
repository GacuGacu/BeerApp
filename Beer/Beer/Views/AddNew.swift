import SwiftUI

struct AddNew: View {
    @State var name = ""
    @State var country = ""
    @State var review:Int?
    @State var id = UUID()
    @State var notes = ""
    @State var BeerTypeArray = ["Lager","Blond ALE","Pale ALE/IPA","Amber ALE","Red ALE","Brown ALE",
                           "Porter","Stout"]
    @State private var showSavedAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showProblemAlert = false
    @State private var presentSheet = false
    @State private var showImagePicker = false
    @State private var sourceType:UIImagePickerController.SourceType = .camera
    @State private var image:UIImage?
    @State var beerType = "Lager"
    @State private var flavorRating: Int?
    @State private var bitterness: Int?
    @State private var frutiness: Int?
    @State private var sweetness: Int?
    @Environment(\.managedObjectContext) var moc
    
    
    
    var body: some View {
            ScrollView{
                VStack{
                    Image(uiImage: image ?? UIImage(imageLiteralResourceName: "basic-image.png"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .foregroundColor(.blue)
                        .padding(20)

                    Button("Add a picture"){
                        self.presentSheet = true
                    }
                    .padding()
                    .background(Color(.systemOrange))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .actionSheet(isPresented: $presentSheet) {
                        ActionSheet(title: Text("Select photo"),message: Text("Pick a picture from your library or take a new one!"), buttons: [
                            .default(Text("Photo Library")){
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            },
                            .default(Text("Take a picture")){
                                AppDelegate.orientationLock = .portrait
                                self.showImagePicker = true
                                
                                self.sourceType = .camera
                                
                            },
                            .cancel()
                        ])
                    }
                    
                    VStack(alignment: .leading){
                        Text("Name")
                            .font(.title3)
                            .foregroundColor(.black)
                        TextField("...", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        Text("Country")
                            .font(.title3)
                            .foregroundColor(.black)
                        TextField("...", text: $country)
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
                        RatingWindow(flavourRating: $flavorRating, bitterness: $bitterness, frutiness: $frutiness, sweetness: $sweetness)
                            .padding()
                        VStack{
                            Text("Additional Notes:")
                                .font(.title3)
                            TextField("Enter text", text: $notes,axis: .vertical)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(5...10)
                        }
                        
                        HStack{
                            Spacer()
                            Button("Save"){
                                if(name != "" && country != ""){
                                    review = ((flavorRating ?? 0) + (bitterness ?? 0)  + (sweetness ?? 0) + (frutiness ?? 0))
                                    
                                    let newBeer = BeerModel(context: moc)
                                    newBeer.id = UUID()
                                    newBeer.name = name
                                    newBeer.country = country
                                    newBeer.type = beerType
                                    newBeer.review = Double((review ?? 0)/4)
                                    newBeer.note = notes
                                    let jpegImageData = image?.jpegData(compressionQuality: 1.0)
                                    newBeer.image = jpegImageData
                                    try? moc.save()
                                    showSavedAlert = true
                                } else {
                                    showProblemAlert = true
                                }
                            }
                            .alert("Saved Correctly", isPresented: $showSavedAlert){
                                Button("OK", role: .cancel) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                            .alert("Something went wrong", isPresented: $showProblemAlert){
                                Button("OK", role: .cancel) { }
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
        .sheet(isPresented:$showImagePicker){
            ImagePicker(image: $image,isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
    }
        
}

struct AddNew_Previews: PreviewProvider {
    static var previews: some View {
        AddNew()
    }
}
