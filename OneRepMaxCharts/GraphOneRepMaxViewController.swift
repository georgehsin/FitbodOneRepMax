//
//  GraphOneRepMaxViewController.swift
//  OneRepMaxCharts
//
//  Created by George Hsin on 10/23/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import Charts

class GraphOneRepMaxViewController: UIViewController {
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseAllTimeMax: UILabel!
    @IBOutlet weak var lineChartView: UIView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var exercise: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let graphOneRepMaxData = WorkoutData.sharedInstance.dictData[exercise]
        DispatchQueue.global(qos: .userInteractive).async {
            self.createLineChart(lineData: graphOneRepMaxData!, chart: self.lineChartView as! LineChartView)
        }
        exerciseAllTimeMax.text = String(graphOneRepMaxData![0].1)
        exerciseNameLabel.text = exercise!
        setChartUI(chart: lineChartView as! LineChartView)
        axisFormatDelegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChartUI(chart: LineChartView) {
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawAxisLineEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.xAxis.labelTextColor = UIColor.white
        chart.doubleTapToZoomEnabled = false
        chart.pinchZoomEnabled = false
        chart.dragEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.legend.enabled = false
        chart.xAxis.enabled = false
        
//        chart.rightAxis.granularity = Double(exerciseAllTimeMax.text!)!
        chart.rightAxis.drawLabelsEnabled = false
//        chart.rightAxis.drawTopYLabelEntryEnabled = true
//        chart.rightAxis.drawBottomYLabelEntryEnabled = true
        chart.rightAxis.labelCount = 2
        chart.rightAxis.labelPosition = YAxis.LabelPosition.insideChart
        chart.rightAxis.labelTextColor = UIColor.white
        
    }
    
    func createLineChart(lineData: [(String, Int)], chart: LineChartView) {
        var dataEntries: [ChartDataEntry] = []
        for i in (1..<lineData.count).reversed() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
            let date = dateFormatter.date(from: lineData[i].0)
            let dateValue = date!.timeIntervalSince1970
            let val = lineData[i].1
            let dataEntry = ChartDataEntry(x: Double(dateValue), y: Double(val))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "")
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = [UIColor.white]
        chartDataSet.circleColors = [UIColor.white]
        chartDataSet.circleHoleColor = UIColor.black
        chartDataSet.circleRadius = 4.0
        chartDataSet.circleHoleRadius = 2.0
        
        let chartData = LineChartData(dataSet: chartDataSet)
        chart.data = chartData
        chart.xAxis.valueFormatter = axisFormatDelegate
        chart.xAxis.enabled = true
    }

}

// MARK: axisFormatDelegate
extension GraphOneRepMaxViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
