import 'package:flutter/material.dart';
import 'package:music_player/model/song.dart';
import 'package:audioplayers/audioplayers.dart';

class PlaylistProvider extends ChangeNotifier{
  // Playlist of song
  final List<Song> _playlist = [
    Song(
      songName: 'Wishes',
      artistName: 'Hassan Raheem',
      albumArtImagePath: 'assets/images/Wishes.png',
      audioPath: 'audio/Wishes.mp3'
    ),

    Song(
        songName: 'Murder',
        artistName: 'Real Boss',
        albumArtImagePath: 'assets/images/Murder.png',
        audioPath: 'audio/Murder.mp3'
    ),

    Song(
        songName: 'Sadqay',
        artistName: 'Ashir Wajahat',
        albumArtImagePath: 'assets/images/Sadqay.png',
        audioPath: 'audio/Sadqay.mp3'
    ),
  ];

  // current song playing index
  int? _currentSongIndex;

  /*
  A U D I O P L A Y E R S
   */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider(){
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async{
    final String path = _playlist[currentSongIndex!].audioPath;
    await _audioPlayer.stop(); //stop the current song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrresume() async {
    if(_isPlaying){
      pause();
    }else{
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song
  void seek(Duration position) async{
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong(){
    if(_currentSongIndex != null){
      if(_currentSongIndex! < _playlist.length -1){
        // go to the next song if it is not the last song
        _currentSongIndex = _currentSongIndex! + 1;
      }else{
        // if it is the last song loop back to the first song
        _currentSongIndex = 0;
      }
      // Update current song index property
      currentSongIndex = _currentSongIndex;
    }
  }

// play previous song
  void playPreviousSong() async{
    // if more than 2 seconds have passed restart the song
    if(_currentDuration.inSeconds>2){
      seek(Duration.zero);
    }
    // if it's within th first 2 seconds of the song go to the previous song
    else{
      if(_currentSongIndex! > 0){
        _currentSongIndex = _currentSongIndex! -1;
      }else{
        // if it is the first song loop back to the last song
        _currentSongIndex = playlist.length -1;
      }
      // Update current song index property
      currentSongIndex = _currentSongIndex;
    }
  }


  // listen too duration
  void listenToDuration(){
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });
    // listen for complete duration
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player

  /*
  G E T T E R S
   */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
  S E T T E R S
   */

  set currentSongIndex(int? newIndex){
    //update current song index
    _currentSongIndex = newIndex;

    if(newIndex != null){
      play(); //play thee song at new index
    }

    //update UI
    notifyListeners();
  }
}