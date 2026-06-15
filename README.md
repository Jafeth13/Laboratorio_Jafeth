## 🧩 Arquitectura del sistema

Aplicación full‑stack basada en una arquitectura distribuida, donde cada servicio cumple una función específica:

- **Node.js** → Maneja operaciones de consulta y creación (`GET`, `POST`)
- **.NET** → Maneja actualización y eliminación (`PUT`, `DELETE`)
- **SQL Server** → Persistencia mediante Stored Procedures y soft delete
- **Flutter** → Interfaz de usuario con animaciones y validaciones
- **Docker** → Orquestación de servicios y despliegue en backend

---

## 🔄 Flujo de funcionamiento

1. El usuario interactúa con la aplicación Flutter  
2. Flutter consume:
   - Node.js → Consultar y crear datos  
   - .NET → Actualizar y eliminar datos  
3. Los servicios ejecutan la lógica de negocio  
4. SQL Server procesa la información y registra cambios  
5. La respuesta actualiza la interfaz en tiempo real  

---

##  Funcionalidades

- CRUD completo de personas  
- Eliminación lógica (soft delete)  
- Validación de formularios  
- Animaciones y UI moderna  
- Uso de DatePicker  
