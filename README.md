# anchorMobileChallenge

<b>OBJECTIVES:</b>  

For this project, we want you to build an app that retrieves a list of audios from a server and
presents them to the user for playback.

The list of media should be retrieved from this endpoint every time the app loads:
https://s3-us-west-2.amazonaws.com/anchor-website/challenges/bsb.json

*Note that some of the entries in this JSON are videos, which should be filtered out and
not presented to the user.

The single-view app should present the audios from this endpoint in a table. Each cell should
display the title and a toggle-able play/pause button. When pressing play on a cell, that
audio should play, and any other audio should stop playing. When an audio finishes playing,
the next in the table should auto-play.

<b>SIDE NOTES:</b>

Don't worry about persistence or caching of the audio. It's ok to download the files from
scratch each time. Please be as creative as you like while trying to spend no more than a
couple of hours on the project. If you have thoughts about how you would approach it if you
had more time, feel free to share those with us as well, along with any assumptions you built
into your solution.

<b>MVP:</b>
 1) DONE - retrive data from given endpoint URL "https://s3-us-west-2.amazonaws.com/anchor-website/challenges/bsb.json"
 2) DONE - preset data to user as a list of items as a Table
 3) DONE - each cell should display title and toggle-able PLAY/PAUSE button
 4) DONE - user has to be able to tap on item to listen to playback
 5) DONE - if user taps on a song and audio is already playing, then other audio should stop
 6) when audio finishes playing, it should go to the next track
 7) WRITE SOME TESTS

<b>KNOWN BUGS:</b> 
 1) rotating the device does not refresh UITableview
 2) Tracks do not continue playing after finished
 3) able to tap on empty spaces and play m4v files
