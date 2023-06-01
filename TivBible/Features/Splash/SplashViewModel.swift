//
//  SplashViewModel.swift
//  TivBible
//
//  Created by Isaac Iniongun on 01/06/2023.
//

import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
    
    private let booksDataStore: BooksDataStore
    private let chaptersDataStore: ChaptersDataStore
    private let versesDataStore: VersesDataStore
    
    @Published var dbInitializationInProgress: Bool = false
    
    init(booksDataStore: BooksDataStore = .shared,
         chaptersDataStore: ChaptersDataStore = .shared,
         versesDataStore: VersesDataStore = .shared
    ) {
        self.booksDataStore = booksDataStore
        self.chaptersDataStore = chaptersDataStore
        self.versesDataStore = versesDataStore
    }
    
    func initializeDB() async throws {
        dbInitializationInProgress = true
        var bibleData = [TivBibleData]()
        
        do {
            bibleData = try await getBibleData() ?? []
        } catch {
            print("unable to get local bible data from json file \(error)")
        }
        
        guard bibleData.isNotEmpty else { return }
        
        Task() {
            let bibleBooks = bibleData.distinctBy { $0.book }.sorted { $0.orderNo < $1.orderNo }
            
            var books = [Book]()
            var allChapters = [Chapter]()
            var allVerses = [Verse]()
            
            bibleBooks.forEach { book in
                
                let bookOccurrences = bibleData.filter { $0.book == book.book }
                
                let bookChapters = bookOccurrences.distinctBy { $0.chapter }
                
                var newBook = Book(
                    name: book.book.lowercased().capitalized,
                    order: book.orderNo,
                    testament: Testament.old.rawValue,
                    version: Version.old.rawValue
                )
                
                var newChapters = [Chapter]()
                var newVerses = [Verse]()
                
                bookChapters.forEach { chapter in
                    
                    let bookChapterVerses = bookOccurrences.filter { $0.chapter == chapter.chapter }.distinctBy { $0.verse }
                    
                    //create and add chapter to chapters list
                    var newChapter = Chapter(number: chapter.chapter, book: newBook)
                    newChapters.append(newChapter)
                    
                    //create verses
                    let verses = bookChapterVerses.map {
                        Verse(title: $0.title.components(separatedBy: .whitespacesAndNewlines).joined(separator: " "),
                              text: $0.text.components(separatedBy: .whitespacesAndNewlines).joined(separator: " "),
                              number: $0.verse,
                              chapter: newChapter)
                    }
                    
                    //attach verses to chapter
                    newChapter.verses = verses
                    
                    //add verses to verses list
                    newVerses.append(contentsOf: verses)
                    
                }
                
                newBook.chapters = newChapters
                
                books.append(newBook)
                allChapters.append(contentsOf: newChapters)
                allVerses.append(contentsOf: newVerses)
                
            }
            
            do {
                try await booksDataStore.insertBooks(books)
                try await chaptersDataStore.insertChapters(allChapters)
                try await versesDataStore.insertVerses(allVerses)
            } catch {
                print("unable to perform batch insertions \(error)")
            }
            
            dbInitializationInProgress = false
        }
    }
    
    private func getBibleData() async throws -> [TivBibleData]? {
        let task = Task {
            guard let jsonData = jsonData(from: "tivBibleData") else {
                throw TivBibleError.unableToLoadLocalJSON
            }
            
            do {
                return try jsonData.decode(into: [TivBibleData].self)
            } catch {
                throw TivBibleError.unableToDecodeData
            }
        }
        
        return try await task.value
    }
}
