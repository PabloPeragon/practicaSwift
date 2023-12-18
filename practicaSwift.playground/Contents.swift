import Cocoa

struct Client{
    let nombre: String
    let edad: Int
    let altura: Double
}

struct Reservation{
    let id: Int
    let nombreHotel: String
    let listaClientes: [Client]
    let duracion: Int
    let precio: Double
    let opcionDesayuno: Bool
}

enum ReservationError: Error{
    case mismoId
    case mismoCliente
    case noReserva
}

class HotelReservationManager{
    private var listaReservas = [Reservation]()
    private var contadorId = 0
    
    
    
    func anadirReserva(clientes:[Client], duracion: Int, opcionDesayuno: Bool, nombreHotel: String) throws ->Reservation{
        let precioTotal = Double(clientes.count * 20 * duracion) * (opcionDesayuno ? 1.25:1)
        let nuevaReserva = Reservation(id: contadorId, nombreHotel: nombreHotel, listaClientes: clientes, duracion: duracion, precio: precioTotal, opcionDesayuno: opcionDesayuno)
        
        for reserva in totalReservas {
            if reserva.listaClientes.contains(where: {$0.nombre == clientes.first?.nombre}){
                throw ReservationError.mismoCliente
            }
        }
        
        listaReservas.append(nuevaReserva)
        contadorId += 1
        return nuevaReserva
    }
    
    func cancelarReserva(id: Int) throws {
        if let borrarId = listaReservas.firstIndex(where: {$0.id == id}){
            listaReservas.remove(at: borrarId)
        }else{
            throw ReservationError.noReserva
        }
    }
    
    var totalReservas:[Reservation]{
        return listaReservas
    }
}


func testAddReservation(){
    let hotelReservationManager = HotelReservationManager()
    let goku = Client(nombre: "Goku", edad: 32, altura: 180)
    let vegeta = Client(nombre: "Vegeta", edad: 38, altura: 190)
    let bulma = Client(nombre: "Bulma", edad: 30, altura: 165)
    let krilin = Client(nombre: "Krilin", edad: 32, altura: 160)
    
    do {
        let reserva = try hotelReservationManager.anadirReserva(clientes: [goku, bulma], duracion: 5, opcionDesayuno: true, nombreHotel: "Kame House")
        assert(hotelReservationManager.totalReservas.count == 1)
    } catch {
        assertionFailure("Error no se añaden reservas")
    }
    do{
        let reserva2 = try hotelReservationManager.anadirReserva(clientes: [krilin], duracion: 5, opcionDesayuno: true, nombreHotel: "Kame House")
    } catch ReservationError.mismoCliente {
        print("Error: Cliente duplicado")
    } catch {
        assertionFailure("Error no encuentra clientes duplicados")
        
    }
}


func testCancelReservation(){
    let hotelReservationManager = HotelReservationManager()
    let goku = Client(nombre: "Goku", edad: 32, altura: 180)
    let vegeta = Client(nombre: "Vegeta", edad: 38, altura: 190)
    let bulma = Client(nombre: "Bulma", edad: 30, altura: 165)
    let krilin = Client(nombre: "Krilin", edad: 32, altura: 160)

    
    do{
        let reserva = try hotelReservationManager.anadirReserva(clientes: [vegeta], duracion: 5, opcionDesayuno: true, nombreHotel: "Kame House")
        try hotelReservationManager.cancelarReserva(id: reserva.id)
        assert(hotelReservationManager.totalReservas.isEmpty)
    } catch {
        assertionFailure("Error no se añaden reservas")
    }
    
    do{
        try hotelReservationManager.cancelarReserva(id: 10)
                
    } catch ReservationError.noReserva{
        print("Error: Reserva no encontrada")
    } catch {
        assertionFailure("Fallo al cancelar las reservas")
    }
        
}

func testReservationPrice(){
    let hotelReservationManager = HotelReservationManager()
    let goku = Client(nombre: "Goku", edad: 32, altura: 180)
    let vegeta = Client(nombre: "Vegeta", edad: 38, altura: 190)
    let bulma = Client(nombre: "Bulma", edad: 30, altura: 165)
    let krilin = Client(nombre: "Krilin", edad: 32, altura: 160)
    
    do{
        let reserva1 = try hotelReservationManager.anadirReserva(clientes: [krilin], duracion: 5, opcionDesayuno: true, nombreHotel: "Kame House")
        let reserva2 = try hotelReservationManager.anadirReserva(clientes: [goku], duracion: 5, opcionDesayuno: true, nombreHotel: "Kame House")
        assert(reserva1.precio == reserva2.precio)
    } catch{
        assertionFailure("Fallo al comparar precios")
    }

    
}


testAddReservation()
testCancelReservation()
testReservationPrice()
