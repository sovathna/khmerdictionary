//
// Created by Sovathna Hong on 9/9/22.
//

import Foundation


struct Const {
    static let PAGE_SIZE = 100
    static let DB_URL = "https://raw.githubusercontent.com/sovathna/database/main/data.zip"
    static let DB_FILE_NAME = "data.sqlite"

    static let dbURL = FileManager.default
                                  .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                                  .first?.appendingPathComponent(Const.DB_FILE_NAME)

    static var dbPath: String? {
        dbURL?.path
    }
}