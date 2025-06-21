# Prueba Técnica iOS – SQLite + GPS

## 📲 Funcionalidad

- Al tocar el botón **"+"**, la app obtiene la ubicación actual del dispositivo y la guarda en una base de datos SQLite.
- Al tocar el botón **"Manual"**, el usuario puede ingresar latitud y longitud manualmente para almacenarlas.
- Los datos se muestran en una lista, ordenada por la fecha de modificación (más reciente primero).
- Cada celda muestra:
  - Contador
  - Fecha de última modificación en formato `dd/MM/yyyy HH:ss`
  - Latitud y longitud
  - Botón para eliminar la entrada
- Al tocar una celda (no el botón), el contador se incrementa y se actualiza la fecha.

---

## 🧩 Tecnologías Utilizadas

- UIKit (`UITableViewController`)
- SQLite (directo con `sqlite3`)
- CoreLocation (`CLLocationManager`)
- Arquitectura: Modular tipo VIPER simplificado
- Carga asíncrona con `DispatchQueue`
- Indicador de carga (`UIActivityIndicatorView`)
- Logs visibles en consola para seguimiento de operaciones

---

## 🛠️ Estructura Principal

```
LocationListModule/
├── ViewController
├── Presenter
├── Interactor
├── Data/
│   ├── SQLiteManager.swift
│   └── LocationService.swift
├── Entity/
│   └── LocationEntity.swift
```

---

## 🚀 Cómo ejecutar

1. Clona o abre el proyecto en Xcode.
2. Corre en un simulador o dispositivo físico con permisos de ubicación activados.
3. Usa los botones "+" o "Manual" para insertar datos.

**Nota: la versión del xcode es 16.4 **
---

## ✅ Requisitos Cubiertos

✔️ Base de datos local en SQLite  
✔️ Operaciones asíncronas  
✔️ GPS en tiempo real y entrada manual  
✔️ Interfaz nativa  
✔️ Orden descendente por fecha  
✔️ Loader visual y logs de consola  

---

Desarrollado por: **Adrián Pascual Domínguez Gómez**  
Fecha: **Junio 2025**
