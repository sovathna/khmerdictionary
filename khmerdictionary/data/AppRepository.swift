//
// Created by Sovathna Hong on 9/9/22.
//

import Foundation
import SQLite
import Alamofire
import ZIPFoundation

final class AppRepository: ObservableObject {

    private var dbConnection: Connection? = nil
    private var session: Session? = nil

    private let pref = UserDefaults()
    private let fm = FileManager.default

    private let words = Table("words")
    private let idEx = Expression<Int64>("id")
    private let wordEx = Expression<String>("word")
    private let defEx = Expression<String>("definition")

    private var localDbConnection: Connection? = nil

    private let histories = Table("histories")
    private let bookmarks = Table("bookmarks")
    private let localIdEx = Expression<Int64>("local_id")


    init() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {

                if self.session == nil {
                    let config = URLSessionConfiguration.af.default
                    self.session = Session(configuration: config)
                }

                guard let dir = self.fm
                                    .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                                    .first
                else {
                    return
                }

                try self.fm.createDirectory(at: dir, withIntermediateDirectories: true)
                let dbPath = dir.appendingPathComponent("local.sqlite").path

                if self.localDbConnection == nil {
                    self.localDbConnection = try Connection(dbPath)
                }
                if let db = self.localDbConnection {
                    try db.run(self.histories.create(ifNotExists: true) { t in
                        t.column(self.localIdEx, primaryKey: true)
                        t.column(self.idEx, unique: true)
                        t.column(self.wordEx, unique: true)
                    })
                    try db.run(self.bookmarks.create(ifNotExists: true) { t in
                        t.column(self.localIdEx, primaryKey: true)
                        t.column(self.idEx, unique: true)
                        t.column(self.wordEx, unique: true)
                    })
                }
            } catch {
                print("Error opening database: \(error)")
            }
        }

    }

    func downloadFile(onProgress: @escaping (Double) -> Void, onDone: @escaping () -> Void) -> Request? {
        let dataVersion = getDataVersion()
        if dataVersion == 1 {
            onDone()
            return nil
        }

        if let dbPath = Const.dbPath, fm.fileExists(atPath: dbPath) {
            do {
                try fm.removeItem(atPath: dbPath)
            } catch {
                fatalError("cannot delete file: \(error)")
            }
        }

        guard let session = session else {
            return nil
        }
        return session
                .download(Const.DB_URL)
                .downloadProgress(queue: .global(qos: .userInitiated)) {
                    onProgress($0.fractionCompleted)
                }
                .response(queue: .global(qos: .userInitiated)) { response in
                    guard let zipUrl = response.fileURL,
                          let archive = Archive(url: zipUrl, accessMode: .read),
                          let entry = archive["data.sqlite"]
                    else {
                        return
                    }

                    do {
                        _ = try archive.extract(entry, to: Const.dbURL!)
                        self.setDataVersion(1)
                        onDone()
                    } catch {
                        fatalError("cannot extract file: \(error)")
                    }
                }
    }

    func addLocalWord(_ isHistories: Bool, _ wordId: Int64, _ word: String) {
        do {
            if let db = localDbConnection {
                let query = (isHistories ? histories : bookmarks)
                try db.run(query.insert(or: .replace, idEx <- wordId, wordEx <- word))
            }
        } catch {
            print("Error inserting word: \(error)")
        }
    }

    func deleteBookmark(_ wordId: Int64) {
        do {
            if let db = localDbConnection {
                try db.run(bookmarks.where(idEx == wordId).delete())
            }
        } catch {
            print("Error inserting word: \(error)")
        }
    }

    func getLocalWord(_ isHistories: Bool, _ wordId: Int64) -> WordUi? {
        do {
            guard let db = localDbConnection else {
                return nil
            }
            let query = (isHistories ? histories : bookmarks).where(idEx == wordId)
            guard let row = try db.pluck(query) else {
                return nil
            }
            return WordUi(id: row[idEx], word: row[wordEx])
        } catch {
            print("Error querying word: \(error)")
        }
        return nil
    }

    func getLocalWords(_ isHistories: Bool, _ page: Int, _ searchQuery: String) -> [WordUi] {
        do {
            if let db = localDbConnection {
                let query = (isHistories ? histories : bookmarks)
                        .filter(wordEx.like("\(searchQuery)%"))
                        .limit(Const.PAGE_SIZE, offset: (page - 1) * Const.PAGE_SIZE)
                        .select(idEx, wordEx)
                        .order(localIdEx.desc)

                return try db.prepare(query).map({ row in
                    WordUi(id: row[idEx], word: row[wordEx])
                })
            }
        } catch {
            print("Error querying words: \(error)")
        }
        return []
    }

    func getWords(_ page: Int, _ searchQuery: String) -> [WordUi] {
        do {
            if let dbPath = Const.dbPath, dbConnection == nil {
                dbConnection = try Connection(dbPath)
            }
        } catch {
            print("Error opening database: \(error)")
        }
        do {
            if let db = dbConnection {
                let query = words
                        .filter(wordEx.like("\(searchQuery)%"))
                        .limit(Const.PAGE_SIZE, offset: (page - 1) * Const.PAGE_SIZE)
                        .select(idEx, wordEx)
                        .order(wordEx)

                return try db.prepare(query).map({ row in
                    WordUi(id: row[idEx], word: row[wordEx])
                })
            }
        } catch {
            print("Error querying words: \(error)")
        }
        return []
    }

    func getDefinition(_ id: Int64) -> DefinitionUi? {
        do {
            if let db = dbConnection {
                let query = words
                        .where(idEx == id)
                return try db.prepare(query).map { row in
                    let def: String =
                        row[defEx].replacingOccurrences(of: "[HI]", with: "")
                                  .replacingOccurrences(of: "[HI1]", with: "")
                                  .replacingOccurrences(of: "[NewLine]", with: "\n\n")
                    var tmp: [DefWord] = []
                    def.components(separatedBy: "[]").forEach { str in
                        if str.contains("|") {
                            let sp = str.components(separatedBy: "|")
                            tmp.append(DefWord(id: Int64(sp[0]), value: sp[1]))
                        } else {
                            tmp.append(DefWord(value: str))
                        }
                    }

                    return DefinitionUi(id: row[idEx], word: row[wordEx], definition: tmp)
                }.first
            }
        } catch {
            print("Error querying definition: \(error)")
        }
        return nil
    }

    private let KEY_DATA_VERSION = "data_version"
    private let KEY_FONT_SIZE = "font_size"
    private let KEY_COLOR_SCHEME = "color_scheme"

    func setDataVersion(_ version: Int) {
        pref.set(version, forKey: KEY_DATA_VERSION)
    }

    func getDataVersion() -> Int {
        pref.integer(forKey: KEY_DATA_VERSION)
    }

    func setFontSize(_ fontSize: Float) {
        pref.set(fontSize, forKey: KEY_FONT_SIZE)
    }

    func getFontSize() -> Float {
        let fontSize = pref.float(forKey: KEY_FONT_SIZE)
        if fontSize == 0 {
            return 16
        }
        return fontSize
    }

    func setColorScheme(_ isDarkScheme: Bool) {
        pref.set(isDarkScheme, forKey: KEY_COLOR_SCHEME)
    }

    func isDarkScheme() -> Bool {
        let empty = pref.object(forKey: KEY_COLOR_SCHEME) == nil
        if empty {
            return true
        }
        return pref.bool(forKey: KEY_COLOR_SCHEME)
    }

}
