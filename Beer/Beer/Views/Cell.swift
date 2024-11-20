import SwiftUI

struct Cell: View {
    @ObservedObject var beer: BeerModel
    
    @State private var showdeleteAlert = false
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        ZStack {
            VStack {
                Image(uiImage: UIImage(data: beer.image ?? Data()) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding([.horizontal, .top])
                    .frame(maxWidth: .infinity)
                
                Text(beer.name ?? "")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .trailing) {
                    StarsView(rating: (beer.review), maxRating: 5.0)
                }
                
                HStack {
                    NavigationLink(destination: EditView(beer: beer)){
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                    Button(action: {
                        showdeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .alert("Do you want to delete the element ?", isPresented: $showdeleteAlert) {
                        Button (role: .destructive) {
                            moc.delete(beer)
                            try? moc.save()
                        } label: {
                            Text("Delete")
                                .foregroundColor(.red)
                        }
                        Button("Cancel", role: .cancel){}
                    }
                    
                    ZStack {
                        Rectangle()
                            .cornerRadius(10)
                            .frame(width: 100, height: 40)
                            .foregroundColor(beerColor(beerType: beer.type ?? "Lager"))
                        
                        Text(beer.type ?? "")
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Apply shadow to the whole cell
        }
    }
}

func beerColor(beerType: String) -> Color {
    switch beerType{
        case "Lager":
            return Color(red: 255/255, green: 178/255, blue: 8/255)
        case "Blond ALE":
            return Color(red: 255/255, green: 220/255, blue: 8/255)
        case "Pale ALE/IPA":
            return Color(red: 251/255, green: 222/255, blue: 165/255)
        case "Amber ALE":
            return Color(red: 255/255, green: 106/255, blue: 56/255)
        case "Red ALE":
            return Color(red: 213/255, green: 32/255, blue: 39/255)
        case "Brown ALE":
            return Color(red: 167/255, green: 66/255, blue: 38/255)
        case "Porter":
            return Color(red: 110/255, green: 43/255, blue: 17/255)
        case "Stout":
            return Color(red: 32/255, green: 14/255, blue: 12/255)
        default:
            return Color(.white)
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(beer: .init())
    }
}
