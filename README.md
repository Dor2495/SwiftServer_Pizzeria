# Pizzeria Server

A lightweight HTTP server that provides backend services for the Pizzeria iOS app.

## Overview

This server implements a simple REST API to support a pizza ordering mobile application. It provides endpoints for retrieving restaurant information, menu items, and processing orders.

## Features

- **Restaurant Information API**: Provides basic details about the pizzeria
- **Menu API**: Serves the complete menu with categories and items
- **Order Processing**: Accepts and processes customer orders
- **Order Viewing**: Simple web interface to view the last submitted order

## Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/pizza` | GET    | Returns pizzeria information (name, address, contact details, hours) |
| `/menu`  | GET    | Returns the complete menu with categories and items |
| `/order` | POST   | Accepts order submissions (as JSON array of menu items) |
| `/orders`| GET    | Displays the most recent order in HTML format |

## Technical Details

- Built with the Swifter HTTP server framework
- Runs on port 8080
- Stores the most recent order in memory (not persistent)
- Returns JSON data compatible with the iOS client app's data models

## Getting Started

### Prerequisites

- Swift 5.0 or later
- Swifter library

### Installation

1. Clone the repository
2. Install dependencies:
   ```
   swift package resolve
   ```
3. Build the project:
   ```
   swift build
   ```
4. Run the server:
   ```
   swift run
   ```

## Integration with iOS App

This server is designed to work with the Pizzeria iOS app. The app connects to this server to:

1. Fetch restaurant information
2. Load the menu
3. Submit customer orders

The server expects and returns JSON that matches the data models in the iOS app.

## Limitations

- Data is not persisted between server restarts
- Only stores the most recent order
- No authentication or security features
- Designed for local development and testing
