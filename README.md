# swiftfmt
[![Build Status](https://travis-ci.org/kishikawakatsumi/swiftfmt.svg?branch=master)](https://travis-ci.org/kishikawakatsumi/swiftfmt)

A tool for formatting Swift code according to style guidelines.

### A Work In Progress
swiftfmt is still in active development.

Requirements
---------------------------------------
Swiftfmt requires [Swift trunk toolchains](https://swift.org/download/#snapshots).

Installation
---------------------------------------
Download and install [the latest trunk Swift development toolchain](https://swift.org/download/#snapshots).

```shell
git clone https://github.com/kishikawakatsumi/swiftfmt
```

```shell
cd swiftfmt
```

```shell
~/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swift package update
```

```shell
~/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swift build -c release
```

Copy the file (`.build/release/swiftfmt`) to your binary location.

Getting Started
---------------------------------------

```shell
swiftfmt [file or directory]
```

Usage
---------------------------------------


Configurations
---------------------------------------

### Tabs and Indents

**Use tab character**

```diff
git clone https://github.com/kishikawakatsumi/swiftfmt
 class Shape {
-    var numberOfSides = 0
-    func simpleDescription() -> String {
-        return "A shape with \(numberOfSides) sides."
-    }
+       var numberOfSides = 0
+
+       func simpleDescription() -> String {
+               return "A shape with \(numberOfSides) sides."
+       }
 }
```

**Indent**

`"indent" : 2`

```diff
 class Shape {
-    var numberOfSides = 0
-    func simpleDescription() -> String {
-        return "A shape with \(numberOfSides) sides."
-    }
+  var numberOfSides = 0
+
+  func simpleDescription() -> String {
+    return "A shape with \(numberOfSides) sides."
+  }
 }
```

**Keep indents on empty lines**

```diff
 class Shape {
     var numberOfSides = 0
+    
     func simpleDescription() -> String {
         return "A shape with \(numberOfSides) sides."
     }
```

**Indent 'case' branches**

```diff
 let someCharacter: Character = "z"
 switch someCharacter {
-case "a":
-    print("The first letter of the alphabet")
-case "z":
-    print("The last letter of the alphabet")
-default:
-    print("Some other character")
+    case "a":
+        print("The first letter of the alphabet")
+    case "z":
+        print("The last letter of the alphabet")
+    default:
+        print("Some other character")
 }
```

### Spaces

#### Before Parentheses

**Method/function declaration parentheses**

```diff
 class Counter {
     var count = 0
-    
-    func increment() {
+
+    func increment () {
         count += 1
     }
 
-    func increment(by amount: Int) {
+    func increment (by amount: Int) {
         count += amount
     }
 
-    func reset() {
+    func reset () {
         count = 0
     }
 }
```

**Method/function call parentheses**

```diff
 struct Point {
     var x = 0.0, y = 0.0
+
     mutating func moveBy(x deltaX: Double, y deltaY: Double) {
-        self = Point(x: x + deltaX, y: y + deltaY)
+        self = Point (x: x + deltaX, y: y + deltaY)
     }
 }
```

**'if' parentheses**

```diff
-if(temperatureInFahrenheit <= 32) {
+if (temperatureInFahrenheit <= 32) {
     print("It's very cold. Consider wearing a scarf.")
-} else if(temperatureInFahrenheit >= 86) {
+} else if (temperatureInFahrenheit >= 86) {
     print("It's really warm. Don't forget to wear sunscreen.")
 }
```

**'while' parentheses**

```diff
 var square = 0
 var diceRoll = 0
-while(square < finalSquare) {
+while (square < finalSquare) {
     // roll the dice
     diceRoll += 1
     if diceRoll == 7 { diceRoll = 1 }
```

**'switch' parentheses**

```diff
 let someCharacter: Character = "z"
-switch(someCharacter) {
+switch (someCharacter) {
 case "a":
     print("The first letter of the alphabet")
 case "z":
```

**'catch' parentheses**

```diff
 do {
     try throwable()
 } catch Error.unexpected(let cause) {
     print("unexpected error!")
-} catch(Error.unknown) {
+} catch (Error.unknown) {
     print("unknown error!")
 }
```

**Attribute parentheses**

```diff
-@available (swift 3.0.2)
-@available (macOS 10.12, *)
+@available(swift 3.0.2)
+@available(macOS 10.12, *)
 struct MyStruct {
     // struct definition
 }
```

#### Around Operators

**Assignment Operators (=, +=, ...)**

```diff
-let contentHeight=40
-let hasHeader=true
+let contentHeight = 40
+let hasHeader = true
 let rowHeight: Int
 if hasHeader {
-    rowHeight=contentHeight+50
+    rowHeight = contentHeight + 50
 } else {
-    rowHeight=contentHeight+20
+    rowHeight = contentHeight + 20
 }
```

**Logical Operators (&&, ||)**

```diff
-if enteredDoorCode&&passedRetinaScan||hasDoorKey||knowsOverridePassword {
+if enteredDoorCode && passedRetinaScan || hasDoorKey || knowsOverridePassword {
     print("Welcome!")
 } else {
     print("ACCESS DENIED")
```

**Equality Operator (==)**

```diff
 let name = "world"
-if name=="world" {
+if name == "world" {
     print("hello, world")
 } else {
     print("I'm sorry \(name), but I don't recognize you")
```

**Relational Operators (<, >, <=, >=)**

```diff
-2>1    // true because 2 is greater than 1
-1<2    // true because 1 is less than 2
-1>=1   // true because 1 is greater than or equal to 1
-2<=1   // false because 2 is not less than or equal to 1
+2 > 1 // true because 2 is greater than 1
+1 < 2 // true because 1 is less than 2
+1 >= 1 // true because 1 is greater than or equal to 1
+2 <= 1 // false because 2 is not less than or equal to 1
```

**Bitwise Operators (&, |, ^)**

```diff
 for i in 0..<x {
-    y += (y^0x123) << 2
+    y += (y ^ 0x123) << 2
 }
```

**Additive Operators (+, -)**

```diff
 while (x != y) {
-    x = f(x * 3+5)
+    x = f(x * 3 + 5)
 }
```

**Multiplicative Operators (*, /, %)**

```diff
 while (x != y) {
-    x = f(x*3 + 5)
+    x = f(x * 3 + 5)
 }
```

**Shift Operators (<<, >>)**

```diff
 for i in 0..<x {
-    y += (y ^ 0x123)<<2
+    y += (y ^ 0x123) << 2
 }
 if (0 < x && x <= 10) {
     while (x != y) {
```

**Range Operators (..., ..<)**

```diff
-for index in 1 ... 5 {
+for index in 1...5 {
     print("\(index) times 5 is \(index * 5)")
 }
```

**Closure Arrow (->)**

```diff
-func greet(person: String)->String {
+func greet(person: String) -> String {
     let greeting = "Hello, " + person + "!"
     return greeting
 }
```

#### Before Left Brace

**Type declaration left brace**

```diff
-struct Resolution{
+struct Resolution {
     var width = 0
     var height = 0
 }
-class VideoMode{
+
+class VideoMode {
     var resolution = Resolution()
     var interlaced = false
     var frameRate = 0.0
```

**Method/function left brace**

```diff
-func greet(person: String) -> String{
+func greet(person: String) -> String {
     let greeting = "Hello, " + person + "!"
     return greeting
 }
```

**'if' left brace**

```diff
 var temperatureInFahrenheit = 30
-if temperatureInFahrenheit <= 32{
+if temperatureInFahrenheit <= 32 {
     print("It's very cold. Consider wearing a scarf.")
 }
```

**'else' left brace**

```diff
 temperatureInFahrenheit = 40
 if temperatureInFahrenheit <= 32 {
     print("It's very cold. Consider wearing a scarf.")
-} else{
+} else {
     print("It's not that cold. Wear a t-shirt.")
 }
```

**'for' left brace**

```diff
 let names = ["Anna", "Alex", "Brian", "Jack"]
-for name in names{
+for name in names {
     print("Hello, \(name)!")
 }
```

**'while' left brace**

```diff
 var square = 0
 var diceRoll = 0
-while square < finalSquare{
+while square < finalSquare {
     // roll the dice
     diceRoll += 1
     if diceRoll == 7 { diceRoll = 1 }
```

**'do' left brace**

```diff
-do{
+do {
     try throwable()
 } catch Error.unexpected(let cause) {
     print("unexpected error!")
```

**'switch' left brace**

```diff
 let someCharacter: Character = "z"
-switch someCharacter{
+switch someCharacter {
 case "a":
     print("The first letter of the alphabet")
 case "z":
```

**'catch' left brace**

```diff
 do {
     try throwable()
-} catch Error.unexpected(let cause){
+} catch Error.unexpected(let cause) {
     print("unexpected error!")
-} catch (Error.unknown){
+} catch (Error.unknown) {
     print("unknown error!")
 }
```

#### Before Keywords

**'else' keyword**

```diff
 temperatureInFahrenheit = 40
 if temperatureInFahrenheit <= 32 {
     print("It's very cold. Consider wearing a scarf.")
-}else {
+} else {
     print("It's not that cold. Wear a t-shirt.")
 }
```

**'while' keyword**

```diff
     if diceRoll == 7 { diceRoll = 1 }
     // move by the rolled amount
     square += diceRoll
-}while square < finalSquare
+} while square < finalSquare
 print("Game over!")
```

**'catch' keyword**

```diff
 do {
     try throwable()
-}catch Error.unexpected(let cause) {
+} catch Error.unexpected(let cause) {
     print("unexpected error!")
-}catch (Error.unknown) {
+} catch (Error.unknown) {
     print("unknown error!")
 }
```

#### Within

**Code braces**

**Brackets**

`"brackets" : true`

```diff
     len = 10
 }
 repeat {
-    text[ext++] = "$"
+    text[ ext++ ] = "$"
 } while (ext < len)
 
 len = len > 10000 ? len : 0
```

**Array and dictionary literal brackets**

`"arrayAndDictionaryLiteralBrackets" : true`

```diff
-var shoppingList = ["Eggs", "Milk"]
-shoppingList += ["Baking Powder"]
-shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
+var shoppingList = [ "Eggs", "Milk" ]
+shoppingList += [ "Baking Powder" ]
+shoppingList += [ "Chocolate Spread", "Cheese", "Butter" ]
```

**Grouping parenthesese**

```diff
 var ext = x
 var len = y
 for i in 0..<x {
-    y += (y ^ 0x123) << 2
+    y += ( y ^ 0x123 ) << 2
 }
 repeat {
     text[ext++] = "$"
```

**Method/function declaration parenthesese**

`"functionDeclarationParentheses" : true`

```diff
-func greet(person: String) -> String {
+func greet( person: String ) -> String {
     let greeting = "Hello, " + person + "!"
     return greeting
 }
```

**Empty method/function declaration parenthesese**

```diff
-func sayHelloWorld() -> String {
+func sayHelloWorld( ) -> String {
     return "hello, world"
 }
 print(sayHelloWorld())
```

**Method/function call parenthesese**

```diff
 func greet(person: String, alreadyGreeted: Bool) -> String {
     if alreadyGreeted {
-        return greetAgain(person: person)
+        return greetAgain( person: person )
     } else {
-        return greet(person: person)
+        return greet( person: person )
     }
 }
```

**Empty method/function call parenthesese**

```diff
 func sayHelloWorld() -> String {
     return "hello, world"
 }
-print(sayHelloWorld())
+print(sayHelloWorld( ))
```

**'if' parenthesese**

```diff
 while square < finalSquare {
     // roll the dice
     diceRoll += 1
-    if (diceRoll == 7) { diceRoll = 1 }
+    if ( diceRoll == 7 ) { diceRoll = 1 }
     // move by the rolled amount
     square += diceRoll
-    if (square < board.count) {
+    if ( square < board.count ) {
         // if we're still on the board, move up or down for a snake or a ladder
         square += board[square]
     }
```

**'while' parenthesese**

```diff
 var square = 0
 var diceRoll = 0
-while (square < finalSquare) {
+while ( square < finalSquare ) {
     repeat {
         // move up or down for a snake or ladder
         square += board[square]
@@ -9,5 +9,5 @@ while (square < finalSquare) {
         if diceRoll == 7 { diceRoll = 1 }
         // move by the rolled amount
         square += diceRoll
-    } while (square < finalSquare)
+    } while ( square < finalSquare )
 }
```

**'switch' parenthesese**

```diff
 let someCharacter: Character = "z"
-switch (someCharacter) {
+switch ( someCharacter ) {
 case "a":
     print("The first letter of the alphabet")
 case "z":
```

**'catch' parenthesese**

```diff
     try throwable()
 } catch Error.unexpected(let cause) {
     print("unexpected error!")
-} catch (Error.unknown) {
+} catch ( Error.unknown ) {
     print("unknown error!")
 }
```

**Attribute parenthesese**

```diff
-@available(swift 3.0.2)
-@available(macOS 10.12, *)
+@available( swift 3.0.2 )
+@available( macOS 10.12, * )
 struct MyStruct {
     // struct definition
 }
```

#### In Ternary Operator (:?)

**After '?'**

**Before ':'**

**After ':'**

#### Around colons

**Before colon in type annotations**

**After colon in type annotations**

```diff
-func greet(person:String, alreadyGreeted:Bool) -> String {
+func greet(person: String, alreadyGreeted: Bool) -> String {
     if alreadyGreeted {
-        return greetAgain(person:person)
+        return greetAgain(person: person)
     } else {
-        return greet(person:person)
+        return greet(person: person)
     }
 }
```

**Before colon in type inheritance clauses**

```diff
-class Movie: MediaItem {
+class Movie : MediaItem {
     var director: String
     init(name: String, director: String) {
         self.director = director
```

**After colon in type inheritance clauses**

```
-class Movie :MediaItem {
+class Movie : MediaItem {
     var director: String
     init(name: String, director: String) {
         self.director = director
```

**Before colon in dictionary types**

**After colon in dictionary types**

**Before colon in dictionary literal 'key:value' pair**

**After colon in dictionary literal 'key:value' pair**

#### Within Type Arguments

**After comma**

#### Other

**Before comma**

**After comma**

**Before semicolon**

**After semicolon**

### Wrapping and Braces

### Blank Lines

#### Keep Maximum Blank Lines

**In declarations**

**In code**

**Before '}'**

#### Minimum Blank Lines

**Before imports**

`"beforeImports" : 1`

```diff
 //
 //  Created by Kishikawa Katsumi on 2018/02/14.
 //
+
 import Foundation
 import Basic
 import SwiftSyntax
```

**After imports**

`"afterImports" : 1`

```diff
 import Foundation
 import Basic
 import SwiftSyntax
+
 public struct Processor {
     private let options: [String]
```

**Around type declarations**

`"aroundTypeDeclarations" : 1`

```diff
@@ -9,6 +9,7 @@ fileprivate class Bracket : Indentation {
         self.lineNumber = lineNumber
     }
 }
+
 fileprivate class SwitchStatement {
     var lineNumber: Int
 
@@ -16,6 +17,7 @@ fileprivate class SwitchStatement {
         self.lineNumber = lineNumber
     }
 }
+
 fileprivate class CaseBranch {
     var lineNumber: Int
 
@@ -23,6 +25,7 @@ fileprivate class CaseBranch {
         self.lineNumber = lineNumber
     }
 }
+
 protocol Indentation {
     var indent: Bool { get set }
     var alignment: Int { get set }
```

**Around property in protocol**

`"aroundPropertyInProtocol" : 0`

**Around property**

`"aroundProperty" : 1`

**Around method/function in protocol**

`"aroundFunctionInProtocol" : 0`

**Around method/function**

`"aroundFunction" : 1`

**Before method/function body**

`"beforeFunctionBody" : 0`

Author
---------------------------------------
Kishikawa Katsumi, kishikawakatsumi@mac.com

License
---------------------------------------
Swiftfmt is available under the Apache 2.0 license. See the LICENSE file for more info.
