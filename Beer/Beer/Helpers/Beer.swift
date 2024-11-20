import Foundation
import SwiftUI

struct Beer: Identifiable, Hashable, Equatable {
    let id = UUID()
    var name: String
    var image: UIImage
    var country: String
    var review: Double?
    var beerType: String
    var note: String
    init(name: String, image: UIImage, country: String, review: Double, beerType: String, note:String) {
        self.name = name
        self.image = image
        self.country = country
        self.review = review
        self.beerType = beerType
        self.note = note
    }
}
