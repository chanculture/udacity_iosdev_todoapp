import Foundation

// * Create the `Todo` struct.
// * Ensure it has properties: id (UUID), title (String), and isCompleted (Bool).
struct Todo:CustomStringConvertible, Codable {
    // CustomStringConvertible Protocol 
    var description: String {
        return nil // Return how the todo is displayed
    }

    // Codable Protocol is a TypeAlias for Encodable and Decodable
    func encode(to: any Encoder) throws {

    }

    // Decoable Protocol
    init(from: any Decoder) throws {

    }


    var id: UUID   // To be auto generated
    var title: String
    var isCompleted: Bool

}

// Create the `Cache` protocol that defines the following method signatures:
//  `func save(todos: [Todo])`: Persists the given todos.
//  `func load() -> [Todo]?`: Retrieves and returns the saved todos, or nil if none exist.
protocol Cache {
    func save(todos: [Todos])
    func load() -> [Todo]? 
}

// `FileSystemCache`: This implementation should utilize the file system 
// to persist and retrieve the list of todos. 
// Utilize Swift's `FileManager` to handle file operations.
final class JSONFileManagerCache: Cache {


    func save(todos: [Todos]) {

    }

    func load() -> [Todo]? {

    }
}

// `InMemoryCache`: : Keeps todos in an array or similar structure during the session. 
// This won't retain todos across different app launches, 
// but serves as a quick in-session cache.
final class InMemoryCache: Cache {

}

// The `TodosManager` class should have:
// * A function `func listTodos()` to display all todos.
// * A function named `func addTodo(with title: String)` to insert a new todo.
// * A function named `func toggleCompletion(forTodoAtIndex index: Int)` 
//   to alter the completion status of a specific todo using its index.
// * A function named `func deleteTodo(atIndex index: Int)` to remove a todo using its index.
final class TodoManager {

    var masterList:[Todo] = []
    
    func listTodos(){

    }
    
    func addTodo(with title: String) {

    }

    func toggleCompletion(forTodoAtIndex index: Int){

    }

    func deleteTodo(atIndex index: Int){

    }
}


// * The `App` class should have a `func run()` method, this method should perpetually 
//   await user input and execute commands.
//  * Implement a `Command` enum to specify user commands. Include cases 
//    such as `add`, `list`, `toggle`, `delete`, and `exit`.
//  * The enum should be nested inside the definition of the `App` class
final class App {

    func run() {
        var input = "exit"
        input = readLine(strippingNewline: True)

    }

    enum Command {
        case add
        case list
        case toggle
        case delete
        case exit
}   
}


// TODO: Write code to set up and run the app.


