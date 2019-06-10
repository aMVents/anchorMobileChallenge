import UIKit
import Foundation

//MARK : Decoding JSON using Codable
struct TracksJson: Codable {
    let tracks: [Tracks]
}

struct Tracks: Codable {
    
    let title: String
    let mediaUrl: String
    let imageUrl: String
    let duration: Int
}
