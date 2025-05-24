//
//  AssignedTaskDetailViewController.swift
//  WellnexApp
//
//  Created by MacBook on 23.05.2025.
//

import UIKit

class AssignedTaskDetailViewController: BaseViewController<AssignedTaskDetailViewModel> {
    @IBOutlet weak var measureTypeImageView: UIImageView!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var startDateEndDateLabel: UILabel!
    @IBOutlet weak var doctorNoteTitleLabel: UILabel!
    @IBOutlet weak var assignedByLabel: UILabel!
    @IBOutlet weak var assignedToLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    private var task: TaskModel?
    private var days = [String]()
    private var hours = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = AssignedTaskDetailViewModel()
        daysCollectionViewConfigure()
        loadTaskDetails()
    }
    
    func loadTaskData(_ task: TaskModel) {
        self.task = task
        
        days = task.timeSlots.keys.sorted()
        hours = task.timeSlots.values.count > 0 ? Array(task.timeSlots.values) : []
    }
    
    func loadTaskDetails() {
        guard let task = task else { return }
        guard let measure = task.measureTypeModel else { return }
        
        measureTypeImageView.loadMeasureTypeImage(measure.label ?? .pulse)
        measureLabel.text = "\(measure.label?.rawValue ?? "") Ölçümü"
        
        let startDateStr = task.startDate.getDayMonthYear()
        let endDateStr = task.endDate.getDayMonthYear()
        
        startDateEndDateLabel.text = "\(startDateStr) - \(endDateStr)"
        doctorNoteTitleLabel.text = task.description
        assignedByLabel.text = task.assignedBy
        assignedToLabel.text = task.assignedTo
        
    }
    
    func daysCollectionViewConfigure() {
        
        if let layout = daysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            
        }
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        
        daysCollectionView.registerCellFromNib(DaySelectionCollectionViewCell.self)
    }

}

extension AssignedTaskDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysCollectionView.sameNameDequeueReusableCell(DaySelectionCollectionViewCell.self, indexPath: indexPath)
        let day = days[indexPath.row]
        
        cell.loadCell(with: day, status: true)
        cell.dayButton.isUserInteractionEnabled = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let slots = hours[indexPath.row]
        let allSlots = TimeSlotPeriod.allCases.compactMap(\.rawValue)
        let selectedSlots: [Int] = slots.compactMap { allSlots.firstIndex(of: $0) }
        
        let targetVc = AssignTaskSelectHourViewController.loadFromNib()
        
        targetVc.updateSelectedHours(selectedSlots, dayIndexPath: indexPath)
        targetVc.sheetPresentationController?.detents = [.medium(), .large()]
        present(targetVc, animated: true)
        
    }
    
    
    
    
}
