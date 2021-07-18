//
//  InterfaceController.swift
//  DropHelper WatchKit Extension
//
//  Created by おいちいたまご on 2021/07/06.
//

import WatchKit
import Foundation
import WatchConnectivity



class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet weak var infusionSetButton: WKInterfaceButton!
    @IBOutlet weak var fluidVolumeSetButton: WKInterfaceButton!
    @IBOutlet weak var timeSetButton: WKInterfaceButton!
    @IBOutlet weak var flowRateSetButton: WKInterfaceButton!
    @IBOutlet weak var OKButton: WKInterfaceButton!
    
    
    let userDefaults = UserDefaults.standard
    
    var dropStartFlag: Bool = false     // 点滴を開始するためのフラグ
    var culcuateMethodSelect = CUL_W_DROP_FLUID_VOLUME
    
    var infusionSetData: Float = 0
    var fluidVolumeSetData: Float = 0
    var timeHourSetData: Float = 0
    var timeMinSetData: Float = 0
    var flowRateSetData: Float = 0
    
    var text: Int = 0
    var text1: Int = 0
    var text2: Int = 0
    var text3: Int = 0
    var text4: Int = 0
    
    var wcSession : WCSession!
    
    func initDropAPP() {
        //初回起動判定
        let visit = UserDefaults.standard.bool(forKey: KEY_W_VISIT)
        if visit {
            //二回目以降
            print("二回目以降")
            
        } else {
            //初回アクセス
            print("初回起動")
            userDefaults.set(true, forKey: KEY_VISIT)
            
            userDefaults.set(VAL_W_INIT_INFUSION_SET, forKey: KEY_W_DROP_INFUSION_SET)
            userDefaults.set(VAL_W_INIT_DROP_FLUID_VOLUME, forKey: KEY_W_DROP_FLUID_VOLUME)
            userDefaults.set(VAL_W_INIT_DROP_TIMER_HOUR, forKey: KEY_W_DROP_TIME_HOUR)
            userDefaults.set(VAL_W_INIT_DROP_TIMER_MIN, forKey: KEY_W_DROP_TIME_MIN)
            userDefaults.set(VAL_W_INIT_DROP_FLOW_RATE, forKey: KEY_W_DROP_FLOW_RATE)
            userDefaults.set(VAL_W_IMAGE_ALIFNMENT_RIGHT, forKey: KEY_W_IMAGE_ALIGNMENT)
            LeastInputItem_W = LEAST_W_INPUT_IS_OLD_DATA
            
        }
        
        
        infusionSetData = userDefaults.float(forKey: KEY_W_DROP_INFUSION_SET)
        fluidVolumeSetData = userDefaults.float(forKey: KEY_W_DROP_FLUID_VOLUME)
        timeHourSetData = userDefaults.float(forKey: KEY_W_DROP_TIME_HOUR)
        timeMinSetData = userDefaults.float(forKey: KEY_W_DROP_TIME_MIN)
        flowRateSetData = userDefaults.float(forKey: KEY_W_DROP_FLOW_RATE)
        
        if (checkSettingData() == true){
            culcuationDropSchedule()
            // 点滴を開始するためのフラグ
            dropStartFlag = true
            OKButton.setEnabled(true)
            
        }
        else{
            // 点滴を開始するためのフラグ
            dropStartFlag = false
            OKButton.setEnabled(false)
        }
        print(dropStartFlag)
        
    }
    
    // 最初に呼び出されるメソッド
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        initDropAPP()
        
        self.setTitle(TITLE_W_MAIN)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func checkSettingData() -> Bool {
               
        if (infusionSetData > 0 && fluidVolumeSetData > 0 && (timeHourSetData > 0 || timeMinSetData > 0) && flowRateSetData > 0){
            //「4項目全て入力済み状態で」「3項目（液量・時間・流量）のうち最新で変更した項目」を元に、入力パターンを記録
            switch LeastInputItem_W {
            case LEAST_INPUT_DROP_NONE:
                return false
            case LEAST_INPUT_DROP_FLUID_VOLUME:
                culcuateMethodSelect = CUL_W_DROP_FLOW_RATE
                break
            case LEAST_INPUT_DROP_TIME:
                culcuateMethodSelect = CUL_W_DROP_FLOW_RATE
                break
            case LEAST_INPUT_DROP_FLOW_RATE:
                culcuateMethodSelect = CUL_W_DROP_TIME
                break
            case LEAST_INPUT_IS_OLD_DATA:
                culcuateMethodSelect = CUL_W_DROP_TIME
                break
            default:
                return false
            }
        }
        else if (infusionSetData > 0 && fluidVolumeSetData > 0 && (timeHourSetData > 0 || timeMinSetData > 0)) {
            culcuateMethodSelect = CUL_W_DROP_FLOW_RATE
        }
        else if (infusionSetData > 0 && fluidVolumeSetData > 0 && flowRateSetData > 0){
            culcuateMethodSelect = CUL_W_DROP_TIME
        }
        else if (infusionSetData > 0 && flowRateSetData > 0 && (timeHourSetData > 0 || timeMinSetData > 0)){
            culcuateMethodSelect = CUL_W_DROP_FLUID_VOLUME
        }
        else{
            return false
        }
        
        return true
    }
    
    func culcuationDropSchedule() {
        // 時間もしくは流量を計算する。
        // infusionSetData
        // fluidVolumeSetData
        // timeHourSetData
        // timeMinSetData
        // flowRateSetData
        
        switch culcuateMethodSelect {
        case CUL_DROP_FLUID_VOLUME:
            fluidVolumeSetData = flowRateSetData * ( timeHourSetData + (timeMinSetData / 60 ) )
            
            // 小数点2位で四捨五入
            fluidVolumeSetData = round(fluidVolumeSetData * 10 ) / 10
        
        case CUL_DROP_TIME:
            timeHourSetData = floor((fluidVolumeSetData / flowRateSetData))
            timeMinSetData = (fluidVolumeSetData / flowRateSetData)
            timeMinSetData = round(timeMinSetData.truncatingRemainder(dividingBy: 1) * 60)
                
            
        case CUL_DROP_FLOW_RATE:
            flowRateSetData = fluidVolumeSetData / ( timeHourSetData + (timeMinSetData / 60 ) )
            
            // 小数点2位で四捨五入
            flowRateSetData = round(flowRateSetData)
            
        default:
            break
    
        }
        
        // 結果を記録
        userDefaults.set(Int(fluidVolumeSetData), forKey: KEY_W_DROP_FLUID_VOLUME)
        userDefaults.set(Int(timeHourSetData), forKey: KEY_W_DROP_TIME_HOUR)
        userDefaults.set(Int(timeMinSetData), forKey: KEY_W_DROP_TIME_MIN)
        userDefaults.set(Int(flowRateSetData), forKey: KEY_W_DROP_FLOW_RATE)
        
        infusionSetButton.setTitle( String(format: "%d", Int(infusionSetData)) + UNT_W_DROP_INFUSION_SET)
        fluidVolumeSetButton.setTitle( String(Int(fluidVolumeSetData)) + UNT_W_DROP_FLUID_VOLUME)
        timeSetButton.setTitle( String(format: "%01d", Int(timeHourSetData)) + ":" + String(format: "%02d", Int(timeMinSetData)))
        flowRateSetButton.setTitle( String(format: "%d", Int(flowRateSetData)) + UNT_W_DROP_FLOW_RATE)
        
    }
    
    override func didAppear() {
        infusionSetData = userDefaults.float(forKey: KEY_W_DROP_INFUSION_SET)
        fluidVolumeSetData = userDefaults.float(forKey: KEY_W_DROP_FLUID_VOLUME)
        timeHourSetData = userDefaults.float(forKey: KEY_W_DROP_TIME_HOUR)
        timeMinSetData = userDefaults.float(forKey: KEY_W_DROP_TIME_MIN)
        flowRateSetData = userDefaults.float(forKey: KEY_W_DROP_FLOW_RATE)
        
        infusionSetButton.setTitle( String(format: "%d", Int(infusionSetData)) + UNT_W_DROP_INFUSION_SET)
        fluidVolumeSetButton.setTitle( String(Int(fluidVolumeSetData)) + UNT_W_DROP_FLUID_VOLUME)
        timeSetButton.setTitle( String(format: "%01d", Int(timeHourSetData)) + ":" + String(format: "%02d", Int(timeMinSetData)))
        flowRateSetButton.setTitle( String(format: "%d", Int(flowRateSetData)) + UNT_W_DROP_FLOW_RATE)
        
        if (checkSettingData() == true){
            culcuationDropSchedule()
            // 点滴を開始するためのフラグ
            dropStartFlag = true
            OKButton.setEnabled(true)
        }
        else{
            // 点滴を開始するためのフラグ
            dropStartFlag = false
            OKButton.setEnabled(false)
        }
        
        
        
    }
    
    @IBAction func okButton() {
        let imageAlignment = userDefaults.integer(forKey: KEY_W_IMAGE_ALIGNMENT)
        
        switch imageAlignment{
        case VAL_W_IMAGE_ALIFNMENT_LEFT:
            pushController(withName: "DropNotificationViewLeft", context: nil)
        case VAL_W_IMAGE_ALIFNMENT_RIGHT:
            pushController(withName: "DropNotificationViewRight", context: nil)

        default:
            break
        }
    }
    
    
    
    // MARK: WCSession Methods
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        text = message[KEY_W_DROP_INFUSION_SET] as! Int
        text1 = message[KEY_W_DROP_FLUID_VOLUME] as! Int
        text2 = message[KEY_W_DROP_TIME_HOUR] as! Int
        text3 = message[KEY_W_DROP_TIME_MIN] as! Int
        text4 = message[KEY_W_DROP_FLOW_RATE] as! Int
        

        
        print(text)
        print(Int(infusionSetData))
        
        if( text == Int(userDefaults.float(forKey: KEY_W_DROP_INFUSION_SET)) &&
            text1 == Int(userDefaults.float(forKey: KEY_W_DROP_FLUID_VOLUME)) &&
            text2 == Int(userDefaults.float(forKey: KEY_W_DROP_TIME_HOUR)) &&
            text3 == Int(userDefaults.float(forKey: KEY_W_DROP_TIME_MIN)) &&
            text4 == Int(userDefaults.float(forKey: KEY_W_DROP_FLOW_RATE)) ){
            print("同期")
            userDefaults.set(false, forKey: KEY_W_DROP_RE_CULCUATION)
            OKButton.setEnabled(true)
        }else{
            print("非同期")
            print(KEY_W_DROP_INFUSION_SET + " " + String(text))
            print(KEY_W_DROP_FLUID_VOLUME + " " + String(text1))
            print(KEY_W_DROP_TIME_HOUR + " " + String(text2))
            print(KEY_W_DROP_TIME_MIN + " " + String(text3))
            print(KEY_W_DROP_FLOW_RATE + " " + String(text4))
            
            infusionSetButton.setTitle( String(format: "%d", text) + UNT_W_DROP_INFUSION_SET)
            fluidVolumeSetButton.setTitle( String(format: "%d", text1) + UNT_W_DROP_FLUID_VOLUME)
            timeSetButton.setTitle( String(format: "%01d", text2) + ":" + String(format: "%02d", text3))
            flowRateSetButton.setTitle( String(format: "%d", text4) + UNT_W_DROP_FLOW_RATE)
            
            userDefaults.set(text, forKey: KEY_W_DROP_INFUSION_SET)
            userDefaults.set(text1, forKey: KEY_W_DROP_FLUID_VOLUME)
            userDefaults.set(text2, forKey: KEY_W_DROP_TIME_HOUR)
            userDefaults.set(text3, forKey: KEY_W_DROP_TIME_MIN)
            userDefaults.set(text4, forKey: KEY_W_DROP_FLOW_RATE)
            
            userDefaults.set(true, forKey: KEY_W_DROP_RE_CULCUATION)
            OKButton.setEnabled(true)
        }

    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        print("WCSessionActivation")
        
    }

}
