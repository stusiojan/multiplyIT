//
//  ContentView.swift
//  edutainment
//
//  Created by Jan Stusio on 11/03/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var numbersRange = [2...12]
    @State private var usersNumberOfChoice = 2
    @State private var numberOfQuestions = 0
    @State private var randomNumberToMultiplicate = Int.random(in: 2...12)
    @State private var correctAnswer = 0
    @State private var usersAnswer = ""
    @State private var answers = [5, 10, 20]
    @State private var isStartPressed = false
    @State private var alertName = ""
    @State private var alertMessage = ""
    @State private var answerCheck = false
    @State private var numOfQuestion = 0
    @State private var numOfCorrectAnswers = 0
    @State private var numOfWrongAnswers = 0
    @State private var isGameOver = false
    @State private var gameQuestionsNumber = 0
    @State private var rightOrWrongIndicator = false
    @State private var rightOrWrongIndicatorColor = false
    @FocusState private var answerIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Section{
                    HStack {
                        Stepper("Multiplication table for \(usersNumberOfChoice)", value: $usersNumberOfChoice, in: 2...12, step: 1)
                            .labelsHidden()
                        Spacer()
                    }
                } header: {
                    HStack {
                        Text("Multiplication table for")
                        Text("\(usersNumberOfChoice)")
                            .bold()
                        Spacer()
                    }
                }
                
                
                Section {
                    Picker("How many questions you want to be asked?", selection: $numberOfQuestions) {
                        ForEach(0..<3) {number in
                            Text("\(answers[number])")
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                } header: {
                    HStack {
                        Text("How many questions you want to be asked?")
                        Spacer()
                    }
                }
                
                Button("Start!") {
                    isStartPressed.toggle()
                    startGame()
                }
                .frame(maxWidth: isStartPressed ? .infinity : 80, maxHeight: 50)
                .background(isStartPressed ? .yellow : .blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .animation(.easeInOut(duration: 0.5), value: isStartPressed)
                
                VStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 70)
                            .frame(width: 350 ,height: 95)
                            .foregroundColor(rightOrWrongIndicatorColor ? .green : .red)
                            .opacity(rightOrWrongIndicator ? 1.0 : 0.0)
                            .scaleEffect(rightOrWrongIndicator ? 1 : 0.9)
                            .animation(.linear(duration: 1.1), value: rightOrWrongIndicator)
                        
                        HStack {
                            Text("\(usersNumberOfChoice) x \(randomNumberToMultiplicate) =")
                                .font(.title)
                            
                            TextField(
                                "answer",
                                text: $usersAnswer
                            )
                            .frame(width: 90)
                            .font(.title)
                            .keyboardType(.decimalPad)
                            .focused($answerIsFocused)
                            
                            Button("Check", action: checkAnswers)
                                .font(.headline)
                                .padding(35)
                                .background(.yellow)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.yellow, .white]), startPoint: .top, endPoint: .bottom))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .opacity(isStartPressed ? 1.0 : 0.0)
                .animation(.linear(duration: 1.1), value: isStartPressed)
            }
            .padding()
            .navigationTitle("multiplyIT")
            .alert(alertName, isPresented: $answerCheck) {
                Button("Next question", action: nextQuestion)
            } message: {
                Text(alertMessage)
            }
            .alert("Done!", isPresented: $isGameOver) {
                Button("Restart", action: restart)
            } message: {
                Text("You answered \(numOfCorrectAnswers) questions right and \(numOfWrongAnswers) wrong")
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Text("Correct: \(numOfCorrectAnswers)")
                    Text("Wrong: \(numOfWrongAnswers)")
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        answerIsFocused = false
                    }
                    
                    Button("Check") {
                        checkAnswers()
                    }
                }
            }
        }
    }
    func checkAnswers() {
        correctAnswer = usersNumberOfChoice * randomNumberToMultiplicate
        let usersStringAnswer = Int(usersAnswer) ?? 0
        
        if usersStringAnswer == correctAnswer {
            alertName = "Correct!"
            alertMessage = "That is a right answer"
            numOfCorrectAnswers += 1
            rightOrWrongIndicatorColor = true
        } else {
            alertName = "Wrong!"
            alertMessage = "Correct answer is \(correctAnswer)"
            numOfWrongAnswers += 1
            rightOrWrongIndicatorColor = false
        }
        
        answerCheck = true
        rightOrWrongIndicator = true
    }
    
    func startGame() {
        if numberOfQuestions == 0 {
            gameQuestionsNumber = answers[0]
        } else if numberOfQuestions == 1 {
            gameQuestionsNumber = answers[1]
        } else {
            gameQuestionsNumber = answers[2]
        }
    }
    
    func nextQuestion() {
        randomNumberToMultiplicate = Int.random(in: 2...12)
        numOfQuestion += 1
        answerCheck = false
        usersAnswer = ""
        rightOrWrongIndicator = false
        
        if gameQuestionsNumber == numOfQuestion {
            isGameOver = true
        }
    }
    
    func restart() {
        randomNumberToMultiplicate = Int.random(in: 2...12)
        answerCheck = false
        rightOrWrongIndicator = false
        usersAnswer = ""
        numOfCorrectAnswers = 0
        numOfWrongAnswers = 0
        gameQuestionsNumber = 0
        numOfQuestion = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
