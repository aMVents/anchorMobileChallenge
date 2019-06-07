//ANCHOR MOBILE CHALLENGE:
// GOAL: build an app that retrieves a list of audios from a server and present to the user for playback.
//  Created by Alwin on 6/6/19.
//  Copyright © 2019 RS Productions. All rights reserved.


//MVP:
// 1) retrive data from given endpoint URL "https://s3-us-west-2.amazonaws.com/anchor-website/challenges/bsb.json"
// 2) preset data to user as a list of items as a Table
// 3) each cell should display title adn toggle-able play/pause button
// 4) user has to be able to tap on item to listen to playback
// 5) if user taps on a song and audio is already playing, then other audio should stop
// 6) when audio finishes playing, it should go to the next track
// 7) WRITE SOME TESTS

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK : Reading the JSON from a URL

    struct TracksJson: Decodable {
        let tracks: [Tracks]
    }
    
    struct Tracks: Decodable {

        let title: String?
        let mediaUrl: String?
        let imageUrl: String?
        let duration: Int?
    }
    
    let dataArray: NSArray = ["First", "Second", "Third"]
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let jsonUrlString = "https://s3-us-west-2.amazonaws.com/anchor-website/challenges/bsb.json"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                
                let tracksJson = try JSONDecoder().decode(TracksJson.self, from: data)
                print(tracksJson.tracks)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }

            }.resume()
        
        //MARK : Displaying the Tableview 
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight-barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("I'm selecting \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(dataArray[indexPath.row])"
        return cell
    }
}

