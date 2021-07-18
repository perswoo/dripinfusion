//
//  DropNotificationView.swift
//  DropHelper
//
//  Created by おいちいたまご on 2021/07/06.
//

import WatchKit
import UIKit

class DropNotificationView: WKInterfaceController {
    
    @IBOutlet weak var ProgressImage: WKInterfaceImage!
    
    @IBOutlet weak var infusionSetLabel: WKInterfaceLabel!
    @IBOutlet weak var fluidVolumeLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var flowRateLabel: WKInterfaceLabel!
    @IBOutlet weak var dropSecPerOneDropLabel: WKInterfaceLabel!
    
    let userDefaults = UserDefaults.standard
    
    var timer: Timer! // タイマー用変数
    
    var infusionSetData: Int = 0
    var fluidVolumeSetData: Int = 0
    var timeHourSetData: Int = 0
    var timeMinSetData: Int = 0
    var flowRateSetData: Int = 0
    
    var countTimeInterval: Int = 0
    var dropProgressPercent: Float = 0
    
    var val_result_DropCountPerMin: Float  = 0 //　滴下数
    var val_result_DropSecPerOneDrop: Float  = 0 //　滴下間隔
    
    func getSettingData(){
        
        
    }
    
    func culcuationDropSchedule(){
        
        // userDefaultsを取得し、変数に代入する
        infusionSetData = userDefaults.integer(forKey: KEY_W_DROP_INFUSION_SET)
        fluidVolumeSetData =  userDefaults.integer(forKey: KEY_W_DROP_FLUID_VOLUME)
        timeHourSetData = userDefaults.integer(forKey: KEY_W_DROP_TIME_HOUR)
        timeMinSetData = userDefaults.integer(forKey: KEY_W_DROP_TIME_MIN)
        flowRateSetData =  userDefaults.integer(forKey: KEY_W_DROP_FLOW_RATE)
        
        infusionSetLabel.setText( String(infusionSetData) + UNT_W_DROP_INFUSION_SET)
        fluidVolumeLabel.setText( String(fluidVolumeSetData) + UNT_W_DROP_FLUID_VOLUME)
        timeLabel.setText( String(format: "%01d", timeHourSetData) + ":" + String(format: "%02d", timeMinSetData))
        flowRateLabel.setText( String(flowRateSetData) + UNT_W_DROP_FLOW_RATE)
        
        
        
        //　滴下間隔を計算する。
        val_result_DropCountPerMin = Float(flowRateSetData) / 60 * Float(infusionSetData)
        val_result_DropSecPerOneDrop = 60 / val_result_DropCountPerMin
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(val_result_DropSecPerOneDrop), target: self, selector: #selector(dropMainAction), userInfo: nil, repeats: true)
            
            
            /*
            self.dropProgressPercent = Float(self.countTimeInterval) * Float(VAL_W_TIMER_INTERVAL) / self.val_result_DropSecPerOneDrop
            
            */
            
            
            /*
            
            if(self.dropProgressPercent < 0.3){
                // イメージを変更する
                //self.ProgressImage.setImage(UIImage(named: STR_W_DROP_PROGRESS_DROP_IMAGE0))
                self.ProgressImage.setImageNamed(STR_W_DROP_PROGRESS_DROP_IMAGE)
                self.ProgressImage.startAnimatingWithImages(
                    in: NSMakeRange(0, 1),
                    duration: TimeInterval(VAL_W_TIMER_INTERVAL),
                    repeatCount: 0)
                
            }else if(self.dropProgressPercent < 0.5){
                // イメージを変更する
                //self.ProgressImage.setImage(UIImage(named: STR_W_DROP_PROGRESS_DROP_IMAGE1))
                self.ProgressImage.setImageNamed(STR_W_DROP_PROGRESS_DROP_IMAGE)
                self.ProgressImage.startAnimatingWithImages(
                    in: NSMakeRange(20, 21),
                    duration: TimeInterval(VAL_W_TIMER_INTERVAL),
                    repeatCount: 0)
                
            }else if(self.dropProgressPercent < 0.7){
                // イメージを変更する
                //self.ProgressImage.setImage(UIImage(named: STR_W_DROP_PROGRESS_DROP_IMAGE1))
                self.ProgressImage.setImageNamed(STR_W_DROP_PROGRESS_DROP_IMAGE)
                self.ProgressImage.startAnimatingWithImages(
                    in: NSMakeRange(50, 51),
                    duration: TimeInterval(VAL_W_TIMER_INTERVAL),
                    repeatCount: 0)
             
            }else if(self.dropProgressPercent < 0.95){
                // イメージを変更する
                //self.ProgressImage.setImage(UIImage(named: STR_W_DROP_PROGRESS_DROP_IMAGE2))
                self.ProgressImage.setImageNamed(STR_W_DROP_PROGRESS_DROP_IMAGE)
                self.ProgressImage.startAnimatingWithImages(
                    in: NSMakeRange(70, 71),
                    duration: TimeInterval(VAL_W_TIMER_INTERVAL),
                    repeatCount: 0)
                
            }else if(self.dropProgressPercent > 0.97){
                // イメージを変更する
                //self.ProgressImage.setImage(UIImage(named: STR_W_DROP_PROGRESS_DROP_IMAGE3))
                self.ProgressImage.setImageNamed(STR_W_DROP_PROGRESS_DROP_IMAGE)
                self.ProgressImage.startAnimatingWithImages(
                    in: NSMakeRange(89, 90),
                    duration: TimeInterval(VAL_W_TIMER_INTERVAL),
                    repeatCount: 0)
                
            }else if(self.dropProgressPercent > 0.98){
                // イメージを変更する
                //self.ProgressImage.setImage(UIImage(named: STR_W_DROP_PROGRESS_DROP_IMAGE3))
                self.ProgressImage.setImageNamed(STR_W_DROP_PROGRESS_DROP_IMAGE)
                self.ProgressImage.startAnimatingWithImages(
                    in: NSMakeRange(92, 93),
                    duration: TimeInterval(VAL_W_TIMER_INTERVAL),
                    repeatCount: 0)
            
            }else if(self.dropProgressPercent > 0.99){
                // イメージを変更する
                //self.ProgressImage.setImage(UIImage(named: STR_W_DROP_PROGRESS_DROP_IMAGE4))
                self.ProgressImage.setImageNamed(STR_W_DROP_PROGRESS_DROP_IMAGE)
                self.ProgressImage.startAnimatingWithImages(
                    in: NSMakeRange(98, 99),
                    duration: TimeInterval(VAL_W_TIMER_INTERVAL),
                    repeatCount: 5)
                
            }
             
             
            
            if(self.dropProgressPercent > 1.0){
                // バイブレーションで通知する
                WKInterfaceDevice.current().play(WKHapticType.click)
                
                self.countTimeInterval = 0
            }else{
                self.countTimeInterval = self.countTimeInterval + 1
            }
             */
            
            
        
        RunLoop.current.add(timer, forMode: .common)
        
        ProgressImage.setImageNamed(STR_W_DROP_PROGRESS_DROP_IMAGE)
        ProgressImage.startAnimatingWithImages(
            in: NSMakeRange(0, 99),
            duration: TimeInterval(val_result_DropSecPerOneDrop),
            repeatCount: 0)
        
        print(val_result_DropCountPerMin)
        print(val_result_DropSecPerOneDrop)
        
        
        //self.ProgressImage.setImage(UIImage(named: STR_W_DROP_PROGRESS_DROP_IMAGE))
        //self.ProgressImage.startAnimating()
        
        
        if(val_result_DropSecPerOneDrop > 0){
            dropSecPerOneDropLabel.setText( String(round(val_result_DropCountPerMin * 10) / 10) + UNT_W_DROP_COUNT_PER_MIN)
        }
        
        print(val_result_DropCountPerMin)
        print(val_result_DropSecPerOneDrop)
    }
    
    
    
    
    @objc func dropMainAction(){
        
        // バイブレーションで通知する
        WKInterfaceDevice.current().play(WKHapticType.click)
        
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.setTitle(TITLE_W_DROP_NOTIFICATION)
        
    }
    
    
    
    override func willActivate() {
        super.willActivate()
        getSettingData()
        
        culcuationDropSchedule()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        timer.invalidate()

    }
    
    @IBAction func StartDropButton() {
        print("set")
        
        print(val_result_DropCountPerMin)
        
        print(val_result_DropSecPerOneDrop)
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(val_result_DropSecPerOneDrop), target: self, selector: #selector(dropMainAction), userInfo: nil, repeats: true)
        
        ProgressImage.stopAnimating()
        ProgressImage.startAnimatingWithImages(
            in: NSMakeRange(0, 99),
            duration: TimeInterval(val_result_DropSecPerOneDrop),
            repeatCount: 0)
    }
    
    
}

