//
//  AssignTaskSelectHourViewController.swift
//  WellnexApp
//
//  Created by MacBook on 17.05.2025.
//

import UIKit

class AssignTaskSelectHourViewController: BaseViewController<AssignTaskSelectHourViewModel> {
    @IBOutlet weak var hoursCollectionVeiw: UICollectionView!
    
    private var hours = TimeSlotPeriod.allCases.map {$0.rawValue}
    private var selectedHourIndexes = [Int]()
    private var selectedDayIndex: IndexPath?
    weak var selectedHoursDelegate: HourSelectsionsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = AssignTaskSelectHourViewModel()
        
        setupCollectionView()
    }
    
    func updateSelectedHours(_ updtSelectedHours: [Int], dayIndexPath: IndexPath) {
        
        selectedDayIndex = dayIndexPath
        
        selectedHourIndexes.removeAll()
        selectedHourIndexes = updtSelectedHours
    }
    
    private func setupCollectionView() {
        if let layout = hoursCollectionVeiw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 5
            layout.sectionInset = .zero
        }
        hoursCollectionVeiw.allowsMultipleSelection = true
        
        hoursCollectionVeiw.dataSource = self
        hoursCollectionVeiw.delegate = self
        
        hoursCollectionVeiw.registerCellFromNib(HourSelectionCollectionViewCell.self)
        
        selectedHourIndexes.forEach { index in
            let indexParh = IndexPath(row: index, section: 0)
            hoursCollectionVeiw.selectItem(at: indexParh, animated: false, scrollPosition: [])
        }
    }

    @IBAction func okeyButtonTapped(_ sender: Any) {
        guard let selectedDayIndex else {return}
        let selectedHourIndexes: [Int]  = hoursCollectionVeiw.indexPathsForSelectedItems?.map { $0.row} ?? []
        
        selectedHoursDelegate?.updateHourSelectedIndexes(dayIndex: selectedDayIndex.row, hourSelectedIndexes: selectedHourIndexes)
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension AssignTaskSelectHourViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = hoursCollectionVeiw.sameNameDequeueReusableCell(HourSelectionCollectionViewCell.self, indexPath: indexPath)
        
        cell.hourButtonTappedHandler = { [weak self] isSelected in
            guard let self else {return}
            
            if isSelected {
                self.hoursCollectionVeiw.selectItem(at: indexPath, animated: true, scrollPosition: [])
            } else {
                self.hoursCollectionVeiw.deselectItem(at: indexPath, animated: true)
            }
            
        }
        
        let index = indexPath.row
        let hourString = hours[index]
        
        let status = selectedHourIndexes.contains(index)
        
        cell.loadCell(with: hourString, status: status)
        
        return cell
    }
    
    
}
