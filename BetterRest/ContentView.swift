//
//  ContentView.swift
//  BetterRest
//
//  Created by Dhananjay Magdum on 02/10/21.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeup = defaultTime
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var bedTime = ""
    
    var body: some View {
        
        NavigationView {
            VStack{
            Form {
                Section(header: Text("When do you want to wake up?")) {
                DatePicker("Please select time", selection: $wakeup, displayedComponents:.hourAndMinute)
                    .labelsHidden()
                }
                Section(header: Text("Desired amount of Sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g")")
                    }
                }
                Section(header: Text("Daily Coffee Intake")) {
                    Picker("Please select coffee intake", selection: $coffeeAmount) {
                        ForEach(1...10, id: \.self) {coffeecups in
                            if coffeecups == 1 {
                                Text("1 cup")
                            } else {
                                Text("\(coffeecups) cups")
                            }
                        }
                    }
                }
            }
                Text("Your Bed time is : \(bedTime)")
                    .onAppear {
                        calculateBedTime()
                    }
                    
            }
            .navigationBarTitle("Better Rest")
//            .navigationBarItems(trailing:
//                                    Button(action: calculateBedTime, label: {
//                                        Text("Calculate")
//                                    })
//                                    .alert(isPresented: $showingAlert, content: {
//                                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                                    })
//            )
        }
    }
    
    static var defaultTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
    func calculateBedTime() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        let model = SleepCalculator()
        do {
        let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleeptime = wakeup - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
//            alertMessage = formatter.string(from: sleeptime)
//            alertTitle = "Your bed time is..."
            bedTime = formatter.string(from: sleeptime)
        } catch {
            alertTitle = "Error"
            alertMessage = "Error while calculating sleep time."
        }
//        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
