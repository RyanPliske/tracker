import UIKit

protocol TRCalendarViewDelegate: class {
    var successDays: [Int] { get }
}

class TRCalendarView: UIView, TRWeekViewDelegate {

    var trackingDate: NSDate!
    weak var delegate: TRCalendarViewDelegate! {
        didSet {
            drawSuccessDays(delegate.successDays)
        }
    }
    var currentDayIndex: Int {
        return TRDateFormatter.dayOfDate(trackingDate)
    }
    private var weekViews = [TRWeekView]()
    
    init(trackingDate: NSDate) {
        self.trackingDate = trackingDate
        super.init(frame: CGRectZero)
        let monthGenerator = TRMonthGenerator(trackingDate: trackingDate)
        let weeksOfTheMonth = [monthGenerator.week1, monthGenerator.week2, monthGenerator.week3, monthGenerator.week4, monthGenerator.week5, monthGenerator.week6]
        drawWeeks(weeksOfTheMonth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var y: CGFloat = 0
        let weekHeight = CGRectGetHeight(self.bounds) / 6
        let weekWidth = CGRectGetWidth(self.bounds)
        
        for weekView in weekViews {
            weekView.frame = CGRectMake(0, y, weekWidth, weekHeight)
            y += weekHeight
        }
    }
    
    private func drawWeeks(weeksOfTheMonth: [NSArray]) {
        for week in weeksOfTheMonth {
            let weekView = TRWeekView(daysOfTheWeek: week as! [Int], withDelegate: self)
            weekViews.append(weekView)
            addSubview(weekView)
        }
        layoutIfNeeded()
    }
    
    private func drawSuccessDays(successDays: [Int]) {
        for weekView in weekViews {
            for dayView in weekView.dayViews {
                if dayView.dayIndex > currentDayIndex || dayView.dayIndex == 0 {
                    continue
                }
                let success = successDays.filter { $0 == dayView.dayIndex }
                dayView.goalMet = success.isEmpty ? false : true
            }
        }

    }
    
}