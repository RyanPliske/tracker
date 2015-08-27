import Foundation
import Parse

public class TRRecordService : NSObject {
    
    public func createRecordWithItem(item: String, quantity: Int, itemType: TRTrackingType, date: NSDate, completion: TRCreateRecordCompletion?) -> TRRecord {
        let record = TRRecord(className: "record")
        record.itemName = item
        record.itemQuantity = quantity
        record.itemType = TRRecord.stringFromSortType(itemType)
        record.itemDate = TRDateFormatter.descriptionForDate(date)
        saveRecordToPhoneWithRecord(record, completion: completion)
        return record
    }
    
    private func saveRecordToPhoneWithRecord(record: TRRecord, completion: TRCreateRecordCompletion?) {
        let BackgroundSaveCompletion: PFBooleanResultBlock = {
            (success, error) in
            if (error == nil && completion != nil) {
                print("Record saved.")
                completion!()
            }
        }
        record.pinInBackgroundWithBlock(BackgroundSaveCompletion)
    }
    
    private func saveRecordToParseDatabase(record: TRRecord) {
        record.saveEventually(nil)
    }
    
    public func readAllRecordsFromPhoneWithSortType(sortType: TRTrackingType, completion: PFArrayResultBlock) {
        let BackgroundRetrievalCompletion: PFArrayResultBlock = {
            (objects: [AnyObject]?, error: NSError?) in
                completion(objects, error)
        }
        let query = PFQuery(className: "record")
        query.fromLocalDatastore()
        query.whereKey("type", equalTo: TRRecord.stringFromSortType(sortType))
        query.findObjectsInBackgroundWithBlock(BackgroundRetrievalCompletion)
    }
    
    func readAllRecordsFromPhoneWithSearchText(searchText: String, sortType: TRTrackingType, completion: PFArrayResultBlock?) {
        let BackgroundRetrievalCompletion: PFArrayResultBlock = {
            (objects: [AnyObject]?, error: NSError?) in
            if let completionBlock = completion {
                completionBlock(objects, error)
            }
        }
        
        let withinDate = PFQuery(className: "record")
        withinDate.fromLocalDatastore()
        withinDate.whereKey("date", containsString: searchText)
        
        let withinItem = PFQuery(className: "record")
        withinItem.fromLocalDatastore()
        withinItem.whereKey("item", containsString: searchText)
        
        let query = PFQuery.orQueryWithSubqueries([withinDate, withinItem])
        query.fromLocalDatastore()
        query.whereKey("type", equalTo: TRRecord.stringFromSortType(sortType))
        query.findObjectsInBackgroundWithBlock(BackgroundRetrievalCompletion)
    }
    
    public func deleteAllRecordsFromPhone() {
        TRRecord.unpinAllObjects()
    }
    
    public func deleteRecord(record: TRRecord) {
        record.unpin()
    }
}