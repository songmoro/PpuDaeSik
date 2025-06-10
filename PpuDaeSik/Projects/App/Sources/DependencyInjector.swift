//
//  DependencyInjector.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

//import SwiftUI
//import UseCases
//import UseCasesImpls
//import Repositories
//import RepositoriesImpls
//import Presentation
//import Shared
//
//struct DIContainer: EnvironmentKey {
//    let appState: Store<AppState>
//    let useCases: UseCases
//    
//    init(appState: Store<AppState>, useCases: DIContainer.UseCases) {
//        self.appState = appState
//        self.useCases = useCases
//    }
//    
//    init(appState: AppState, useCases: DIContainer.UseCases) {
//        self.init(appState: Store(appState), useCases: useCases)
//    }
//    
//    static var defaultValue: Self { Self.default }
//    private static let `default` = Self(appState: AppState(), useCases: .stub)
//}
//
//extension DIContainer {
//    struct Repositories {
//        let cafeteriaFetchRepository: CafeteriaFetchRepository
//        let cafeteriaCacheRepository: CafeteriaCacheRepository
//        let bookmarkRepository: BookmarkRepository
//        let defaultCampusRepository: DefaultCampusRepository
//    }
//}
//
//extension DIContainer {
//    struct UseCases {
//        let cafeteria: CafeteriaUseCases
//        let bookmark: BookmarkUseCases
//        let defaultCampus: DefaultCampusUseCases
//        
//        static var stub: Self {
//            .init(
//                cafeteria: StubCafeteriaUseCases(),
//                bookmark: StubBookmarkUseCases(),
//                defaultCampus: StubDefaultCampusUseCases()
//            )
//        }
//    }
//}
//
////extension DIContainer {
////    private static var cancelBag = CancelBag()
////    
////    func makeMainViewViewModel() -> MainView.ViewModel {
////        let vm = MainView.ViewModel(
////            useCases: .init(
////                cafeteriaUseCases: useCases.cafeteria,
////                bookmarkUseCases: useCases.bookmark,
////                defaultCampusUseCases: useCases.defaultCampus
////            ),
////            input: .init(
////                routingState: appState.updates(for: \.routing.mainViewRouting),
////                cafeteriaList: appState.updates(for: \.cafeteria.list),
////                weekComponent: appState.updates(for: \.tab.weekComponent),
////                cafeteriaMenus: appState.updates(for: \.cafeteria.menus),
////                filterByDay: appState.updates(for: \.cafeteria.filterByDay),
////                selectedCampus: appState.updates(for: \.tab.campus),
////                defaultCampus: appState.updates(for: \.userData.defaultCampus),
////                bookmark: appState.updates(for: \.userData.bookmark)
////            )
////        )
////        let output = vm.makeOutput()
////        
////        DIContainer.cancelBag.collect {
////            output.routingState
////                .removeDuplicates()
////                .sink {
////                    appState[\.routing.mainViewRouting] = $0
////                }
////            output.bookmark
////                .removeDuplicates()
////                .sink {
////                    appState[\.userData.bookmark] = $0
////                }
////            output.selectedCampus
////                .removeDuplicates()
////                .sink {
////                    appState[\.tab.campus] = $0
////                }
////            output.defaultCampus
////                .removeDuplicates()
////                .sink {
////                    appState[\.userData.defaultCampus] = $0
////                }
////            output.cafeteriaList
////                .removeDuplicates()
////                .sink {
////                    appState[\.cafeteria.list] = $0
////                }
////            output.cafeteriaMenus
////                .removeDuplicates()
////                .sink {
////                    appState[\.cafeteria.menus] = $0
////                }
////            output.filterByDay
////                .removeDuplicates()
////                .sink {
////                    appState[\.cafeteria.filterByDay] = $0
////                }
////        }
////        
////        return vm
////    }
////}
//
////extension EnvironmentValues {
////    var injected: DIContainer {
////        get { self[DIContainer.self] }
////        set { self[DIContainer.self] = newValue }
////    }
////}
//
//extension DIContainer {
//    static var preview: Self {
//        //        .init(appState: AppState.preview, services: .stub, useCases: .stub)
//        .init(appState: AppState.preview, useCases: .stub)
//    }
//}
