//
//  AssignTaskViewController.swift
//  WellnexApp
//
//  Created by MacBook on 14.05.2025.
//

import UIKit

class AssignTaskEndViewController: BaseViewController<AssignTaskEndViewModel> {
    @IBOutlet weak var daysOfWeeksCollectionView: UICollectionView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    private var days = DayOfWeek.allCases.map { $0.rawValue }
    private var selectedTimeSlotIndexes = [Int : [Int]]()
    private var measurement: MeasurementModel?
    private var relation: PatientDoctorRelationshipModel?
    private var taskNote = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AssignTaskEndViewModel()
        setStartDate()
        configurationCollectionView()
    }
    
    func setAssignStartInfos(_ measurement: MeasurementModel,_ relation: PatientDoctorRelationshipModel,_ note: String) {
        self.measurement = measurement
        self.relation = relation
        self.taskNote = note
    }
    
    func succeededAssignTask() {
        
    }
    
    private func postTaskModel(_ task: TaskModel) {
        guard !selectedTimeSlotIndexes.isEmpty else {
            viewModel?.failAnimation?("Gün Seçimi Boş Bırakılamaz")
            return
        }
        
        viewModel?.postTask(task) { [weak self] status in
            guard let self else {return}
            
            self.succeededAssignTask()
        }
        
    }
    
    private func createTaskModel() -> TaskModel? {
        
        guard let measureId = measurement?.id else {return nil}
        guard let patientId = relation?.patientId, let doctorId = relation?.doctorId else {return nil}
        guard let relationId = relation?.id else {return nil}
        
        let id = UUID().uuidString
        let doctorName = relation?.doctorName ?? ""
        let patientName = relation?.patientName ?? ""
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        let timeSlots: [String: [String]] = selectedTimeSlotIndexes.reduce(into: [:]) { result, pair in
            let (dayIndex, hourIndexes) = pair
            let day = DayOfWeek.allCases[dayIndex].rawValue
            let selectedSlots = hourIndexes.map { TimeSlotPeriod.allCases[$0].rawValue }
            result[day] = selectedSlots
        }

        return TaskModel(id: id, assignedBy: doctorName, assignedTo: patientName, description: taskNote, measureTypeId: measureId, patientId: patientId,doctorId: doctorId, relationId: relationId, startDate: startDate, endDate: endDate, timeSlots: timeSlots)
    }
    
    private func updateEndDatePicker(_ startDate: Date) {
        
        let calendar = Calendar.current
        endDatePicker.minimumDate = calendar.date(byAdding: .day, value: 7, to: startDate)
    }
    
    private func setStartDate() {
        
        let currentDate = Date()
        startDatePicker.minimumDate = currentDate
        updateEndDatePicker(currentDate)
    }
    
    private func configurationCollectionView() {
        if let layout = daysOfWeeksCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 5
            layout.sectionInset = .zero
        }
        
        daysOfWeeksCollectionView.allowsMultipleSelection = true
        
        daysOfWeeksCollectionView.dataSource = self
        daysOfWeeksCollectionView.delegate = self
        
        daysOfWeeksCollectionView.registerCellFromNib(DaySelectionCollectionViewCell.self)
    }
    
    private func pushSelectHoursViewController(indexPath: IndexPath) {
        
        let selectedHourIndexes = selectedTimeSlotIndexes[indexPath.row] ?? []
        let targetVc = AssignTaskSelectHourViewController.loadFromNib()
        
        targetVc.updateSelectedHours(selectedHourIndexes, dayIndexPath: indexPath)
        targetVc.selectedHoursDelegate = self
        
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    
    
    @IBAction func assignTaskButtonTapped(_ sender: Any) {
        
        guard let task = createTaskModel() else {return}
        postTaskModel(task)
    }
    
    
    @IBAction func startDateChanged(_ sender: Any) {
        
        updateEndDatePicker(endDatePicker.date)
    }
    
    @IBAction func endDateChanged(_ sender: Any) {
        
        
    }
}


extension AssignTaskEndViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = daysOfWeeksCollectionView.sameNameDequeueReusableCell(DaySelectionCollectionViewCell.self, indexPath: indexPath)
        let dayString = days[indexPath.row]
        
        let status = !(selectedTimeSlotIndexes[indexPath.row]?.isEmpty ?? true)
        
        cell.dayButtonTappedHandler = { [weak self] in
            guard let self else {return}
            
            self.pushSelectHoursViewController(indexPath: indexPath)
        }
        
        cell.loadCell(with: dayString, status: status)
        return cell
    }
    
    
}

extension AssignTaskEndViewController: HourSelectsionsDelegate {
    func updateHourSelectedIndexes(dayIndex:Int, hourSelectedIndexes: [Int]) {
        
        selectedTimeSlotIndexes[dayIndex] = hourSelectedIndexes
        daysOfWeeksCollectionView.reloadData()
    }
}
