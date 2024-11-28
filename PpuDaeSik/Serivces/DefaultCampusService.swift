//
//  DefaultCampusService.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import Foundation

protocol DefaultCampusService {
    /// 설정에서 지정한 기본 캠퍼스를 저장하는 함수
    func save(defaultCampus: Campus)
    
    /// 앱 시작 시 기본 캠퍼스를 불러오는 함수
    func loadDefaultCampus()
}

struct DefaultCampusServiceImpl: DefaultCampusService {
    let appState: Store<AppState>
    let defaultCampusRepository: DefaultCampusRepository
    
    func save(defaultCampus: Campus) {
        defaultCampusRepository.save(value: defaultCampus.rawValue)
    }
    
    func loadDefaultCampus() {
        let rawValue: String? = defaultCampusRepository.load()
        
        if let rawValue = rawValue, let defaultCampus = Campus(rawValue) {
            appState[\.tab.campus] = defaultCampus
            appState[\.userData.defaultCampus] = defaultCampus
        }
        else {
            appState[\.tab.campus] = .부산
            appState[\.userData.defaultCampus] = .부산
        }
    }
}

struct StubDefaultCampusService: DefaultCampusService {
    func save(defaultCampus: Campus) { }
    func loadDefaultCampus() { }
}
