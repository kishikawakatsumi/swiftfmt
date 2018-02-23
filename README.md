# swiftfmt

A tool for formatting Swift code according to style guidelines.

### A Work In Progress
swiftfmt is still in active development.




Configurations
---------------------------------------

### Tabs and Indents

**Use tab character**

```diff
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

**Indent = 2**

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

**Attribute parentheses**

#### Around Operators

#### Before Left Brace

#### Before Keywords

#### Within

#### In Ternary Operator (:?)

#### Around colons

#### Within Type Arguments

#### Other

### Wrapping and Braces

### Blank Lines

Author
---------------------------------------
Kishikawa Katsumi, kishikawakatsumi@mac.com

License
---------------------------------------
Swiftfmt is available under the Apache 2.0 license. See the LICENSE file for more info.
