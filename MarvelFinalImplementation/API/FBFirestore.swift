//
//  FBFirestore.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 22.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import FirebaseFirestore

//Example how the a class that implements the database should look like
//class FirebaseFirestore<F: FBFirestore> {
//    let database: F
//
//    init(database: F) {
//        self.database = database
//    }
//}

protocol FBFirestore {
    // The CollectionReference is a subclass of Query. For that reason, in order to abstract it as "CollectionRef", then "CollectionRef" conforms to two protrocols.
    associatedtype CollectionRef: FBCollectionReference & FBQuery
    func collection(_ collectionPath: String) -> CollectionRef
}

extension Firestore: FBFirestore {}

protocol FBCollectionReference {
    associatedtype DocumentRef: FBDocumentReference

    var collectionID: String { get }

    func document() -> DocumentRef

    func addDocument(data: [String: Any]) -> DocumentRef

    func addDocument(data: [String: Any], completion: ((Error?) -> Void)?) -> DocumentRef
}

extension CollectionReference: FBCollectionReference {}

protocol FBDocumentReference {
    var documentID: String { get }
}

extension DocumentReference: FBDocumentReference {}

protocol FBQuery {
    associatedtype Database: FBFirestore
    // Query Snapshot
    associatedtype Snapshot: FBQuerySnapshot

    var firestore: Database { get }

    func getDocuments(completion: @escaping (Snapshot?, Error?) -> Void)

    // ListenerRegistration is already a protocol. For that reason, nonextra associatedType is needed.
    func addSnapshotListener(_ listener: @escaping (Snapshot?, Error?) -> Void) -> ListenerRegistration
}

extension Query: FBQuery { }

protocol FBQuerySnapshot {
    associatedtype QueryDocSnapshot: FBQueryDocumentSnapshot
    associatedtype DocChange: FBDocumentChange

    var documents: [QueryDocSnapshot] { get }

    var documentChanges: [DocChange] { get }

    var isEmpty: Bool { get }

    var count: Int { get }
}

extension QuerySnapshot: FBQuerySnapshot {}

protocol FBQueryDocumentSnapshot {
    var documentID: String { get }

    func data() -> [String: Any]
}

extension QueryDocumentSnapshot: FBQueryDocumentSnapshot {}

protocol FBDocumentChange {
    associatedtype QueryDocSnapshot: FBQueryDocumentSnapshot

    var document: QueryDocSnapshot { get }
}

extension DocumentChange: FBDocumentChange {}

