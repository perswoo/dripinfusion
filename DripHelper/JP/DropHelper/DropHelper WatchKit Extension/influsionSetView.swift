//
//  influsionSetView.swift
//  DropHelper
//
//  Created by おいちいたまご on 2021/07/06.
//

import WatchKit
import Foundation

class InfusionSetWKInterfaceController: WKInterfaceController {

    @IBOutlet weak var infusionSet_20_Button: WKInterfaceButton!
    @IBOutlet weak var infusionSet_60_Button: WKInterfaceButton!
    @IBOutlet weak var infusionSet_15_Button: WKInterfaceButton!
    @IBOutlet weak var infusionSet_10_Button: WKInterfaceButton!
    
    
    let userDefaults = UserDefaults.standard
    
    var inputData: Int = 0
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        inputData = userDefaults.integer(forKey: KEY_W_DROP_INFUSION_SET)
        
        switch inputData {
        case VAL_W_DROP_INFUSION_20:
            infusionSet_20_Button.setBackgroundColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))
        case VAL_W_DROP_INFUSION_60:
            infusionSet_60_Button.setBackgroundColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))
        case VAL_W_DROP_INFUSION_15:
            infusionSet_15_Button.setBackgroundColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))
        case VAL_W_DROP_INFUSION_10:
            infusionSet_10_Button.setBackgroundColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))
        default:
            break
        }
        
        
        self.setTitle(TITLE_W_DROP_INFUSION_SET)
        
    }
    
    
    @IBAction func infusionSet_20() {
        userDefaults.set(VAL_W_DROP_INFUSION_20, forKey: KEY_W_DROP_INFUSION_SET)
        print(VAL_W_DROP_INFUSION_20)
        // 入力3項目「輸液量・所要時間・滴下速度」のうち、一番最新の入力にフラグを入れる
        LeastInputItem_W = LEAST_W_INPUT_DROP_FLUID_VOLUME
        pop()
    }
    
    
    @IBAction func infusionSet_60() {
        userDefaults.set(VAL_W_DROP_INFUSION_60, forKey: KEY_W_DROP_INFUSION_SET)
        print(VAL_W_DROP_INFUSION_60)
        // 入力3項目「輸液量・所要時間・滴下速度」のうち、一番最新の入力にフラグを入れる
        LeastInputItem_W = LEAST_W_INPUT_DROP_FLUID_VOLUME
        pop()
    }
    
    
    @IBAction func infusionSet_15() {
        userDefaults.set(VAL_W_DROP_INFUSION_15, forKey: KEY_W_DROP_INFUSION_SET)
        print(VAL_W_DROP_INFUSION_15)
        // 入力3項目「輸液量・所要時間・滴下速度」のうち、一番最新の入力にフラグを入れる
        LeastInputItem_W = LEAST_W_INPUT_DROP_FLUID_VOLUME
        pop()
    }
    
    
    @IBAction func infusionSet_10() {
        userDefaults.set(VAL_W_DROP_INFUSION_10, forKey: KEY_W_DROP_INFUSION_SET)
        print(VAL_W_DROP_INFUSION_10)
        // 入力3項目「輸液量・所要時間・滴下速度」のうち、一番最新の入力にフラグを入れる
        LeastInputItem_W = LEAST_W_INPUT_DROP_FLUID_VOLUME
        pop()
    }
    
    
}
