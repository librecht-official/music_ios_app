//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


public struct ExploreSummary: Decodable {
    public let recommendations: [Album]
    public let trending: [Album]
    public let popular: [Album]
}
