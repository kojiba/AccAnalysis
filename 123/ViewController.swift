//
//  ViewController.swift
//  123
//
//  Created by kojiba on 23.12.16.
//  Copyright © 2016 kojiba. All rights reserved.
//

import UIKit
import CoreMotion
import Charts

class ViewController: UIViewController, UIAccelerometerDelegate {

    @IBOutlet weak var chart: LineChartView!

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var botLabel: UILabel!

    var manager = CMMotionManager()
    let updateTime = 0.1
    let gravityConstant = 9.80665

    var chartDataX: [ChartDataEntry] = [ChartDataEntry]()
    var chartDataY: [ChartDataEntry] = [ChartDataEntry]()
    var chartDataZ: [ChartDataEntry] = [ChartDataEntry]()

    var xSet: LineChartDataSet!
    var ySet: LineChartDataSet!
    var zSet: LineChartDataSet!

    var chartData: LineChartData!

    let threshold: Double = 0.002

    override func viewDidLoad() {
        super.viewDidLoad()

        chart.chartDescription?.text = "Accelerometer data"

        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = updateTime
            manager.deviceMotionUpdateInterval = updateTime

            manager.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion: CMDeviceMotion?, error: Error?) in

                if let acceleration = motion?.userAcceleration {

                    let updateTime = self.updateTime
                    let constant = updateTime * updateTime / 2

                    let formatter = NumberFormatter()
                    formatter.decimalSeparator = "."
                    formatter.maximumFractionDigits = 4
                    formatter.minimumFractionDigits = 4
                    formatter.minimumIntegerDigits = 1

                    self.topLabel.text = formatter.string(from: NSNumber(value: acceleration.x * constant))!
                    self.midLabel.text = formatter.string(from: NSNumber(value: acceleration.y * constant))!
                    self.botLabel.text = formatter.string(from: NSNumber(value: acceleration.z * constant))!

                    var xAcceleration = acceleration.x
                    var yAcceleration = acceleration.y
                    var zAcceleration = acceleration.z

                    let x = Double(self.chartDataX.count)

                    if abs(xAcceleration) < self.threshold {
                        xAcceleration = 0
                    }
                    if abs(yAcceleration) < self.threshold {
                        yAcceleration = 0
                    }
                    if abs(zAcceleration) < self.threshold {
                        zAcceleration = 0
                    }

                    var deltaX = 0.0
                    var deltaY = 0.0
                    var deltaZ = 0.0

                    if let last = self.chartDataX.last {
                        deltaX = last.y
                        deltaY = self.chartDataY.last!.y
                        deltaZ = self.chartDataZ.last!.y
                    }

                    let xa = xAcceleration * constant
                    let y = yAcceleration * constant
                    let z = zAcceleration * constant

                    print("x, y, z - \(xa), \(y), \(z)")
                    print("x + d, y + d, z + d - \(xa + deltaX), \(y + deltaY), \(z + deltaZ)")


                    self.chartDataX.append(ChartDataEntry(x: x, y: deltaX + xa))
                    self.chartDataY.append(ChartDataEntry(x: x, y: deltaY + y))
                    self.chartDataZ.append(ChartDataEntry(x: x, y: deltaZ + z))

                    self.refreshChartData()
                }

            }

//            if let queue = OperationQueue.current {
//                manager.startAccelerometerUpdates(to: queue) { (data: CMAccelerometerData?, error: Error?) in
//
//                    if let error = error {
//                        print(error)
//                        return
//                    }
//
//                    if let acceleration = data?.acceleration {
//
//                        let updateTime = self.updateTime
//                        let gravityConstant = self.gravityConstant
//                        let constant = updateTime * updateTime * gravityConstant
//
//                        let formatter = NumberFormatter()
//                        formatter.decimalSeparator = "."
//                        formatter.maximumFractionDigits = 4
//                        formatter.minimumFractionDigits = 4
//                        formatter.minimumIntegerDigits = 1
//
//                        self.topLabel.text = formatter.string(from: NSNumber(value: acceleration.x * constant))!
//                        self.midLabel.text = formatter.string(from: NSNumber(value: acceleration.y * constant))!
//                        self.botLabel.text = formatter.string(from: NSNumber(value: acceleration.z * constant))!
//
//                        let x = Double(self.chartDataX.count)
//                        self.chartDataX.append(ChartDataEntry(x: x, y: acceleration.x * constant))
//                        self.chartDataY.append(ChartDataEntry(x: x, y: acceleration.y * constant))
//                        self.chartDataZ.append(ChartDataEntry(x: x, y: acceleration.z * constant))
//
//                        self.removeOldData()
//
//                        self.refreshChartData()
//                    }
//                }
//            }
        } else {
            print("Accelerometer unavailable")
        }
    }

    func removeOldData() {
        if chartDataX.count > 300 {
            chartDataX.removeFirst(100)
            chartDataY.removeFirst(100)
            chartDataZ.removeFirst(100)
        }
    }

    func refreshChartData() {
//        if chart.data == nil {

            xSet = LineChartDataSet(values: chartDataX, label: "X")
            xSet.drawCirclesEnabled = false
            xSet.drawValuesEnabled = false
            xSet.colors = [NSUIColor(red: 205.0 / 255.0, green: 92.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)]

            ySet = LineChartDataSet(values: chartDataY, label: "Y")
            ySet.drawCirclesEnabled = false
            ySet.drawValuesEnabled = false
            ySet.colors = [NSUIColor(red: 130.0 / 255.0, green: 224.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)]

            zSet = LineChartDataSet(values: chartDataZ, label: "Z")
            zSet.drawCirclesEnabled = false
            zSet.drawValuesEnabled = false

            let dataSets = [
                    xSet,
                    ySet,
                    zSet,
            ]
            chartData = LineChartData(dataSets: dataSets as! [IChartDataSet])

            chart.data = chartData
//        } else {
//            xSet.values = chartDataX
//            ySet.values = chartDataY
//            zSet.values = chartDataZ
//            chartData.notifyDataChanged()
//        }
    }
}

