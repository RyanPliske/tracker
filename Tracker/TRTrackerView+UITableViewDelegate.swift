import Foundation

extension TRTrackerView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.sizeToFit()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let path = pathToReload where path == indexPath {
            return 400
        }
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pathToReload = indexPath == pathToReload ? nil : indexPath
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.endUpdates()
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
}