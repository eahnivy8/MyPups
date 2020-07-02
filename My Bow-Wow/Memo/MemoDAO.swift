import Foundation
import CoreData
import UIKit

class MemoDAO {
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    func fetch() -> [MemoVO] {
        var memoList = [MemoVO]()
        let fetchRequest: NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        do {
            let resultset = try self.context.fetch(fetchRequest)
            for record in resultset {
                let data = MemoVO()
                data.title = record.title
                data.contents = record.contents
                data.regdate = record.regdate! as Date
                data.objectID = record.objectID
                if let image = record.image as Data? {
                    data.image = UIImage(data: image)
                }
                memoList.append(data)
            }
        } catch let e as NSError {
            e.description
        }
        return memoList
    }
    
    func insert(_ data: MemoVO) {
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        object.title = data.title
        object.contents = data.contents
        object.regdate = data.regdate!
        if let image = data.image {
            object.image = image.pngData()!
        }
        do {
            try self.context.save()
        } catch let e as NSError {
            e.description
        }
    }
    func delete(_ objectID: NSManagedObjectID) -> Bool {
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        do {
            try self.context.save()
            return true
        } catch let e as NSError {
            e.description
            return false
        }
    }
}
