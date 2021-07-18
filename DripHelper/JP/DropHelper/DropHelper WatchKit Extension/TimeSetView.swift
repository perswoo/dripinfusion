//
//  TimeSetView.swift
//  DropHelper
//
//  Created by おいちいたまご on 2021/07/06.
//

import WatchKit
import Foundation

class TimeSetView: WKInterfaceController {
    
    @IBOutlet weak var valueSetView: WKInterfaceTextField!
    
    
    let userDefaults = UserDefaults.standard
    
    var inputData: Int = 0
    var setDataHour: Int = 0
    var setDataMin: Int = 0
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        inputData = 0
        setDataHour = 0
        setDataMin = 0
        
        valueSetView.setText(String(format: "%01d", setDataHour) + ":" + String(format: "%02d", setDataMin))
        
        self.setTitle(TITLE_W_DROP_TIMER)
        
    }
    
    func keyValueSet(keyValue: Int){
        
        func SetTime(){
            if (inputData > VAL_W_KEYINPUT_MAXSIZE){
            
            }else if(inputData < 60 ){
                setDataMin = inputData
                setDataHour = 0
            }else if( inputData < 100){
                // 99以下で２桁目が６０〜９９の場合
                setDataMin = inputData % 60
                setDataHour = Int(round(Double(inputData / 60)))
            }else{
                setDataMin = inputData % 100// ２桁以下
                setDataHour = Int(round(Double(inputData / 100))) // ３桁目以降
            }
            print(inputData)
            print(String(setDataHour) + ":" + String(setDataMin) + "\n")
        }
        
        switch keyValue {
        case VAL_W_KEYBUTTON_0:
            if (inputData == 0 || inputData > VAL_W_KEYINPUT_MAXSIZE){
                break
            }
            
            inputData = (inputData * 10) + keyValue
            SetTime()
            
        case VAL_W_KEYBUTTON_1...VAL_W_KEYBUTTON_9:
            if (inputData > VAL_W_KEYINPUT_MAXSIZE){
                break
            }
            
            inputData = (inputData * 10) + keyValue
            SetTime()
            
        case VAL_W_KEYBUTTON_DELETE:
            if(inputData > 10){
                inputData = (inputData / 10)
            }else{
                inputData = inputData - inputData
            }
            SetTime()
            
        case VAL_W_KEYBUTTON_OK:
            
            userDefaults.set(setDataHour, forKey: KEY_W_DROP_TIME_HOUR)
            userDefaults.set(setDataMin, forKey: KEY_W_DROP_TIME_MIN)
            
            // 入力3項目「輸液量・所要時間・滴下速度」のうち、一番最新の入力にフラグを入れる
            LeastInputItem_W = LEAST_W_INPUT_DROP_TIME
            pop()
            
        default:
            break
        }
        
        valueSetView.setText(String(format: "%01d", setDataHour) + ":" + String(format: "%02d", setDataMin))
    
    }
    
    @IBAction func KeyButton_1() { keyValueSet(keyValue: VAL_W_KEYBUTTON_1 )}
    @IBAction func KeyButton_2() { keyValueSet(keyValue: VAL_W_KEYBUTTON_2 )}
    @IBAction func KeyButton_3() { keyValueSet(keyValue: VAL_W_KEYBUTTON_3 )}
    @IBAction func KeyButton_4() { keyValueSet(keyValue: VAL_W_KEYBUTTON_4 )}
    @IBAction func KeyButton_5() { keyValueSet(keyValue: VAL_W_KEYBUTTON_5 )}
    @IBAction func KeyButton_6() { keyValueSet(keyValue: VAL_W_KEYBUTTON_6 )}
    @IBAction func KeyButton_7() { keyValueSet(keyValue: VAL_W_KEYBUTTON_7 )}
    @IBAction func KeyButton_8() { keyValueSet(keyValue: VAL_W_KEYBUTTON_8 )}
    @IBAction func KeyButton_9() { keyValueSet(keyValue: VAL_W_KEYBUTTON_9 )}
    @IBAction func KeyButton_0() { keyValueSet(keyValue: VAL_W_KEYBUTTON_0 )}
    @IBAction func KeyButton_OK() { keyValueSet(keyValue: VAL_W_KEYBUTTON_OK )}
    @IBAction func KeyButton_Delete() { keyValueSet(keyValue: VAL_W_KEYBUTTON_DELETE )}
    
}
