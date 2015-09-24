import UIKit
import QuartzCore

class TRTrackerViewController: UIViewController, TRTrackerViewObserver {
    
    @IBOutlet private weak var trackerView: TRTrackerView!
    private var trackerPresenter: TRTrackerPresenter!
    private var recordService = TRRecordService()
    private var recordsModel: TRRecordsModel!
    private lazy var itemsModel = TRItemsModel.sharedInstanceOfItemsModel
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        recordsModel = TRRecordsModel.sharedInstanceOfRecordsModel
        trackerPresenter = TRTrackerPresenter(view: self.trackerView, model: self.recordsModel!)
        activityMonitor.startAnimating()
        weak var weakSelf = self
        recordsModel.readAllRecords { () -> Void in
            weakSelf?.activityMonitor.stopAnimating()
            weakSelf?.activityMonitor.hidden = true
            weakSelf?.trackerView.trackerTableView.reloadData()
        }
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        trackerView.observer = self
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 25.0)!]
        navigationController?.navigationBar.tintColor = UIColor.TRMimosaYellow()
    }
    
    override func viewWillAppear(animated: Bool) {
        trackerView.trackerTableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    // MARK: TRTrackerViewObserver
    func dateChooserWanted() {
        let dateViewController = TRChooseableDateViewController()
        dateViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        dateViewController.dateObserver = self.trackerPresenter
        if let popOver = dateViewController.popoverPresentationController {
            popOver.permittedArrowDirections = UIPopoverArrowDirection.Up
            popOver.delegate = dateViewController
            popOver.sourceView = self.trackerView
            popOver.sourceRect = self.trackerView.todaysDateButton.frame
            self.presentViewController(dateViewController, animated: true, completion: nil)
        }
    }
    
    func trackingOptionsWantedAtRow(row: Int) {
        let isAVice = itemsModel.activeItems[row].isAVice
        let trackingOptionsTableViewController = TRTrackingOptionsTableViewController(associatedItemIsAVice: isAVice)
        trackingOptionsTableViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        if let popOver = trackingOptionsTableViewController.popoverPresentationController {
            popOver.permittedArrowDirections = .Right
            popOver.delegate = trackingOptionsTableViewController
            if let cell = trackerView.trackerTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: row)) as? TRTrackerTableViewCell {
                popOver.sourceView = cell.contentView
                popOver.sourceRect = cell.moreButtonFrame
                trackingOptionsTableViewController.delegate = cell
            }
            self.presentViewController(trackingOptionsTableViewController, animated: true, completion: nil)
        }
    }
    
    func dismissTrackingOptions() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}