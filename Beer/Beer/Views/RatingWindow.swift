import SwiftUI

struct RatingWindow: View {
    
    @Binding var flavourRating : Int?
    @Binding var bitterness: Int?
    @Binding var frutiness: Int?
    @Binding var sweetness: Int?
    
    private func starTypeFR(index:Int) -> String {
        if let rating = self.flavourRating {
            if(index <= rating){
                return "star.fill"
            } else {
                return "star"
            }
        } else {
            return "star"
        }
    }
    private func starTypeB(index:Int) -> String {
        if let rating = self.bitterness {
            if(index <= rating){
                return "star.fill"
            } else {
                return "star"
            }
        } else {
            return "star"
        }
    }
    private func starTypeF(index:Int) -> String {
        if let rating = self.frutiness {
            if(index <= rating){
                return "star.fill"
            } else {
                return "star"
            }
        } else {
            return "star"
        }
    }
    private func starTypeS(index:Int) -> String {
        if let rating = self.sweetness{
            if(index <= rating){
                return "star.fill"
            } else {
                return "star"
            }
        } else {
            return "star"
        }
    }
    
    
    
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Flavour Rating")
                    .font(.title3)
                    .padding(.trailing)
                
                HStack{
                    ForEach(1...5, id: \.self){ index in
                        Image(systemName: self.starTypeFR(index: index))
                            .foregroundColor(.orange)
                            .onTapGesture {
                                flavourRating = index
                            }
                    }
                }
            }
            .padding(.bottom, 0.2)
            HStack{
                Text("Bitterness Rating")
                    .font(.title3)
                    .padding(.trailing)
                HStack{
                    ForEach(1...5, id: \.self){ index in
                        Image(systemName: self.starTypeB(index: index))
                            .foregroundColor(.orange)
                            .onTapGesture {
                                bitterness = index
                            }
                        
                    }
                }
            }
            .padding(.bottom, 0.2)
            HStack{
                Text("Frutiness Rating")
                    .font(.title3)
                    .padding(.trailing)
                HStack{
                    ForEach(1...5, id: \.self){ index in
                        Image(systemName: self.starTypeF(index: index))
                            .foregroundColor(.orange)
                            .onTapGesture {
                                frutiness = index
                            }
                    }
                }
            }
            .padding(.bottom, 0.2)
            HStack{
                Text("Sweetness Rating")
                    .font(.title3)
                    .padding(.trailing)
                HStack{
                    ForEach(1...5, id: \.self){ index in
                        Image(systemName: self.starTypeS(index: index))
                            .foregroundColor(.orange)
                            .onTapGesture {
                                sweetness = index
                            }
                    }
                }
            }
            .padding(.bottom, 0.2)
        }
    }
}

struct RatingWindow_Previews: PreviewProvider {
    static var previews: some View {
        RatingWindow(flavourRating: .constant(0), bitterness: .constant(0), frutiness: .constant(0), sweetness: .constant(0))
    }
}
