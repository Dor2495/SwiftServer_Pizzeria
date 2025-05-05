// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Swifter

let server = HttpServer()

server.GET["/pizza"] = { request in
    let jsonData = """
    
    {
      "name": "Bella Napoli",
      "address": "123 Main Street, Springfield",
      "phone": "+1-555-123-4567",
      "email": "contact@bellanapoli.com",
      "website": "https://www.bellanapoli.com",
      "opening_hours": {
        "monday": "11:00 - 22:00",
        "tuesday": "11:00 - 22:00",
        "wednesday": "11:00 - 22:00",
        "thursday": "11:00 - 22:00",
        "friday": "11:00 - 23:00",
        "saturday": "12:00 - 23:00",
        "sunday": "12:00 - 21:00"
      }
    }
    
    
    """
    
    printRequest(request)
    
    return HttpResponse.ok(.text(jsonData))
}

server.GET["/menu"] = { request in
    let jsonData = """
        {
              "categories": [
                {
                  "name": "Pizzas",
                  "items": [
                    {
                      "id": 1,
                      "name": "Margherita",
                      "description": "Classic pizza with tomato sauce, mozzarella, and basil",
                      "price": 9.99,
                      "vegetarian": true
                    },
                    {
                      "id": 2,
                      "name": "Pepperoni",
                      "description": "Tomato sauce, mozzarella, and pepperoni",
                      "price": 11.99,
                      "vegetarian": false
                    },
                    {
                      "id": 3,
                      "name": "Quattro Formaggi",
                      "description": "Mozzarella, gorgonzola, parmesan, and provolone",
                      "price": 12.49,
                      "vegetarian": true
                    }
                  ]
                },
                {
                  "name": "Salads",
                  "items": [
                    {
                      "id": 4,
                      "name": "Caesar Salad",
                      "description": "Romaine lettuce, parmesan, croutons, and Caesar dressing",
                      "price": 7.99,
                      "vegetarian": true
                    },
                    {
                      "id": 5,
                      "name": "Greek Salad",
                      "description": "Cucumber, tomato, olives, feta, and red onion",
                      "price": 8.49,
                      "vegetarian": true
                    }
                  ]
                },
                {
                  "name": "Drinks",
                  "items": [
                    {
                      "id": 6,
                      "name": "Coca-Cola",
                      "description": "12oz can",
                      "price": 1.99,
                      "vegetarian": true
                    },
                    {
                      "id": 7,
                      "name": "Sparkling Water",
                      "description": "500ml bottle",
                      "price": 2.49,
                      "vegetarian": true
                    }
                  ]
                }
              ]
        }
        """
    
//    printRequest(request)
    
    return HttpResponse.ok(.text(jsonData))
}

server["/order"] = { request in
    // Convert [UInt8] to Data
    let data = Data(request.body)
    
    // Convert Data to JSON string (for logging or confirmation)
    if let jsonString = String(data: data, encoding: .utf8) {
        lastOrderJSON = jsonString
        print("Received JSON:\n\(jsonString)")
        return .ok(.text("Received JSON:\n\(jsonString)"))
    } else {
        return .internalServerError
    }
}


var lastOrderJSON: String? = nil


server.GET["/orders"] = { request in
    guard let json = lastOrderJSON,
          let data = json.data(using: .utf8),
          let items = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
        return .ok(.html("<html><body><p>No valid orders found.</p></body></html>"))
    }
    print("Last Order: \(lastOrderJSON ?? "No JSON received yet")")
    var tableHTML = """
    <html>
    <head>
      <title>Last Order</title>
      <style>
        table { border-collapse: collapse; width: 80%; margin: 20px auto; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f5f5f5; }
        td.total-label { text-align: right; font-weight: bold; }
        td.total-value { text-align: right; font-weight: bold; }
      </style>
    </head>
    <body>
      <h1 style="text-align:center;">Last Order</h1>
      <table>
        <tr>
    """

    // Extract column keys from first item
    guard let firstItem = items.first else {
        return .ok(.html("<html><body><p>No items in the order.</p></body></html>"))
    }

    let keys = Array(firstItem.keys)

    // Headers
    for key in keys {
        tableHTML += "<th>\(key.capitalized)</th>"
    }
    tableHTML += "</tr>"

    // Rows
    var totalPrice: Double = 0.0
    for item in items {
        tableHTML += "<tr>"
        for key in keys {
            let value = item[key] ?? ""
            if key == "price", let price = value as? Double {
                totalPrice += price
                tableHTML += "<td>\(String(format: "%.2f", price))</td>"
            } else {
                tableHTML += "<td>\(value)</td>"
            }
        }
        tableHTML += "</tr>"
    }

    // Total row (bottom right)
    tableHTML += "<tr>"
    for i in 0..<(keys.count - 2) {
        tableHTML += "<td></td>"
    }
    tableHTML += "<td class='total-label'>Total</td>"
    tableHTML += "<td class='total-value'>\(String(format: "%.2f", totalPrice))</td>"
    tableHTML += "</tr>"

    tableHTML += "</table></body></html>"
    
//    printRequest(request)

    return .ok(.html(tableHTML))
}


do {
    try server.start(8080)
    print("Server is running on port 8080")
    RunLoop.main.run()
} catch {
    print("Cannot run server")
}

func printRequest(_ request: HttpRequest) {
    print("Headers: \(request.headers) received")
    print("Body: \(request.body) received")
    print("Params: \(request.params) received")
}
