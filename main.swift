// VERSION 1.0
import Foundation

// * Create the `Todo` struct.
// * Ensure it has properties: id (UUID), title (String), and isCompleted (Bool).
struct Todo:CustomStringConvertible, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    
    // CustomStringConvertible Protocol 
    var description: String {
        return self.title + "; " + ((self.isCompleted) ? "completed: \u{2705}" : "completed: \u{274C}")
    } 

    // Decoable Protocol
    init(from decoder: Decoder) throws {
        let values: KeyedDecodingContainer<Todo.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(UUID.self, forKey: .id)!
        self.title = try values.decodeIfPresent(String.self, forKey: .title)!
        self.isCompleted = try values.decodeIfPresent(Bool.self, forKey: .isCompleted)!
    }

    init(withTitle title:String){
        self.id = UUID()
        self.title = title
        self.isCompleted = false
    }
}

// Create the `Cache` protocol that defines the following method signatures:
//  `func save(todos: [Todo])`: Persists the given todos.
//  `func load() -> [Todo]?`: Retrieves and returns the saved todos, or nil if none exist.
protocol Cache {
    func save(todos: [Todo])
    func load() -> [Todo]? 
}

// `FileSystemCache`: This implementation should utilize the file system 
// to persist and retrieve the list of todos. 
// Utilize Swift's `FileManager` to handle file operations.
final class JSONFileManagerCache: Cache {
    let fileName = "todo.json"
    var fileUrl:URL

    init() {
        do {
            try self.fileUrl = FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.fileUrl.append(component: fileName)
        } catch {
            print("Error- Generate URL failed: \(error)")
            self.fileUrl = URL(filePath: "")
        }
    }

    func save(todos: [Todo]) {
        do {
            let jsonData = try JSONEncoder().encode(todos)
            try jsonData.write(to: fileUrl)
            // DEBUG Encode or Write to disk failed
            //let jsonString = String (data: jsonData, encoding: .utf8)
            //print(jsonString)
        } catch {
            print("Error- Encoding failed: \(error)")
        }
    }

    func load() -> [Todo]? {
        do {
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            let jsonData: [Todo] = try decoder.decode([Todo].self, from:data)
            return jsonData
        } catch {
            // DEBUG: JSON loaderror
            //print("Error- Loading JSON failed \(error)")
        }
        // Return an empty array, if load fails
        return []
    }
}

// `InMemoryCache`: : Keeps todos in an array or similar structure during the session. 
// This won't retain todos across different app launches, 
// but serves as a quick in-session cache.
final class InMemoryCache: Cache {
    var todoList:[Todo]

    /*
     UPGRADE: Possible enhancements:
     -Clipboard to remember last deleted item, and ability to undo a command
     -State Memory, to keep track if the user needs to save before exiting.
     */

    init() {
        self.todoList = []
    }

    func save(todos: [Todo]) {
        self.todoList = todos
    }

    func load() -> [Todo]? {
        return self.todoList
    }
}

// The `TodosManager` class should have:
// * A function `func listTodos()` to display all todos.
// * A function named `func addTodo(with title: String)` to insert a new todo.
// * A function named `func toggleCompletion(forTodoAtIndex index: Int)` 
//   to alter the completion status of a specific todo using its index.
// * A function named `func deleteTodo(atIndex index: Int)` to remove a todo using its index.
final class TodoManager {

    var cache: InMemoryCache
    var lastDeletedItem: Todo?

    init() {
        self.cache = InMemoryCache()
    }
    
    func listTodos(){
        
        var displayCount = 1
        for todo: Todo in cache.todoList {
            print("\(displayCount). \(todo.description)")
            displayCount += 1
        }
    }
    
    func addTodo(with title: String) {
        cache.todoList.append(Todo.init(withTitle: title))
    }

    func toggleCompletion(forTodoAtIndex index: Int){
        if checkRange(index) {
            cache.todoList[index].isCompleted.toggle()
        }
        else { print("Message: index was out of range")}
    }

