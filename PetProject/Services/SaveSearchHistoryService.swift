//
//  SaveSearchHistoryService.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 11.05.22.
//

import CoreData
import Combine

final class SaveSearchHistoryService: ObservableObject {
    @Published private(set) var history: [SearchReqestModel] = []
    private var container: NSPersistentContainer
    
    init() {
        self.container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { [weak self] description, error in
            if let error = error {
                print("Core data loding was failed with error: \(error)")
            } else {
                print("Core data was loaded succssfuly")
                self?.fetchSearchHistory()
            }
        }
    }
    
    private func fetchSearchHistory() {
        let reqest = NSFetchRequest<SavedSearchReqest>(entityName: "SavedSearchReqest")
        do {
            let savedReqests = try container.viewContext.fetch(reqest)
            history = savedReqests.compactMap({ SearchReqestModel(savedReqest: $0) })
        } catch (let error){
            print("Fetch saved search history error: \(error)")
        }
    }
    
    func saveSearchReqest(_ reqestModel: SearchReqestModel) {
        let reqestForSave = SavedSearchReqest(context: container.viewContext)
        reqestForSave.setByModel(reqestModel)
        saveData()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchSearchHistory()
        } catch(let error) {
            print("Save Core Data context error: \(error)")
        }
    }
}
