//
//  FavoriteAnimalCoreDataClass.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 20/01/24.
//

import Foundation
import CoreData

@objc(Favorites)
public class Favorites: NSManagedObject {}

extension Favorites {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorite")
    }

    @NSManaged public var animalType: String?
    @NSManaged public var height: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var locations: String?
    @NSManaged public var weight: String?
    @NSManaged public var createdDate: String?
    @NSManaged public var id: String?
    @NSManaged public var animalName: String?

    internal class func createOrUpdate(item: FavoriteAnimalDataModel) {
        let context = AppDelegate.sharedAppDelegate.persistentContainer.viewContext
        let dataOfEntity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)!
        let listOfEntity = NSManagedObject(entity: dataOfEntity, insertInto: context)

        listOfEntity.setValue(item.id, forKey: "id")
        listOfEntity.setValue(item.createdDate, forKey: "createdDate")
        listOfEntity.setValue(item.animalType, forKey: "animalType")
        listOfEntity.setValue(item.height, forKey: "height")
        listOfEntity.setValue(item.imageUrl, forKey: "imageUrl")
        listOfEntity.setValue(item.locations, forKey: "locations")
        listOfEntity.setValue(item.weight, forKey: "weight")
        listOfEntity.setValue(item.animalName, forKey: "animalName")

        do {
            try context.save()
        } catch let error as NSError {
            Dlog("Create error: \(error) description: \(error.userInfo)")
        }
    }

    internal class func retrieveData() -> [FavoriteAnimalDataModel] {
        var tempValue: [FavoriteAnimalDataModel] = []
        let context = AppDelegate.sharedAppDelegate.persistentContainer.viewContext

        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        let sort = NSSortDescriptor(key: "createdDate", ascending: true)
        fetch.sortDescriptors = [sort]

        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                tempValue.append(FavoriteAnimalDataModel(
                    animalType: data.value(forKey: "animalType") as? String,
                    height: data.value(forKey: "height") as? String,
                    imageUrl: data.value(forKey: "imageUrl") as? String,
                    locations: data.value(forKey: "locations") as? String,
                    weight: data.value(forKey: "weight") as? String,
                    createdDate: data.value(forKey: "createdDate") as? String,
                    id: data.value(forKey: "id") as? String,
                    animalName: data.value(forKey: "animalName") as? String
                ))
            }
        } catch let error as NSError {
            Dlog("Fetch error: \(error) description: \(error.userInfo)")
        }

        return tempValue
    }

    internal class func deleteData(_ type: String) {
        let context = AppDelegate.sharedAppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "animalName == %@", type)

        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                context.delete(data)
            }

            try context.save()
        } catch let error as NSError {
            Dlog("Delete error: \(error) description: \(error.userInfo)")
        }
    }
}
