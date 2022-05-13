//
//  main.swift
//  CodeStarterCamp_Week4
//
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

class FitnessCenter {
    let name: String
    var goalsBodyCondition: BodyCondition?
    var member: Person?
    var chosenRoutine: Routine?
    var decidedSet: Int?
    var routines: [Routine]
    let fitnessCenterKiosk = FitnessCenterKiosk()
    
    init(name: String, routines: Routine...) {
        self.name = name
        self.routines = routines
    }
    
    func startFitnessKiosk() throws {
        var isAchieveGoal = false
        var kioskStep = 1
        print(newLineString)
        print("안녕하세요. \(name) Fitness Center 입니다.")
        while !isAchieveGoal {
            if kioskStep == 1 {
                member = nil
                registerMember()
                if member != nil {
                    kioskStep += 1
                }
            } else if kioskStep == 2 {
                goalsBodyCondition = nil
                setGoals()
                if goalsBodyCondition != nil {
                    kioskStep += 1
                }
            } else if kioskStep == 3 {
                chosenRoutine = nil
                choseRoutine()
                if chosenRoutine != nil {
                    kioskStep += 1
                }
            } else {
                decidedSet = nil
                dicideSet()
                if decidedSet != nil {
                    
                }
                guard let chosenRoutine = chosenRoutine else {
                    throw FitnessCenterError.emptyChosenRoutine
                }
                guard let member = member else {
                    throw FitnessCenterError.emptyMember
                }
                if let chosenNumberOfSet = fitnessCenterKiosk.receiveNaturalNumber() {
                    do {
                        try member.exercise(for: chosenNumberOfSet, chosenRoutine)
                        if try checkGoals(target: member.bodyCondition) {
                            isAchieveGoal = true
                        } else {
                            kioskStep = 3
                        }
                        printRoutineAchieveMessage(isAchieveGoal)
                        member.printMyBodyCondition()
                    } catch PersonError.personBeDrained {
                        throw FitnessCenterError.memberBeDrained
                    } catch FitnessCenterError.emptyGoalsBodyCondition {
                        throw FitnessCenterError.emptyGoalsBodyCondition
                    }
                }
            }
        }
    }
    
    func registerMember() {
        fitnessCenterKiosk.printMessageByStep(nowStep: 1)
        if let memberName = fitnessCenterKiosk.receiveEnglishName() {
            setMember(with: memberName)
        }
    }
    
    func setGoals() {
        fitnessCenterKiosk.printMessageByStep(nowStep: 2)
        if let goals = fitnessCenterKiosk.receiveGoals() {
            if goals.count == 3 {
                setGoalsBodyCondition(by: goals)
            }
        }
    }
    
    func choseRoutine() {
        chosenRoutine = nil
        fitnessCenterKiosk.printMessageByStep(nowStep: 3)
        introduceRoutines()
        if let chosenNumberOfRoutine = fitnessCenterKiosk.receiveNaturalNumber() {
            chosenRoutine = routines[chosenNumberOfRoutine-1]
        }
    }
    
    func dicideSet() {
        fitnessCenterKiosk.printMessageByStep(nowStep: 4)
        if let naturalNumber = fitnessCenterKiosk.receiveNaturalNumber() {
            decidedSet = naturalNumber
        }
    }
    
    func startMemberExercise() throws {
        guard let member = member else {
            throw FitnessCenterError.emptyMember
        }
        guard let chosenRoutine = chosenRoutine else {
            throw FitnessCenterError.emptyChosenRoutine
        }
        guard let decidedSet = decidedSet else {
            throw FitnessCenterError.emptyDecidedSet
        }
        do {
            try member.exercise(for: decidedSet, chosenRoutine)
        } catch PersonError.personBeDrained {
            throw FitnessCenterError.memberBeDrained
        }
    }
    
    func setMember(with name: String) {
        member = Person(name: name, bodyCondition: BodyCondition(upperBodyStrength: 30, lowerBodyStrength: 30, muscleEndurance: 10))
    }
    
    func setGoalsBodyCondition(by goals: [Int]) {
        goalsBodyCondition = BodyCondition(upperBodyStrength: goals[0], lowerBodyStrength: goals[1], muscleEndurance: goals[2])
    }
    
    func introduceRoutines() {
        for routineCount in 1...routines.count {
            print("\(routineCount). \(routines[routineCount-1].name)")
        }
    }
    
    func checkGoals(target bodyCondition: BodyCondition) throws -> Bool {
        if let goalsBodyCondition = goalsBodyCondition {
            if goalsBodyCondition.upperBodyStrength <= bodyCondition.upperBodyStrength && goalsBodyCondition.lowerBodyStrength <= bodyCondition.lowerBodyStrength && goalsBodyCondition.muscleEndurance <= bodyCondition.muscleEndurance {
                return true
            } else {
                return false
            }
        }
        throw FitnessCenterError.emptyGoalsBodyCondition
    }
    
    func printRoutineAchieveMessage(_ isAchieve: Bool) {
        print(newLineString)
        if isAchieve {
            print("축하합니다. 목표를 달성하셨습니다! ", terminator: "")
        } else {
            print("목표치에 도달하지 못했습니다! ", terminator: "")
        }
    }
}
