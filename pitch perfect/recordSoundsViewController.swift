//
//  recordSoundsViewController.swift
//  pitch perfect
//
//  Created by justin on 6/14/22.
//

import UIKit
import AVFoundation
var audioPlayer: AVAudioPlayer! //stackexchange help

class recordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

//MARK: configuring UI using Bool
    func configureUI(isRecording: Bool) {
           stopRecordingButton.isEnabled = isRecording // to disable
           recordingButton.isEnabled = !isRecording // to enable
           recordingLabel.text = !isRecording ? "tap to record" : "recording in progress"

       }
    

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "recording in progress"
        stopRecordingButton.isEnabled = true
        recordingButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
           let recordingName = "recordedVoice.wav"
           let pathArray = [dirPath, recordingName]
           let filePath = URL(string: pathArray.joined(separator: "/"))
            print(filePath!)
        
           let session = AVAudioSession.sharedInstance()
           try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

           try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
            audioRecorder.delegate = self
        
           audioRecorder.isMeteringEnabled = true
           audioRecorder.prepareToRecord()
           audioRecorder.record()
        configureUI(isRecording: true)
    }


    @IBAction func stopRecording(_ sender: Any) {
        recordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "tap to record"
        audioRecorder.stop()
        configureUI(isRecording: false)
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        performSegue(withIdentifier: "stopRecordingButton", sender: audioRecorder.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingButton" {
            let playSound = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as? URL
            playSound.recordedAudioURL = recordedAudioURL
        }
    }
    }



