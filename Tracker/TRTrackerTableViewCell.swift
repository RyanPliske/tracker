import Foundation
import Spring

@objc protocol TRTrackerTableViewCellDelegate: class {
    func plusButtonPressedAtRow(row: Int)
    func trackUrgeSelectedForRow(row: Int)
    func trackMultipleSelectedForRow(row: Int)
    func textFieldReturnedWithTextAtRow(row: Int, text: String)
    func successDaysForRow(row: Int) -> [Int]
    optional func moreButtonPressedAtRow(row: Int, includeBadHabit: Bool)
}

class TRTrackerTableViewCell: UITableViewCell, TRStatsViewDelegate {
    weak var delegate: TRTrackerTableViewCellDelegate!
    var moreButtonFrame: CGRect {
        return self.moreButton.frame
    }
    var successDays: [Int] {
        return delegate.successDaysForRow(self.tag)
    }
    
    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet private weak var itemCountLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!
    private var statsView: TRStatsView? 
    private var isAVice = false

    var selectedDatesOnJTCalendar = [String]()
    var dateSelectedOnJTCalendar: NSDate!
    
    override func layoutSubviews() {
        statsView?.frame = CGRectMake(0, TRTrackerTableViewCellSize.closedHeight, CGRectGetWidth(self.bounds), TRTrackerTableViewCellSize.openedHeight - TRTrackerTableViewCellSize.closedHeight)
    }
    
    func prepareStatsView() {
        if statsView == nil {
            statsView = TRStatsView(frame: CGRectZero, trackingDate: dateSelectedOnJTCalendar)
            statsView!.delegate = self
            addSubview(statsView!)
            layoutIfNeeded()
        }
    }
    
    func destroyStatsView() {
        if statsView != nil {
            statsView!.removeFromSuperview()
            statsView = nil
        }
    }
    
    func updateItemLabelCountWith(newItemCount: Float) {
        if let currentCount = Float(itemCountLabel.text!) {
            let totalCount = currentCount + newItemCount
            itemCountLabel.text = newItemCount % 1  == 0 ? Int(totalCount).description : totalCount.description
        }
    }
    
    func setItemLabelCountWith(itemCount: Float) {
        itemCountLabel.text = itemCount % 1  == 0 ? Int(itemCount).description : itemCount.description
    }
    
    func setItemNameLabelTextWith(itemName: String) {
        itemLabel.attributedText = NSAttributedString(string: itemName.uppercaseString, attributes: [NSKernAttributeName: 1.7])
    }
    
    func setTagsForCellWith(tag: Int) {
        self.tag = tag
    }
    
    func setCellAsBadHabit(isAVice: Bool) {
        self.isAVice = isAVice
    }
    
    func resetCalendar() {
        selectedDatesOnJTCalendar.removeAll()
    }
    
    func resetCalendarAfterTrackOccured() {
        if let dateSelected = dateSelectedOnJTCalendar {
            selectedDatesOnJTCalendar.append(TRDateFormatter.descriptionForDate(dateSelected))
        }
    }
    
    func setWhiteDotsOnDatesWith(dates: [String]) {
        selectedDatesOnJTCalendar = dates
    }
    
    func setSelectedDateOnCalendarWith(selectedDate: NSDate) {
        dateSelectedOnJTCalendar = selectedDate
    }
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        delegate.moreButtonPressedAtRow?(self.tag, includeBadHabit: isAVice)
    }
}

extension TRTrackerTableViewCell: TRTrackingOptionsDelegate {
    func trackUrge() {
        delegate.trackUrgeSelectedForRow(self.tag)
    }
    
    func trackMultiple() {
        delegate.trackMultipleSelectedForRow(self.tag)
    }
}