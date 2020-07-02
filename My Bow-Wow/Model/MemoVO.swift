import Foundation
import UIKit
import CoreData

class MemoVO {
    var memoIdx : Int? // 데이터 식별값
    var title: String? // 메모 제목
    var contents: String? // 메모 내용
    var image: UIImage? // image
    var regdate: Date? // 작성일
    // 하나의 MemoMO 인스턴스를 가리키기 위한 변수.
    var objectID: NSManagedObjectID?
}

