//
//  SQLiteManager.swift
//  PruebaTécnicaQSFT
//
//  Created by Adrian Pascual Dominguez Gomez on 21/06/25.
//

import Foundation
import SQLite3

final class SQLiteManager {
    static let shared = SQLiteManager()
    private let dbName = "locations.sqlite"
    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTableIfNeeded()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(dbName)

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error al abrirBD")
        } else {
            print("BD abierta en: \(fileURL.path)")
        }
    }

    
    //creamos la tabla si es que no existe, directamente desde código
    private func createTableIfNeeded() {
        print("🛠️ Creando tabla si no existe...")
        let query = """
        CREATE TABLE IF NOT EXISTS locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL,
            longitude REAL,
            counter INTEGER,
            modifiedAt TEXT
        );
        """
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Tablacreada o ya existe.")
            }
        } else {
            print("Error al crear tabla.")
        }
        sqlite3_finalize(stmt)
    }
    
    
    //insertamos ubicacion
    func insertLocation(latitude: Double, longitude: Double, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            print("insertLocation llamado con lat: \(latitude), lon: \(longitude)")
            let query = "INSERT INTO locations (latitude, longitude, counter, modifiedAt) VALUES (?, ?, ?, ?);"
            var stmt: OpaquePointer?

            if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK {
                let dateString = self.getCurrentDateString()
                sqlite3_bind_double(stmt, 1, latitude)
                sqlite3_bind_double(stmt, 2, longitude)
                sqlite3_bind_int(stmt, 3, 1)
                sqlite3_bind_text(stmt, 4, (dateString as NSString).utf8String, -1, nil)

                if sqlite3_step(stmt) == SQLITE_DONE {
                    print("✅ Insert completado")
                } else {
                    print("❌ Error al insertar")
                }
            }
            sqlite3_finalize(stmt)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    //leemos los registros y ordenamos para quitarle carga al presenter

    func fetchLocations(completion: @escaping ([LocationEntity]) -> Void) {
        DispatchQueue.global().async {
            print("fetchLocations llamado")
            var locations: [LocationEntity] = []
            let query = "SELECT id, latitude, longitude, counter, modifiedAt FROM locations ORDER BY datetime(modifiedAt) DESC;"
            var stmt: OpaquePointer?

            if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK {
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(stmt, 0))
                    let lat = sqlite3_column_double(stmt, 1)
                    let lon = sqlite3_column_double(stmt, 2)
                    let counter = Int(sqlite3_column_int(stmt, 3))
                    let modifiedAtStr = String(cString: sqlite3_column_text(stmt, 4))

                    if let date = self.dateFromString(modifiedAtStr) {
                        let location = LocationEntity(id: id, latitude: lat, longitude: lon, counter: counter, modifiedAt: date)
                        locations.append(location)
                    }
                }
            }
            sqlite3_finalize(stmt)
            DispatchQueue.main.async {
                completion(locations)
            }
        }
    }
    
    
//actualiza contador y a su vez la fecha en que se actualizo
    func updateCounter(forID id: Int, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            print("updateCounter llamado para ID: \(id)")
            let query = "UPDATE locations SET counter = counter + 1, modifiedAt = ? WHERE id = ?;"
            var stmt: OpaquePointer?

            if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK {
                let dateString = self.getCurrentDateString()
                sqlite3_bind_text(stmt, 1, (dateString as NSString).utf8String, -1, nil)
                sqlite3_bind_int(stmt, 2, Int32(id))

                if sqlite3_step(stmt) == SQLITE_DONE {
                    print("✅ Actualización completada")
                } else {
                    print("❌ Error al actualizar")
                }
            }
            sqlite3_finalize(stmt)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    //Eliminar ubicacion de acuerdo a un id
    func deleteLocation(id: Int, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            print("deleteLocation llamado para ID: \(id)")
            let query = "DELETE FROM locations WHERE id = ?;"
            var stmt: OpaquePointer?

            if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK {
                sqlite3_bind_int(stmt, 1, Int32(id))

                if sqlite3_step(stmt) == SQLITE_DONE {
                    print("Eliminación completada")
                } else {
                    print("Error al eliminar")
                }
            }
            sqlite3_finalize(stmt)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    //metodos auxiliares
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }

    private func dateFromString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string)
    }
}
