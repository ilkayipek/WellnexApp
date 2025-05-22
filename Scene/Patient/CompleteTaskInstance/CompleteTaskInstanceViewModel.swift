//
//  CompleteTaskInstanceViewModel.swift
//  WellnexApp
//
//  Created by MacBook on 21.05.2025.
//

class CompleteTaskInstanceViewModel: BaseViewModel {
    
    func postTaskInstance(value: String,_ instance: TaskInstanceModel,_ closure: @escaping(TaskInstanceModel?)->Void ) {
        guard let instanveValue = convertDouble(instanceValue: value) else {
            closure(nil); return
        }
        var newInstance = instance
        newInstance.value = instanveValue
        newInstance.isCompleted = true
        
        let network = Network.shared
        
        loadingAnimationStart?("")
        network.post(newInstance, to: .taskInstances) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(_):
                closure(newInstance)
            case .failure(let failure):
                
                let errorMsg = "HATA: \(failure.localizedDescription)"
                print(errorMsg)
                self.failAnimation?(errorMsg)
                closure(nil)
            }
            
            self.loadingAnimationStop?()
        }
    }
    
    private func convertDouble(instanceValue: String) -> Double? {
        guard !instanceValue.isEmpty else {
            failAnimation?("Değer Alanı Boş Bırakılamaz")
            return nil
        }
        
        let dotText = instanceValue.replacingOccurrences(of: ",", with: ".")
        guard let doubleValue = Double(dotText) else {return nil}
        
        return doubleValue
    }
}
 
