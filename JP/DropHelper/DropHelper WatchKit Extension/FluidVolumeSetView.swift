//
//  FluidVolumeSetView.swift
//  DropHelper
//
//  Created by おいちいたまご on 2021/07/06.
//

import WatchKit
import Foundation


class FluidVolumeSetView: WKInterfaceController {
    
    @IBOutlet weak var valueSetView: WKInterfaceTextField!
    
    let userDefaults = UserDefaults.standard
    
    var inputData: Int = 0
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        inputData = 0
        valueSetView.setText(String(inputData) + UNT_W_DROP_FLUID_VOLUME)
        
        self.setTitle(TITLE_W_DROP_FLUID_VOLUME)
        
    }
    
    func keyValueSet(keyValue: Int){
        switch keyValue {
        case VAL_W_KEYBUTTON_0:
            if (inputData == 0 || inputData > VAL_W_KEYINPUT_MAXSIZE){
                break
            }
            inputData = (inputData * 10) + keyValue
            valueSetView.setText(String(inputData) + UNT_W_DROP_FLUID_VOLUME)
        case VAL_W_KEYBUTTON_1...VAL_W_KEYBUTTON_9:
            if(inputData < VAL_W_KEYINPUT_MAXSIZE){
                inputData = (inputData * 10) + keyValue
                valueSetView.setText(String(inputData) + UNT_W_DROP_FLUID_VOLUME)
            }
        case VAL_W_KEYBUTTON_OK:
            userDefaults.set(inputData, forKey: KEY_W_DROP_FLUID_VOLUME)
            // 入力3項目「輸液量・所要時間・滴下速度」のうち、一番最新の入力にフラグを入れる
            LeastInputItem_W = LEAST_W_INPUT_DROP_FLUID_VOLUME
            pop()
        case VAL_W_KEYBUTTON_DELETE:
            if(inputData > 10){
                inputData = (inputData / 10)
                valueSetView.setText(String(inputData) + UNT_W_DROP_FLUID_VOLUME)
            }else{
                inputData = inputData - inputData
                valueSetView.setText(String(inputData) + UNT_W_DROP_FLUID_VOLUME)
            }
        default:
            break
        }
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
