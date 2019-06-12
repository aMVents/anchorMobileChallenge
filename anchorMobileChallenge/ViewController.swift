//ANCHOR MOBILE CHALLENGE:
// GOAL: build an app that retrieves a list of audios from a server and present to the user for playback.
//  Created by Alwin on 6/6/19.
//  Copyright © 2019 RS Productions. All rights reserved.

//MVP:
// 1) retrive data from given endpoint URL "https://s3-us-west-2.amazonaws.com/anchor-website/challenges/bsb.json"
// 2) preset data to user as a list of items as a Table
// 3) each cell should display title and toggle-able PLAY/PAUSE button
// 4) user has to be able to tap on item to listen to playback
// 5) if user taps on a song and audio is already playing, then other audio should stop
// 6) when audio finishes playing, it should go to the next track
// 7) WRITE SOME TESTS

//BUGS:
// 1) rotating the device does not refresh UITableview


import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myTableView: UITableView!
    private var tracks = [Tracks]()
    var playerLayer : AVPlayerLayer?
    var audioPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: downloading JSON data
        let jsonUrlString = "https://s3-us-west-2.amazonaws.com/anchor-website/challenges/bsb.json"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            do {
                let downloadedTracks = try JSONDecoder().decode(TracksJson.self, from: data)
                self.tracks = downloadedTracks.tracks
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
                //check to see if JSON data downloaded correctly
                print(downloadedTracks.tracks)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
        
        //MARK: Displaying the Tableview
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight-barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TracksCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        myTableView.reloadData()
    }
    
    func play(songURL: String) {
        
        guard let url = URL.init(string: songURL) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        audioPlayer = AVPlayer.init(playerItem: playerItem)
        
        audioPlayer?.play()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        play(songURL: tracks[indexPath.row].mediaUrl)
        print("I'm selecting \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TracksCell", for: indexPath as IndexPath)
        
        if let storedImage = URL(string: tracks[indexPath.row].imageUrl) {
                    let data = try? Data(contentsOf: storedImage)
                    if let data = data {
                        let image = UIImage(data: data)
                        cell.imageView?.image = image
                    }
        }
        
        if tracks[indexPath.row].mediaUrl.range(of: ".m4v", options: [.regularExpression]) != nil {
            cell.imageView?.image = nil
            cell.textLabel?.text = nil
            print("Found .m4v")
        } else {
            cell.textLabel!.text = tracks[indexPath.row].title
        }
        
        return cell
    }
}
