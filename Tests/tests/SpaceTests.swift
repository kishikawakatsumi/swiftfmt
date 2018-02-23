//
//  SpacesTests.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import XCTest
@testable import swiftfmt_core

class SpaceTests : XCTestCase {
    func testFormatSpaces() {
        let source = """
            public class Foo:NSObject{
                func foo()->String{
                    let array=["One","Two","Three","Four","Five"]
                    let dic=["One":1,"Two":2,"Three":3,"Four":4,"Five":5]

                    var x=1
                    var y:Int=1
                    x+=(x^0x123)<<2

                    if x>0{
                        while x!=0{

                        }
                        repeat{

                        }while x>0
                    }else{

                    }
                    print(x);print(y);
                }

                func bar<T,E:NSObject>(name:T,o:E){

                }
            }
            """

        let expected = """
            public class Foo : NSObject {
                func foo() -> String {
                    let array = ["One", "Two", "Three", "Four", "Five"]
                    let dic = ["One": 1, "Two": 2, "Three": 3, "Four": 4, "Five": 5]

                    var x = 1
                    var y: Int = 1
                    x += (x ^ 0x123) << 2

                    if x > 0 {
                        while x! = 0 {

                        }
                        repeat {

                        } while x > 0
                    } else {

                    }
                    print(x)
                    print(y)
                }

                func bar<T, E: NSObject>(name: T, o: E) {

                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testParentheses() {
        let source = """
            public class Foo{
                func foo(_ num: Int)->Int{
                    var x = 0
                    let y = 1
                    if(0 < x && x <= 10){
                        while(x != y){
                            x = foo(x*3+5)
                        }
                    } else {
                        return 0
                    }
                    return 0
                }
            }
            """

        let expected = """
            public class Foo {
                func foo(_ num: Int) -> Int {
                    var x = 0
                    let y = 1
                    if (0 < x && x <= 10) {
                        while (x != y) {
                            x = foo(x * 3 + 5)
                        }
                    } else {
                        return 0
                    }
                    return 0
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testParenthesesBeforeFunctionDeclaration() {
        let source = """
            class Shape {
                var numberOfSides = 0

                func simpleDescription() -> String {
                    return "A shape with \\(numberOfSides) sides."
                }
            }
            """

        let expected = """
            class Shape {
                var numberOfSides = 0

                func simpleDescription () -> String {
                    return "A shape with \\(numberOfSides) sides."
                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.spaces.before.parentheses.functionDeclaration = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testParenthesesAfterFunctionCall1() {
        let source = """
            public class Foo{
                func foo(){
                    foo()
                    foo  ()
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    foo()
                    foo()
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
    

    func testParenthesesAfterFunctionCall2() {
        let source = """
            public class Foo{
                func foo(){
                    var x = 0
                    if 0 < x {
                        foo()
                        foo  ()
                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    var x = 0
                    if 0 < x {
                        foo()
                        foo()
                    }
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testParenthesesAttribute() {
        let source = """
            public class Foo{
                @available (*,unavailable,renamed:"bar()")
                func foo(){

                }

                @available(*, unavailable, renamed: "bar()")
                func bar(){

                }
            }
            """

        let expected = """
            public class Foo {
                @available(*, unavailable, renamed: "bar()")
                func foo() {

                }

                @available(*, unavailable, renamed: "bar()")
                func bar() {

                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testLeftBraces() {
        let source = """
            public class Foo{
                func foo(){

                }
            }

            extension Foo{

            }

            enum Fruit{
                case banana
            }
            """

        let expected = """
            public class Foo {
                func foo() {

                }
            }

            extension Foo {

            }

            enum Fruit {
                case banana
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testRightBraces() {
        let source = """
            public class Foo{
                func foo(){
                    if true{

                    }else{

                    }

                    let x = 1
                    while x != 0{

                    }

                    repeat{

                    }while x>0
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    if true {

                    } else {

                    }

                    let x = 1
                    while x != 0 {

                    }

                    repeat {

                    } while x > 0
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testFormatTernaryOperators() {
        let source = """
            public class Foo{
                func foo(){
                    let x=1
                    let y=x>0 ?2:3
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    let x = 1
                    let y = x > 0 ? 2 : 3
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testFormatColons() {
        let source = """
            public class Foo:NSObject{
                func foo(name:String,age:Int){
                    let x:Int=1
                    print(x)
                    let dic:[String:Int]=["one":1,"two":2,"three":3]
                    var emptyDictionary:[String:Int]=[:]
                }

                func bar<T,E:NSObject>(name:T,o:E){

                }
            }
            """

        let expected = """
            public class Foo : NSObject {
                func foo(name: String, age: Int) {
                    let x: Int = 1
                    print(x)
                    let dic: [String: Int] = ["one": 1, "two": 2, "three": 3]
                    var emptyDictionary: [String: Int] = [:]
                }

                func bar<T, E: NSObject>(name: T, o: E) {

                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testFormatSemicolons() {
        let source = """
            public class Foo{
                func foo(){
                    print(x);print(y);
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    print(x);
                    print(y);
                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.shouldRemoveSemicons = false

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testRemoveSemicolons() {
        let source = """
            public class Foo{
                func foo(){
                    print(x);print(y);
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    print(x)
                    print(y)
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testFormatCommas() {
        let source = """
            public class Foo:NSObject{
                func foo(name:String,age:Int){

                }

                func bar<T,E:NSObject>(name:T,o:E){

                }
            }
            """

        let expected = """
            public class Foo : NSObject {
                func foo(name: String, age: Int) {

                }

                func bar<T, E: NSObject>(name: T, o: E) {

                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testFormatEqualityOperators() {
        let source = """
            public class Foo {
                func foo() {
                    let x = 1
                    let y = 1
                    if x==y {

                    }
                    if x  !=    y{

                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    let x = 1
                    let y = 1
                    if x == y {

                    }
                    if x != y {

                    }
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesWithinFunctionCallParenthese() {
        let source = """
            public class Foo {
                func foo(a: Int) {
                    foo(0)
                }
            }
            """

        let expected = """
            public class Foo {
                func foo(a: Int) {
                    foo( 0 )
                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.spaces.within.functionCallParentheses = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesWithinIfWhileSwitchCatchParenthese() {
        let source = """
            public class Foo {
                func foo(a: Int) {
                    if (a > 0) {

                    } else if (a > 1) {

                    }
                    while (a != 0) {

                    }
                    repeat {

                    }while (a==0)
                    switch (a) {
                    default:
                        break
                    }
                    do {

                    } catch (let error) {

                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo(a: Int) {
                    if ( a > 0 ) {

                    } else if ( a > 1 ) {

                    }
                    while ( a != 0 ) {

                    }
                    repeat {

                    } while ( a == 0 )
                    switch ( a ) {
                    default:
                        break
                    }
                    do {

                    } catch ( let error ) {

                    }
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.spaces.within.ifParentheses = true
        configuration.spaces.within.whileParentheses = true
        configuration.spaces.within.switchParentheses = true
        configuration.spaces.within.catchParentheses = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesWithinAttributeParentheses() {
        let source = """
            public class Foo{
                @available (*,unavailable,renamed:"bar()")
                func foo(){

                }

                @available(*, deprecated, renamed: "bar()")
                func bar() {

                }
            }
            """

        let expected = """
            public class Foo {
                @available( *, unavailable, renamed: "bar()" )
                func foo() {

                }

                @available( *, deprecated, renamed: "bar()" )
                func bar() {

                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.spaces.within.attributeParentheses = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesWithinBrackets() {
        let source = """
            public class Foo{
                func foo() {
                    let array = ["One", "Two", "Three", "Four", "Five"]
                    var emptyArray: [Int] = []

                    let dictionary = ["One": 1, "Two": 2, "Three": 3, "Four": 4, "Five": 5]
                    var emptyDictionary: [String: Int] = [:]
                }

                func bar(a: [Int]) {
                    print(a[0])
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    let array = [ "One", "Two", "Three", "Four", "Five" ]
                    var emptyArray: [ Int ] = []

                    let dictionary = [ "One": 1, "Two": 2, "Three": 3, "Four": 4, "Five": 5 ]
                    var emptyDictionary: [ String: Int ] = [:]
                }

                func bar(a: [ Int ]) {
                    print(a[ 0 ])
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.spaces.within.brackets = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesWithinFunctionParentheses() {
        let source = """
            public class Foo{
                func foo(){
                    foo()
                }

                func foo(a: Int, b: Int){
                    foo(a: 0, b: 1)
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    foo()
                }

                func foo( a: Int, b: Int ) {
                    foo( a: 0, b: 1 )
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.spaces.within.functionDeclarationParentheses = true
        configuration.spaces.within.functionCallParentheses = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesWithinEmptyFunctionParentheses() {
        let source = """
            public class Foo{
                func foo(){
                    foo()
                }

                func foo(a:Int,b:Int){
                    foo(a: 0, b: 1)
                }
            }
            """

        let expected = """
            public class Foo {
                func foo( ) {
                    foo( )
                }

                func foo( a: Int, b: Int ) {
                    foo( a: 0, b: 1 )
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.spaces.within.functionDeclarationParentheses = true
        configuration.spaces.within.functionCallParentheses = true
        configuration.spaces.within.emptyFunctionDeclarationParentheses = true
        configuration.spaces.within.emptyFunctionCallParentheses = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesBeforeForInStatementParentheses() {
        let source = """
            public class Foo {
                func foo() {
                    var array = [0, 1, 2]
                    for i in (0..<array.count).reversed() {
                        array.append(0)
                    }
                    for i in(0..<array.count).reversed() {
                        array.append(0)
                    }
                    for(i)in(0..<array.count).reversed() {
                        array.append(0)
                    }
                    for (i)in(0..<array.count).reversed() {
                        array.append(0)
                    }
                    for(i) in(0..<array.count).reversed() {
                        array.append(0)
                    }
                    for (i) in(0..<array.count).reversed() {
                        array.append(0)
                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    var array = [0, 1, 2]
                    for i in (0..<array.count).reversed() {
                        array.append(0)
                    }
                    for i in (0..<array.count).reversed() {
                        array.append(0)
                    }
                    for (i) in (0..<array.count).reversed() {
                        array.append(0)
                    }
                    for (i) in (0..<array.count).reversed() {
                        array.append(0)
                    }
                    for (i) in (0..<array.count).reversed() {
                        array.append(0)
                    }
                    for (i) in (0..<array.count).reversed() {
                        array.append(0)
                    }
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesBeforeIfStatementParentheses() {
        let source = """
            public class Foo {
                func foo() {
                    var array = [0, 1, 2]
                    if(array.index(after: 2) == 1) {
                        array.append(0)
                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() {
                    var array = [0, 1, 2]
                    if (array.index(after: 2) == 1) {
                        array.append(0)
                    }
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesInAvailabilityConditions() {
        let source = """
            if #available(iOS 9.0, *) {

            } else {
                UIApplication.shared.openURL(url)
            }
            if #available(iOS 9.0,*) {

            } else {
                UIApplication.shared.openURL(url)
            }
            """

        let expected = """
            if #available(iOS 9.0, *) {

            } else {
                UIApplication.shared.openURL(url)
            }
            if #available(iOS 9.0, *) {

            } else {
                UIApplication.shared.openURL(url)
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesAroundAssignmentOperators() {
        let source = """
            let contentHeight=40
            let hasHeader=true
            let rowHeight: Int
            if hasHeader {
                rowHeight=contentHeight+50
            } else {
                rowHeight=contentHeight+20
            }
            """

        let expected = """
            let contentHeight = 40
            let hasHeader = true
            let rowHeight: Int
            if hasHeader {
                rowHeight = contentHeight + 50
            } else {
                rowHeight = contentHeight + 20
            }

            """
        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
}
