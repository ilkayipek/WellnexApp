//
//  AssignTaskEndViewController.swift
//  WellnexApp
//
//  Created by MacBook on 16.05.2025.
//

import UIKit

class AssignTaskStartViewController: BaseViewController<AssignTaskStartViewModel> {
    
    @IBOutlet weak var measurementImageView: CustomUIImageView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var measureDescriptionLabel: UILabel!
    @IBOutlet weak var taskNoteTextView: UITextView!
    @IBOutlet weak var measureTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var measurementTypeContainer: CustomContainerUIView!
    @IBOutlet weak var taskNoteContainer: CustomContainerUIView!
    @IBOutlet weak var assignTaskButton: CustomUIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var measureTypes = [MeasurementModel]()
    private var relationModel: PatientDoctorRelationshipModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = AssignTaskStartViewModel()
        getMeasureTypes()
        keyboardAddObserver()
    }
    
    func setRelationModel(_ relationModel: PatientDoctorRelationshipModel) {
        self.relationModel = relationModel
    }
    
    private func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let gestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(gestureRecogizer)
    }
    
    private func getMeasureTypes() {
        viewModel?.fetchMeasurements { [weak self] results in
            guard let self else {return}
            
            self.measureTypes = results
            if !results.isEmpty {
                self.loadMeasurementData(results.first!)
                self.loadMeasureTypeSegmentControlData()
                self.makeVisibleContens()
            }
        }
    }
    
    private func makeVisibleContens() {
        measurementTypeContainer.isHidden = false
        taskNoteContainer.isHidden = false
        assignTaskButton.isHidden = false
    }
    
    private func loadMeasurementData(_ measurement: MeasurementModel) {
        unitLabel.text = measurement.unit
        
        let description = "\(measurement.description ?? "") (\(measurement.minRecommended ?? 0) - \(measurement.maxRecommended ?? 0))"
        measureDescriptionLabel.text = description
        
        let index = measurement.order - 1
        measureTypeSegmentControl.selectedSegmentIndex = index
        
        switch measurement.label {
        case .bloodSugar:
            measurementImageView.loadImageFromAssets(.bloodSugar)
        case .pulse:
            measurementImageView.loadImageFromAssets(.pulse)
        case .bodyTemperature:
            measurementImageView.loadImageFromAssets(.bodyTemperature)
        case .bloodPressure:
            measurementImageView.loadImageFromAssets(.bloodPressure)
        case .none:
            print("none")
        }
        
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    private func loadMeasureTypeSegmentControlData() {
        
        measureTypeSegmentControl.removeAllSegments()
        
        for (item, measurement) in measureTypes.enumerated() {
            
            let title = measurement.label?.rawValue
            measureTypeSegmentControl.insertSegment(withTitle: title, at: item, animated: true)
        }
    }
    
    @IBAction func measureTypeChanged(_ sender: UISegmentedControl) {
        
        let measurement = measureTypes[sender.selectedSegmentIndex]
        loadMeasurementData(measurement)
    }
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let relationModel else {return}
        
        let measurement = measureTypes[measureTypeSegmentControl.selectedSegmentIndex]
        let targetVc = AssignTaskEndViewController.loadFromNib()
        let note = taskNoteTextView.text ?? ""
        
        targetVc.setAssignStartInfos(measurement, relationModel, note)
        
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
}
