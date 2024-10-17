import Foundation  // Import Foundation framework for using NSRegularExpression

// Extend the String type to add a custom function for email validation
extension String {
    // Function to check if the string is a valid email address
    func isValidEmail() -> Bool {
        // Define a regular expression pattern for a valid email format
        let regex = try! NSRegularExpression(
            pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",  // Pattern for a valid email address
            options: .caseInsensitive  // Make the pattern case-insensitive (e.g., 'A' is treated the same as 'a')
        )
        
        // Check if the regex finds a match within the entire string (self)
        return regex.firstMatch(
            in: self,  // The string to search within (the current instance of String)
            range: NSRange(location: 0, length: count)  // Search the entire string length
        ) != nil  // Return true if a match is found, otherwise false
    }

    
    
    //Valid usernames should:
    //1. Be between 6-10 characters
    //2. Only conatain letters, numbers, _
    //3. Unique
    func isValidUserName () -> Bool{
        
        return true
    }
    
    //Valid Passwords should:
    //1. Be minimum 8 characters
    //2. Have at least one number
    //3. Have at least one symbol
    func isValidPassword () -> Bool{
        
        return true
    }
}