    func deleteTodo(atIndex index: Int){
        if checkRange(index) {
            lastDeletedItem = cache.todoList.remove(at: index)
        }
        else { print("Message: index was out of range")}
    }

    // TODO: Check if this is a build in function
    func checkRange(_ index: Int) -> Bool {
        return index < cache.todoList.count && index >= 0
    }
}


// * The `App` class should have a `func run()` method, this method should perpetually 
//   await user input and execute commands.
//  * Implement a `Command` enum to specify user commands. Include cases 
//    such as `add`, `list`, `toggle`, `delete`, and `exit`.
//  * The enum should be nested inside the definition of the `App` class
final class App {

    let todoManager: TodoManager = TodoManager()
    let fileManager: JSONFileManagerCache = JSONFileManagerCache()

    var input = ""
    var command:Command = .exit

    func run() {    
        print("Welcome to your To-do list CLI manager:")
        
        todoManager.cache.todoList = fileManager.load()!
        todoManager.listTodos()
        repeat {
            print("Command-list: add, list, toggle, delete, save, exit: ", terminator: "")
            if let current  = readLine(strippingNewline: true) {
                input = current
                validateCommand(&input)
                runCommand()
            }
        } while self.command != .exit

        print("Good-bye, thanks for using your To-do list CLI manager.")
    }

    func runCommand(){
        switch command {
            case .add:
                let input = gatherInputDetail(withPrompt: "Enter to-do item to add: ")
                todoManager.addTodo(with: input)
                print("\u{1F4CC} To-do added!")
            case .list:
                print("\u{1F4DD}")
                todoManager.listTodos()
            case .toggle:
                let input = gatherInputDetail(withPrompt: "Enter item number to toggle: ")
                // Try to convert input into an Integer, otherwise assign the value -1
                let inputIndex = Int(input) ?? -1
                if inputIndex >= 0 {
                    // User should not care about swift 0-based index; it is handled here, in the user-interface
                   todoManager.toggleCompletion(forTodoAtIndex: inputIndex - 1) 
                   todoManager.listTodos()
                }
            case .delete:
                todoManager.listTodos()
                let input = gatherInputDetail(withPrompt: "Enter item number to delete: ")
                // Try to convert input into an Integer, otherwise assign the value -1
                let inputIndex = Int(input) ?? -1
                if inputIndex >= 0 {
                    // User should not care about swift 0-based index; it is handled here, in the user-interface
                   todoManager.deleteTodo(atIndex: inputIndex - 1) 
                   if let lastDeletedItem = todoManager.lastDeletedItem {
                        print("\u{1F5D1}  Deleted to-do: \(lastDeletedItem.title).")
                   } else {print("\u{1F5D1}  Deleted to-do!")}
                }
            case .save:
                fileManager.save(todos: todoManager.cache.todoList)
                print("\u{1F4BE} List saved!")
            case .exit:
                // No action needed here, just break from the loop, from run()
                break
            case .invalid:
                print("Message: Command was not recognized, (Command-list: add, list, toggle, delete, save, exit)")
        }
    }

    func gatherInputDetail(withPrompt prompt: String) -> String {
        repeat {
            if !prompt.isEmpty { print(prompt, terminator: "") }
            if let current  = readLine(strippingNewline: true) {
                if !current.isEmpty { return current }
            }
        } while (input != "exit")
        return String()
    }

    func validateCommand(_ commandToValidate:inout String) {
        commandToValidate = commandToValidate.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch commandToValidate {
            case "add":
                self.command = .add
            case "list":
                self.command = .list
            case "toggle":
                self.command = .toggle
            case "delete":
                self.command = .delete
            case "exit":
                self.command = .exit
            case "save":
                self.command = .save
            default:
                self.command = .invalid
        }
    }

    enum Command {
        case add
        case list
        case toggle
        case delete
        case save
        case exit
        case invalid
    }  
}

// Run the App class.
let app = App()
app.run()