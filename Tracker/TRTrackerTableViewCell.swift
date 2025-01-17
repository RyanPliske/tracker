import Foundation
import Spring

protocol TRTrackerTableViewCellDelegate: class {
    func plusButtonPressedAtRow(row: Int, completion: TRCreateRecordCompletion)
    func trackUrgeSelectedForRow(row: Int, completion: TRCreateRecordCompletion)
    func trackMultipleSelectedForRow(row: Int)
    func textFieldReturnedWithTextAtRow(row: Int, text: String, completion: TRCreateRecordCompletion)
    func recordedMonthlyTracksForRow(row: Int) -> TRTracks
    func moreButtonPressedAtRow(row: Int, includeBadHabit: Bool)
}

class TRTrackerTableViewCell: UITableViewCell, TRStatsModelDelegate {
    
    weak var delegate: TRTrackerTableViewCellDelegate!
    var dateSelectedOnJTCalendar: NSDate!
    
    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet private weak var itemCountLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!
    private var statsPresenter: TRStatsPresenter!
    private var statsModel: TRStatsModel!
    private var isAVice = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        statsPresenter?.statsView.frame = CGRectMake(0, TRTrackerTableViewCellSize.closedHeight, CGRectGetWidth(self.bounds), TRTrackerTableViewCellSize.openedHeight - TRTrackerTableViewCellSize.closedHeight)
    }
    
    var moreButtonFrame: CGRect {
        return self.moreButton.frame
    }

    var recordedTracksForTheMonth: TRTracks {
        return delegate.recordedMonthlyTracksForRow(self.tag)
    }
    
    func prepareStatsView() {
        if statsPresenter == nil {
            statsModel = TRStatsModel(withDelegate: self)
            statsPresenter = TRStatsPresenter(withStatsModel: statsModel)
            statsPresenter.statsView = TRStatsView(frame: CGRectZero, trackingDate: dateSelectedOnJTCalendar, delegate: statsPresenter)
            addSubview(statsPresenter.statsView)
            layoutIfNeeded()
        }
    }
    
    func destroyStatsView() {
        if statsPresenter != nil {
            statsPresenter.statsView.removeFromSuperview()
            statsPresenter = nil
            statsModel = nil
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
    
    func resetCalendarAfterTrackOccured() {
        let item = TRItemsModel.sharedInstanceOfItemsModel.activeItems[tag]
        if item.dailyGoal != nil {
            let cell = statsPresenter.statsView.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: tag, inSection: 0)) as! TRCalendarCollectionViewCell
            cell.redrawGoalSymbols()
        }
    }
    
    func setSelectedDateOnCalendarWith(selectedDate: NSDate) {
        dateSelectedOnJTCalendar = selectedDate
    }
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        delegate.moreButtonPressedAtRow(self.tag, includeBadHabit: isAVice)
    }
}

extension TRTrackerTableViewCell: TRTrackingOptionsDelegate {
    func trackUrge() {
        delegate.trackUrgeSelectedForRow(self.tag) { [weak self]() -> Void in
            self?.resetCalendarAfterTrackOccured()
        }
    }
    
    func trackMultiple() {
        delegate.trackMultipleSelectedForRow(self.tag)
    }
}