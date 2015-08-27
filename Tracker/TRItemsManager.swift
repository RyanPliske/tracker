import Foundation
import Parse

public class TRItemsManager : NSObject {
    internal var trackableItems = TRTrackableItems()
    private var recordService: TRRecordService
    private var tracks = [TRRecord]()
    private var urges = [TRRecord]()
    public var itemSortType = TRTrackingType.TrackAction
    public var records: [TRRecord] {
        switch (self.itemSortType) {
        case .TrackAction:
            return self.tracks
        case .TrackUrge:
            return self.urges
        }
    }
    
    public init(recordService: TRRecordService) {
        self.recordService = recordService
        super.init()
    }
    
    public func grabTodaysTracks() {
        grabTodaysRecordsWithSortType(TRTrackingType.TrackAction)
    }
    
    public func grabTodaysUrges() {
        grabTodaysRecordsWithSortType(TRTrackingType.TrackUrge)
    }
    
    public func remove(record: TRRecord) {
        switch (self.itemSortType) {
        case .TrackAction:
            tracks = tracks.filter() { $0 !== record}
        case .TrackUrge:
            urges = urges.filter() { $0 !== record}
        }
    }
    
    private func grabTodaysRecordsWithSortType(sortType: TRTrackingType) {
        weak var weakSelf = self
        
        let RecordsRetrievalCompletion: PFArrayResultBlock = {
            (objects: [AnyObject]?, error: NSError?) in
            if let records = objects as? [TRRecord] {
                switch (sortType) {
                case .TrackAction:
                   weakSelf?.tracks = records
                case .TrackUrge:
                    weakSelf?.urges = records
                }
                
            } else {
                print(error)
            }
        }
        
        self.recordService.readAllRecordsFromPhoneWithSortType(sortType, completion: RecordsRetrievalCompletion)
    }
}