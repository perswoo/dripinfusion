//
//  MainDropData.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/07/01.
//

import Foundation

class DropInputDataList: NSObject, NSCoding {
    var fluidVolumeInputValue: String?
    
    var dropTimeHourInputValue: String?
    var dropTimeMinInputValue: String?
    
    var flowRateInputValue: String?
    

    override init() { }

    // シリアライズするときに呼ばれる
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(fluidVolumeInputValue, forKey: KEY_DROP_FLUID_VOLUME_VALUE)
        
        aCoder.encode(dropTimeHourInputValue, forKey: KEY_DROP_TIME_HOUR_VALUE)
        aCoder.encode(dropTimeMinInputValue, forKey: KEY_DROP_TIME_MIN_VALUE)
 
        aCoder.encode(flowRateInputValue, forKey: KEY_DROP_FLOW_RATE_VALUE)
        
    }
    // デシリアライズするときに呼ばれる
    required init?(coder aDecoder: NSCoder) {
        
        fluidVolumeInputValue = aDecoder.decodeObject(forKey: KEY_DROP_FLUID_VOLUME_VALUE) as? String
        
        dropTimeHourInputValue = aDecoder.decodeObject(forKey: KEY_DROP_TIME_HOUR_VALUE) as? String
        dropTimeHourInputValue = aDecoder.decodeObject(forKey: KEY_DROP_TIME_MIN_VALUE) as? String
        
        
        flowRateInputValue = aDecoder.decodeObject(forKey: KEY_DROP_FLOW_RATE_VALUE) as? String
    }
}

class FluidVolumeInputList: NSObject, NSCoding {
    var fluidVolumeInputValue: String?
    
    override init() { }

    // シリアライズするときに呼ばれる
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fluidVolumeInputValue, forKey: KEY_DROP_FLUID_VOLUME_VALUE)
    }

    // デシリアライズするときに呼ばれる
    required init?(coder aDecoder: NSCoder) {
        fluidVolumeInputValue = aDecoder.decodeObject(forKey: KEY_DROP_FLUID_VOLUME_VALUE) as? String
    }
}

class DropTimeInputList: NSObject, NSCoding {
    var dropTimeHourInputValue: String?
    var dropTimeMinInputValue: String?
    
    override init() { }

    // シリアライズするときに呼ばれる
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dropTimeHourInputValue, forKey: KEY_DROP_TIME_HOUR_VALUE)
        aCoder.encode(dropTimeMinInputValue, forKey: KEY_DROP_TIME_MIN_VALUE)
    }
    // デシリアライズするときに呼ばれる
    required init?(coder aDecoder: NSCoder) {
        dropTimeHourInputValue = aDecoder.decodeObject(forKey: KEY_DROP_TIME_HOUR_VALUE) as? String
        dropTimeMinInputValue = aDecoder.decodeObject(forKey: KEY_DROP_TIME_MIN_VALUE) as? String
    }
}

class FlowRateInputList: NSObject, NSCoding {
    var flowRateInputValue: String?
    
    override init() { }

    // シリアライズするときに呼ばれる
    func encode(with aCoder: NSCoder) {
       aCoder.encode(flowRateInputValue, forKey: KEY_DROP_FLOW_RATE_VALUE)
    }
    
    // デシリアライズするときに呼ばれる
    required init?(coder aDecoder: NSCoder) {
        flowRateInputValue = aDecoder.decodeObject(forKey: KEY_DROP_FLOW_RATE_VALUE) as? String
    }
}
