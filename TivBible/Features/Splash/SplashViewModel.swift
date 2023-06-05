//
//  SplashViewModel.swift
//  TivBible
//
//  Created by Isaac Iniongun on 01/06/2023.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class SplashViewModel: ObservableObject {
    
    @Published private var booksDataStore: BooksDataStore
    @Published private var chaptersDataStore: ChaptersDataStore
    @Published private var versesDataStore: VersesDataStore
    
    @Published var dbInitializationInProgress: Bool = false
    @Published private var preferenceStore = PreferenceStore()
    
    var booksDataStoreCancellable: AnyCancellable? = nil
    var chaptersDataStoreCancellable: AnyCancellable? = nil
    var versesDataStoreCancellable: AnyCancellable? = nil
    
    init(booksDataStore: BooksDataStore = .shared,
         chaptersDataStore: ChaptersDataStore = .shared,
         versesDataStore: VersesDataStore = .shared
    ) {
        self.booksDataStore = booksDataStore
        self.chaptersDataStore = chaptersDataStore
        self.versesDataStore = versesDataStore
        
        booksDataStoreCancellable = booksDataStore.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        
        chaptersDataStoreCancellable = chaptersDataStore.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        
        versesDataStoreCancellable = versesDataStore.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func printBooks() {
        print(booksDataStore.books.first?.chapterIDs)
        print("chaptersDataStore.chapters: \(chaptersDataStore.chapters.count)")
        print(chaptersDataStore.chapters.first?.verseIDs)
        print("versesDataStore.verses.count: \(versesDataStore.verses.count)")
        print(versesDataStore.verses.prefix(50))
    }
    
    func initializeDB() async {
        guard !preferenceStore.hasSetupDB else {
            print("we have setup DB")
            return }
        
        dbInitializationInProgress = true
        
        print("setting up this DB")
        
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
                    
                    var newChapter = Chapter(number: chapter.chapter, bookID: newBook.id)
                    newChapters.append(newChapter)
                    
                    let verses = bookChapterVerses.map {
                        Verse(title: $0.title.components(separatedBy: .whitespacesAndNewlines).joined(separator: " "),
                              text: $0.text.components(separatedBy: .whitespacesAndNewlines).joined(separator: " "),
                              number: $0.verse,
                              chapterID: newChapter.id)
                    }
                    
                    newChapter.verseIDs = verses.map { $0.id }
                    
                    newVerses.append(contentsOf: verses)
                    
                }
                
                newBook.chapterIDs = newChapters.map { $0.id }
                
                books.append(newBook)
                allChapters.append(contentsOf: newChapters)
                allVerses.append(contentsOf: newVerses)
                
            }
            
            do {
                try await booksDataStore.insertBooks(books)
                try await chaptersDataStore.insertChapters(allChapters)
                try await versesDataStore.insertVerses(allVerses)
                try await booksDataStore.createRelationships(chapters: allChapters, verses: allVerses)
                preferenceStore.hasSetupDB = true
                dbInitializationInProgress = false
                print("we have setup our DB now")
            } catch {
                dbInitializationInProgress = false
                print("unable to perform batch insertions and/or create entity relationships \(error)")
            }
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
