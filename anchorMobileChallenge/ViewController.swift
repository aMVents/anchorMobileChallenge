//ANCHOR MOBILE CHALLENGE:
//  Created by Alwin on 6/6/19.
//  Copyright © 2019 RS Productions. All rights reserved.

//MVP:
// 1) DONE - retrive data from given endpoint URL "https://s3-us-west-2.amazonaws.com/anchor-website/challenges/bsb.json"
// 2) DONE - preset data to user as a list of items as a Table
// 3) DONE - each cell should display title and toggle-able PLAY/PAUSE button
// 4) DONE - user has to be able to tap on item to listen to playback
// 5) DONE - if user taps on a song and audio is already playing, then other audio should stop
// 6) when audio finishes playing, it should go to the next track
// 7) WRITE SOME TESTS

//BUGS:
// 1) rotating the device does not refresh UITableview
// 2) Tracks do not continue playing after finished
// 3) able to tap on empty spaces and play m4v files

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myTableView = UITableView()
    private var tracks = [Tracks]()
    var contPlayer = AVQueuePlayer()
    var audioPlayer = AVPlayer()
    var currentRow: Int = 0
    var savedRow: Int = 0
    let jsonString = "https://s3-us-west-2.amazonaws.com/anchor-website/challenges/bsb.json"
    var playImage  = UIImage(named: "play")
    var pauseImage = UIImage(named: "pause")
    var imageState = UIImage()

//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        let animationHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [ weak self] (context ) in
//            self?.myTableView.reloadData()
//            self?.view.layoutIfNeeded()
//        }
//
//        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
//            self?.myTableView.reloadData()
//            self?.view.layoutIfNeeded()
//        }
//
//        coordinator.animate(alongsideTransition: animationHandler, completion: completionHandler)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        myTableView.tableFooterView = UIView()
        
        //MARK: Displaying the Tableview
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight-barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TracksCell")
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(myTableView)
        myTableView.reloadData()
        
    }
    
    func downloadJson() {
        //MARK: downloading JSON data
        let jsonUrlString = jsonString
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
                print(self.tracks)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    func play(songURL: String) {
        guard let url = URL.init(string: songURL) else { return }
        let playerItem = AVPlayerItem.init(url: url)

        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        if audioPlayer.timeControlStatus == .playing {
            audioPlayer.pause()
            imageState = playImage!
        } else if audioPlayer.timeControlStatus == .paused {
            audioPlayer.play()
            imageState = pauseImage!
        } else {
            audioPlayer = AVPlayer.init(playerItem: playerItem)
            audioPlayer.play()
            imageState = pauseImage!
        }
    }
    
    func newSong(songURL: String) {
        guard let url = URL.init(string: songURL) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        audioPlayer = AVPlayer.init(playerItem: playerItem)
        audioPlayer.play()
        imageState = pauseImage!
        
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        // play next track
        
        print("Finished")
//        guard let url = URL.init(string: jsonString ) else { return }
//        let playerItem = AVPlayerItem.init(url: url)
//        contPlayer.insert(playerItem, after: audioPlayer.currentItem)
//        contPlayer.advanceToNextItem()
//        audioPlayer.play()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentRow = indexPath.row
        
        print("Saved Row is \(savedRow)")
        print("I'm selecting \(indexPath.row)")
        print("Current Row is \(currentRow)")
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if savedRow == indexPath.row { //still on same song
            play(songURL: tracks[indexPath.row].mediaUrl)
            cell?.imageView?.image = imageState
            
        } else if currentRow != savedRow { //play new song
            newSong(songURL: tracks[indexPath.row].mediaUrl)
            savedRow = currentRow
            cell?.imageView?.image = imageState
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath)
        
        cell?.imageView?.image = playImage
  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TracksCell", for: indexPath as IndexPath)
       
        cell.imageView?.image = playImage
       
        let filteredArray = tracks[indexPath.row].mediaUrl.range(of: ".m4v", options: [.regularExpression])
        if filteredArray != nil {
            cell.imageView?.image = nil
            cell.textLabel?.text = nil
            print("Found .m4v")
        } else {
            cell.textLabel!.text = tracks[indexPath.row].title
        }
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        return cell
    }
}
