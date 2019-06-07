struct ResponseData: Decodable {
    var tracks = [Tracks].self
}

struct Tracks {
    var title: String
    var mediaUrl: String
    var imageUrl: String
    var duration: Int
}

func loadJson(filename Filename: String) -> [Tracks]? {
    
    let mainBundle = Bundle.main
    
    lf let url = NSBundle.main.url
}
