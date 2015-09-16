import Foundation

class TREditItemPresenter: NSObject, UITableViewDataSource, UITableViewDelegate, TREditItemTableViewInputCellDelegate {
    private let itemTableView: UITableView
    private let itemsModel = TRItemsModel.sharedInstanceOfItemsModel
    private var itemRow: Int?
    private var isNewItem = false
    
    init(view: UITableView, itemRowToPopulateWith: Int?) {
        self.itemTableView = view
        self.itemRow = itemRowToPopulateWith
        if self.itemRow == nil {
            self.isNewItem = true
        }
        super.init()
        self.itemTableView.dataSource = self
        self.itemTableView.delegate = self
    }
    
    private func enableOtherCells() {
        if let secondInputCell = itemTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TREditItemTableViewInputCell {
            secondInputCell.setTextFieldUserInteraction(true)
        }
        if let badHabitCell = itemTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? TREditItemTableViewViceCell {
            badHabitCell.setViewSwitchUserInteraction(true)
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch (indexPath.row) {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("userInputCell") as! TREditItemTableViewInputCell
            if let inputCell = cell as? TREditItemTableViewInputCell {
                inputCell.topBorder.hidden = false
                inputCell.setLabelWithText("Name:")
                let textFieldText = isNewItem ? "" : itemsModel.allItems[itemRow!].name
                inputCell.setTextFieldTextWithText(textFieldText)
                inputCell.setTextFieldTagWith(indexPath.row)
                inputCell.textFieldDelegate = self
                if isNewItem {
                    inputCell.setTextFieldAsFirstResponder()
                }
            }
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("badHabitCell") as! TREditItemTableViewViceCell
            if let viceCell = cell as? TREditItemTableViewViceCell {
                let isAVice = isNewItem ? false : itemsModel.allItems[itemRow!].isAVice
                viceCell.setViceSwitchTo(isAVice)
                if isNewItem {
                    viceCell.setViewSwitchUserInteraction(false)
                }
            }
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("userInputCell") as! TREditItemTableViewInputCell
            if let inputCell = cell as? TREditItemTableViewInputCell {
                inputCell.bottomBorder.hidden = false
                inputCell.setLabelWithText("Measure Unit:")
                let textFieldText = isNewItem ? "" : itemsModel.allItems[itemRow!].measurementUnit
                inputCell.setTextFieldTextWithText(textFieldText)
                inputCell.setTextFieldTagWith(indexPath.row)
                inputCell.textFieldDelegate = self
                if isNewItem {
                    inputCell.setTextFieldUserInteraction(false)
                }
            }
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("userInputCell") as! TREditItemTableViewInputCell
            
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2 {
            let heightForRow = heightForUserInputCell()
            return heightForRow
        } else {
            return 50.0
        }
    }
    
    // MARK: UITableViewHeightCalculation Helpers
    private func heightForUserInputCell() -> CGFloat {
        
        struct Static {
            static var userInputCell: UITableViewCell? = nil
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken, {
            Static.userInputCell = self.itemTableView.dequeueReusableCellWithIdentifier("userInputCell")
        })
        
        return calculateHeightForConfiguredUserInputCell(Static.userInputCell!)
    }
    
    private func calculateHeightForConfiguredUserInputCell(cell: UITableViewCell) -> CGFloat {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size = cell.contentView .systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height + 1.0
    }
    
    // MARK: TREditItemTableViewInputCellDelegate
    func textFieldChangedAtRow(row: Int, text: String) {
        if isNewItem {
            enableOtherCells()
        } else {
            if row == 0 {
                itemsModel.updateItemsNameAtIndex(itemRow!, name: text)
            } else if row == 2 {
                itemsModel.updateItemsMeasurementUnitAtIndex(itemRow!, unit: text)
            }
        }
    }
    
}