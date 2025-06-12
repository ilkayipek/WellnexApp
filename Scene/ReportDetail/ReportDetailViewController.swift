//
//  ReportDetailViewController.swift
//  WellnexApp
//
//  Created by MacBook on 3.06.2025.
//

import UIKit

class ReportDetailViewController: BaseViewController<ReportDetailViewModel> {
    @IBOutlet weak var measureTypeImageView: CustomUIImageView!
    @IBOutlet weak var circularProgressView: CustomCircularProgressView!
    
    @IBOutlet weak var assignedByLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var assignedToLabel: UILabel!
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var createdByDateLabel: UILabel!
    @IBOutlet weak var defaultMaxValueLabel: UILabel!
    @IBOutlet weak var defaultMinValueLabel: UILabel!
    
    @IBOutlet weak var statCardCollectionView: UICollectionView!
    
    @IBOutlet weak var aiContainerView: UIView!
    @IBOutlet weak var aiAnalysisDetailLabel: UILabel!
    
    private var reportModel: ReportModel?
    private var statCards = [StatCardModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ReportDetailViewModel()
        configureCollectionView()
        loadReport()
    }
    
    func setReportModel(_ report: ReportModel) {
        reportModel = report
    }
    
    private func loadReport() {
        guard let reportModel else {return}
        guard let task = reportModel.taskModel else {return}
        guard let measureType = task.measureTypeModel else {return}
        
        
        measureLabel.text = "\(measureType.label?.rawValue ?? "") Ölçümü Raporu"
        measureTypeImageView.loadMeasureTypeImage(measureType.label ?? .pulse)
        
        assignedByLabel.text = "\(task.assignedBy)"
        assignedToLabel.text = "\(task.assignedTo)"
        
        let defaultMax = measureType.maxRecommended ?? 0
        let defaultMin = measureType.minRecommended ?? 0
        
        defaultMaxValueLabel.text = "\(defaultMax) \(measureType.unit ?? "")"
        defaultMinValueLabel.text = "\(defaultMin) \(measureType.unit ?? "")"
        
        let taskDateRange = "\(task.startDate.getDayMonthYear()) - \(task.endDate.getDayMonthYear())"
        dateRangeLabel.text = taskDateRange
        createdByDateLabel.text = reportModel.createdAt.getDayMonthYear()
        
        if let completion = reportModel.completionRate {
            circularProgressView.setProgress(to: CGFloat(completion) / 100, animated: true)
        }
        
        let highest = reportModel.highestValue ?? 0
        let lowest = reportModel.lowestValue ?? 0
        let average = reportModel.averageValue ?? 0
        let inRange = reportModel.inRangeCount ?? 0
        let aboveRange = reportModel.aboveRangeCount ?? 0
        let belowRangeCount = reportModel.belowRangeCount ?? 0
        
        let highestColor =  highest > (defaultMax) ? UIColor.red : .activePrimaryButtonColor
        let lowestColor = lowest < (defaultMin) ? UIColor.red : .activePrimaryButtonColor
        let averageColor = highest > defaultMax || lowest < defaultMin ? UIColor.red : .gray
        
        statCards = [
            StatCardModel(title: "En Yüksek Ölçüm",
                          value: "\(highest) \(measureType.unit ?? "")",
                          imageName: "arrow.up.circle.fill", color: highestColor),
            
            StatCardModel(title: "En Düşük Ölçüm",
                          value: "\(lowest) \(measureType.unit ?? "")",
                          imageName: "arrow.down.circle.fill", color: lowestColor
                         ),
            
            StatCardModel(title: "Ortalama Değer",
                          value: "\(average) \(measureType.unit ?? "")",
                          imageName: "chart.bar.xaxis", color: averageColor
                         ),
            
            StatCardModel(title: "Normal Değer",
                          value: "\(inRange) ölçüm",
                          imageName: "checkmark.circle.fill",
                          color: .activePrimaryButtonColor
                         ),
            StatCardModel(title: "Yüksek Ölçüm Sayısı",
                          value: "\(aboveRange) ölçüm",
                          imageName: "arrow.up.circle.fill",
                          color: highestColor
                         ),
            StatCardModel(title: "Düşük Ölçüm Sayısı",
                          value: "\(belowRangeCount) adet",
                          imageName: "arrow.down.circle.fill",
                          color: lowestColor
                         )
        ]
        
        statCardCollectionView.reloadData()
        
        // Yapay Zeka analizi örneği (örnek metin)
        if reportModel.isComplete {
            aiAnalysisDetailLabel.text = "Bu rapor başarıyla tamamlandı. Sonuçlar değerlendiriliyor."
            aiContainerView.isHidden = false
        } else {
            aiAnalysisDetailLabel.text = "Rapor henüz tamamlanmadı. Yetersiz veri olabilir."
            aiContainerView.isHidden = false
        }
    }
    
    
    private func configureCollectionView() {
        
        if let layout = statCardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 5
        }
        
        statCardCollectionView.delegate  = self
        statCardCollectionView.dataSource = self
        
        statCardCollectionView.registerCellFromNib(StatCardCollectionViewCell.self)
    }
    
    
}

extension ReportDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = statCardCollectionView.sameNameDequeueReusableCell(StatCardCollectionViewCell.self, indexPath: indexPath)
        let card = statCards[indexPath.row]
        cell.loadCell(card)
        
        return cell
    }
    
    
}
