//
//  CompleteTaskInstanceViewController.swift
//  WellnexApp
//
//  Created by MacBook on 21.05.2025.
//

import UIKit

class CompleteTaskInstanceViewController: BaseViewController<CompleteTaskInstanceViewModel> {
    @IBOutlet weak var measureTypeNameLabel: UILabel!
    @IBOutlet weak var measureUnit: UILabel!
    @IBOutlet weak var slotLabel: UILabel!
    @IBOutlet weak var measureValue: UITextField!
    @IBOutlet weak var measureTypeImageView: UIImageView!
    @IBOutlet weak var measureDescriptionLabel: UILabel!
    
    weak var completeDelegate: CompleteTaskInstanceDelegate?
    
    var index: Int?
    var taskInstance: TaskInstanceModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = CompleteTaskInstanceViewModel()
        loadData()
        setOkButton()
    }
    
    func setTaskInstance(_ taskInstance: TaskInstanceModel, index: Int) {
        
        self.taskInstance = taskInstance
        self.index = index
    }
    
    private func loadData() {
        let slotText = "\(getTodayNameInTurkish()) / \(taskInstance?.slot ?? "00:00")"
        slotLabel.text = slotText
        measureValue.text = "\(taskInstance?.value ?? 0.0)"
        
        let measure = taskInstance?.measureTypeModel
        measureTypeNameLabel.text = measure?.label?.rawValue
        measureUnit.text = measure?.unit
        
        let description = "\(measure?.description ?? "") (\(measure?.minRecommended ?? 0)-\(measure?.maxRecommended ?? 0))"
        measureDescriptionLabel.text = description
        
        guard let measureType = measure?.label else {return}
        switch measureType {
        case .bloodSugar:
            measureTypeImageView.loadImageFromAssets(.bloodSugar)
        case .pulse:
            measureTypeImageView.loadImageFromAssets(.pulse)
        case .bodyTemperature:
            measureTypeImageView.loadImageFromAssets(.bodyTemperature)
        case .bloodPressure:
            measureTypeImageView.loadImageFromAssets(.bloodPressure)
        }
    }
    
    private func setOkButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(okButtonTapped))
    }
    
    private func getTodayNameInTurkish() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE" 
        return formatter.string(from: Date())
    }
    
    @objc func okButtonTapped() {
        guard let taskInstance else {return}
        let value = measureValue.text ?? ""
        
        viewModel?.postTaskInstance(value: value, taskInstance) { [weak self] newInstance in
            guard let self else {return}
            guard let newInstance else {return}
            
            self.postSucceeded(newInstance: newInstance)
        }
    }
    
    private func postSucceeded(newInstance: TaskInstanceModel) {
        guard let index else {return}
        
        completeDelegate?.taskInstanceComleted(newInstance, index: index)
        navigationController?.popViewController(animated: true)
    }



}
