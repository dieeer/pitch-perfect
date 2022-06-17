//
//  recordSoundsViewController.swift
//  pitch perfect
//
//  Created by justin on 6/14/22.
//

import UIKit
import AVFoundation
var audioPlayer: AVAudioPlayer!

class recordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    func configureUI(setMessage labelText: String, enableRecordButton isRecordButtonEnabled: Bool, enableStopRecordButton isStopRecordButtonEnabled: Bool) {
        recordingLabel.text = labelText
        recordingButton.isEnabled = isRecordButtonEnabled
        stopRecordingButton.isEnabled = isStopRecordButtonEnabled
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }

    @IBAction func recordAudio(_ sender: Any) {
        print("record pressed")
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
    }


    @IBAction func stopRecording(_ sender: Any) {
        print("stop recording pressed")
        recordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "tap to record"
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("finished recording")
        performSegue(withIdentifier: "stopRecordingButton", sender: audioRecorder.url)
    }
    

    }



