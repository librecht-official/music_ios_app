//
//  Feedback.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback

typealias DriverFeedback<State, Command> = (Driver<State>) -> Signal<Command>
