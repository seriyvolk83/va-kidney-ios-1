//
//  FoodServiceCache.swift
//  VAKidneyNutrition
//
//  Created by TCCODER on 12/25/17.
//  Copyright © 2017 Topcoder. All rights reserved.
//

import UIKit
import CoreData

/**
 * Model object for Core Data related to Goal
 *
 * - author: TCCODER
 * - version: 1.0
 */
extension FoodMO: CoreDataEntity {

    public typealias Entity = Food

    /// Convert to enity
    ///
    /// - Returns: the entity
    public func toEntity() -> Food {
        let object = Food(id: self.id ?? "")
        updateEntity(object: object)

        object.time = FoodIntakeTime(rawValue: (time ?? "").lowercased()) ?? .breakfast
        object.items = items ?? ""
        object.date = date ?? Date()

        object.image = UIImage(data: image ?? Data())
        return object
    }

    /// Update fields from given object
    ///
    /// - Parameters:
    ///   - object: the object
    ///   - relatedObjects: the related objects
    public func fillDataFrom(_ object: Food, relatedObjects: Any?) {
        super.fillDataFromCacheableObject(object, relatedObjects: relatedObjects)

        time = object.time.rawValue
        items = object.items
        date = object.date
        image = object.image?.toData()
        userId = AuthenticationUtil.sharedInstance.userInfo?.id ?? ""
    }
}

/**
 * Service caching Profile data
 *
 * - author: TCCODER
 * - version: 1.0
 */
class FoodServiceCache: DataService<FoodMO, Food> {

    /// Get all food for the current user
    ///
    /// - Parameters:
    ///   - callback: the callback used to return data
    ///   - failure: the failure callback used to return an error
    func getAll(callback: @escaping ([Food])->(), failure: @escaping GeneralFailureBlock) {
        let fetchRequest = NSFetchRequest<FoodMO>(entityName: FoodMO.entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = self.createStringPredicate("userId", value: AuthenticationUtil.sharedInstance.userInfo?.id ?? "")
        self.get(withRequest: fetchRequest, callback, failure: failure)
    }
}
