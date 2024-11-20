import SwiftUI

struct BeerView: View {
    @ObservedObject var beer: BeerModel
    @Environment(\.managedObjectContext) var moc
    @State private var code = ""
    var body: some View {
            ScrollView{
                VStack{
                    Image(uiImage: UIImage(data: beer.image ?? Data()) ?? UIImage(imageLiteralResourceName: "basic-image.png"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .foregroundColor(.blue)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                    HStack{
                        Text("\(beer.country!)")
                            .font(.title2)
                        Text(flag(country: countryCodes[beer.country!] ?? ""))
                            .font(.title2)
                    }
                    HStack(alignment: .firstTextBaseline){
                        StarsView(rating: (beer.review), maxRating: 5.0)
                        Text("\(beer.review, specifier: "%.1f")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                }
                VStack{
                    if(beer.note != ""){
                        Text("Notes:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        Text(beer.note ?? "No notes for this beer.")
                            .frame(maxWidth: .infinity, alignment: .leading )
                            .padding(.leading)
                            .padding(.trailing)
                            .multilineTextAlignment(.leading)


                    }
                    Text("Additional Information:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,5)
                        .padding(.leading)
                    //TODO: The database will have additional info, such as flavor, brewery etc these could be added here, can also be price for the beer.
                }
                //TODO: Add the floating button to make purchases
               
            }
        .navigationTitle(beer.name!)
    }
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}

import SwiftUI

#Preview {
    BeerView(beer: .init())
}
