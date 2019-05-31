//时间戳 字符串 高精度定时器

import UIKit

class DateTimer {
    
    private lazy var date_formatter: DateFormatter = {
        
        let date_formatter = DateFormatter.init()
        date_formatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        date_formatter.isLenient = true
        date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return date_formatter
    }()
    
    var current:TimeInterval = 0
    var to_time:TimeInterval = 0
    var count_down:TimeInterval = 0
    
    var neeCount:Bool = true
    var time_over:(() -> ())?
    
    func time_run(countDown:TimeInterval = 0) {
        
        current = NSDate.init().timeIntervalSince1970
        to_time = NSDate.init().timeIntervalSince1970 + countDown
        count_down = to_time - current
        
        DispatchQueue.global().async {
            
            while self.neeCount {
                /** 误差0.01秒以内 */
                usleep(5*1000)
                
                if self.count_down > 0 {
                    self.judg_date()
                } else {
                    self.neeCount = false
                    self.time_over?()
                }
            }
        }
    }
    
    fileprivate func judg_date() {
        
        let temp_time: TimeInterval = NSDate.init().timeIntervalSince1970

        if date_formatter.string(from: Date.init(timeIntervalSinceReferenceDate: to_time - temp_time)) != date_formatter.string(from: Date.init(timeIntervalSinceReferenceDate: count_down)) {
            
            count_down = to_time - temp_time
            
            if self.count_down < 0 {
                
                print("倒计时结束")
                self.neeCount = false
                self.time_over?()
                
            } else {
                print("\(String.init(format: "倒计时 %02d分%02d秒 count_down:\(count_down)",Int.init(count_down)/60,Int.init(count_down)%60))")
            }
        }
    }
}

DateTimer.init().time_run(countDown: 10)

