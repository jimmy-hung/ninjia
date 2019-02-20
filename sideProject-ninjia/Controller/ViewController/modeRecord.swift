//
//  record.swift
//  sideProject-ninjia
//
//  Created by 洪立德 on 2019/2/20.
//  Copyright © 2019 蘇 郁傑. All rights reserved.
//
import UIKit

enum attackSpeed{
    case S6
    case S12
    case S24
}

enum weaponType{
    case BrownLevelOne
    case GreenLevelTwo
    case BlueLevelThree
}

enum characterChoice{
    case TheOldMan
    case TheHuman
    case TheZombie
}

enum theSunRise{
    case LevelOne
    case LevelTwo
    case LevelThree
    case LevelFour
    case LevelFive
}

var currentAttackSpeed     :attackSpeed = .S6
var currentWeaponType      :weaponType    = .BrownLevelOne
var currentCharacterChoice :characterChoice = .TheOldMan
var currentSunRise         :theSunRise  = .LevelOne

var starCollect = UserDefaults().integer(forKey: "Star")
