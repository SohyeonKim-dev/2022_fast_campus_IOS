//
//  ViewController.swift
//  pomodoro
//
//  Created by κΉμν on 2022/07/08.
//

import UIKit
import AudioToolbox

enum TimerStatus{
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var duration = 60
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        // debugPrint(self.duration)
        
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
 
            UIView.animate(withDuration: 0.5,  animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
//                self.setTimerInfoViewVisible(isHidden: false)
//                self.datePicker.isHidden = true
            })
            self.toggleButton.isSelected = true
            self.cancleButton.isEnabled = true
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
        }
    }
    
    @IBAction func tapCancleButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
            
        case .end:
            break
        }
    }
    
    func setTimerInfoViewVisible(isHidden: Bool ) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton(){
        self.toggleButton.setTitle("μμ", for: .normal)
        self.toggleButton.setTitle("μΌμμ μ§", for: .selected)
    }
    
    func startTimer() {
        // νμ΄λ¨Έλ₯Ό μ€μ νκ³ , νμ΄λ¨Έκ° μμλλλ‘ κ΅¬ν
        if self.timer == nil{
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSeconds -= 1
                // 1μ΄μ νλ²μ© νΈλ€λ¬κ° νΈμΆλλ©΄, currentSecondsκ° 1μ© κ°μνλλ‘
                
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                // % : λλ¨Έμ§ / : λͺ«
                
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                    // 180λ νμ 
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    // λλ μ΄λ₯Ό ν΅ν΄ 180λ νμ ν λμ μ΄ν 360λ νμ 
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                if self.currentSeconds <= 0 {
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer(){
        if timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancleButton.isEnabled = false
      
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
//            self.setTimerInfoViewVisible(isHidden: true)
//            self.datePicker.isHidden = false
            self.imageView.transform = .identity
        })
        
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil
    }
}

