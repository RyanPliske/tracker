import Foundation

class TRManageItemsPresenter: NSObject, UITableViewDataSource, TRManageItemsTableViewCellDelegate {
    
    private let itemsModel: TRItemsModel
    private let itemsTableView: UITableView
    
    init(itemsModel: TRItemsModel, itemsTableView: UITableView) {
        self.itemsModel = itemsModel
        self.itemsTableView = itemsTableView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsModel.allItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TRManageItemsTableViewCell = tableView.dequeueReusableCellWithIdentifier("items") as! TRManageItemsTableViewCell
        if (indexPath.row == 0) {
            cell.topBorder.hidden = false
            cell.bottomBorder.hidden = true
        } else if (indexPath.row == (itemsModel.allItems.count - 1)) {
            cell.topBorder.hidden = true
            cell.bottomBorder.hidden = false
        } else {
            cell.topBorder.hidden = true
            cell.bottomBorder.hidden = true
        }
        let name: String = itemsModel.allItems[indexPath.row].name
        cell.setSettingNameWith(name)
        cell.toggleSwitch.tag = indexPath.row
        cell.toggleSwitch.on = itemsModel.allItems[indexPath.row].activated
        cell.manageItemsTableViewCellDelegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row <= TRPreloadedItems.allItems.count {
            return false
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            itemsModel.deleteItemAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: TRManageItemsTableViewCellDelegate
    
    func toggleSwitchChangedValueAtRow(row: Int) {
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        let cell = itemsTableView.cellForRowAtIndexPath(indexPath) as! TRManageItemsTableViewCell
        itemsModel.updateItemActiveStatusAtIndex(row, activeStatus: cell.toggleSwitch.on)
    }
    
}