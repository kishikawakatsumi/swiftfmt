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


Author
---------------------------------------
Kishikawa Katsumi, kishikawakatsumi@mac.com

License
---------------------------------------
Swiftfmt is available under the Apache 2.0 license. See the LICENSE file for more info.
