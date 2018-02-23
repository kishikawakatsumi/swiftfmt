//
//  ConfigurationTests.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/21.
//

import XCTest
@testable import swiftfmt_core

class ConfigurationTests : XCTestCase {
    func testSpacesBeforeParentheses1() {
        let source = """
            @objc (bar)
            public func foo (a: Int) {
                func foo (a: Int) {

                }
                if(value != nil) {
                    print (value)
                }
                while(value != nil) {
                    print (value)
                }
                switch(value) {
                case 0:
                    break
                default:
                    break
                }
                do {

                } catch(let error) {

                }
            }
            """

        let expected = """
            @objc(bar)
            public func foo(a: Int) {
                func foo(a: Int) {

                }
                if (value != nil) {
                    print(value)
                }
                while (value != nil) {
                    print(value)
                }
                switch (value) {
                case 0:
                    break
                default:
                    break
                }
                do {

                } catch (let error) {

                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.spaces.before.parentheses.functionDeclaration = false
        configuration.spaces.before.parentheses.functionCall = false
        configuration.spaces.before.parentheses.if = true
        configuration.spaces.before.parentheses.while = true
        configuration.spaces.before.parentheses.switch = true
        configuration.spaces.before.parentheses.catch = true
        configuration.spaces.before.parentheses.attribute = false

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesBeforeIfParentheses2() {
        let source = """
            @objc(bar)
            public func foo(a: Int) {
                func foo(a: Int) {

                }
                if (value != nil) {
                    print(value)
                }
                while (value != nil) {
                    print(value)
                }
                switch (value) {
                case 0:
                    break
                default:
                    break
                }
                do {

                } catch (let error) {

                }
            }
            """

        let expected = """
            @objc (bar)
            public func foo (a: Int) {
                func foo (a: Int) {

                }
                if(value != nil) {
                    print (value)
                }
                while(value != nil) {
                    print (value)
                }
                switch(value) {
                case 0:
                    break
                default:
                    break
                }
                do {

                } catch(let error) {

                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.spaces.before.parentheses.functionDeclaration = true
        configuration.spaces.before.parentheses.functionCall = true
        configuration.spaces.before.parentheses.if = false
        configuration.spaces.before.parentheses.while = false
        configuration.spaces.before.parentheses.switch = false
        configuration.spaces.before.parentheses.catch = false
        configuration.spaces.before.parentheses.attribute = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesBeforeLeftBrace1() {
        let source = """
            public struct Foo{
                public func foo(a: Int){
                    func foo(a: Int){

                    }
                    if value != nil{
                        print(value)
                    }
                    while value != nil{
                        print(value)
                    }
                    repeat{

                    } while value != nil
                    for _ in 0..<value{

                    }
                    switch value{
                    case 0:
                        break
                    default:
                        break
                    }
                    do{

                    } catch(let error){

                    } catch{

                    }
                }
            }
            """

        let expected = """
            public struct Foo {
                public func foo(a: Int) {
                    func foo(a: Int) {

                    }
                    if value != nil {
                        print(value)
                    }
                    while value != nil {
                        print(value)
                    }
                    repeat {

                    } while value != nil
                    for _ in 0..<value {

                    }
                    switch value {
                    case 0:
                        break
                    default:
                        break
                    }
                    do {

                    } catch (let error) {

                    } catch {

                    }
                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.spaces.before.leftBrace.typeDeclaration = true
        configuration.spaces.before.leftBrace.function = true
        configuration.spaces.before.leftBrace.if = true
        configuration.spaces.before.leftBrace.else = true
        configuration.spaces.before.leftBrace.for = true
        configuration.spaces.before.leftBrace.while = true
        configuration.spaces.before.leftBrace.do = true
        configuration.spaces.before.leftBrace.switch = true
        configuration.spaces.before.leftBrace.catch = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesBeforeLeftBrace2() {
        let source = """
            public struct Foo {
                public func foo(a: Int) {
                    func foo(a: Int) {

                    }
                    if value != nil {
                        print(value)
                    }
                    while value != nil {
                        print(value)
                    }
                    repeat {

                    } while value != nil
                    for _ in 0..<value {

                    }
                    switch value {
                    case 0:
                        break
                    default:
                        break
                    }
                    do {

                    } catch (let error) {

                    } catch {

                    }
                }
            }
            """

        let expected = """
            public struct Foo{
                public func foo(a: Int){
                    func foo(a: Int){

                    }
                    if value != nil{
                        print(value)
                    }
                    while value != nil{
                        print(value)
                    }
                    repeat{

                    } while value != nil
                    for _ in 0..<value{

                    }
                    switch value{
                    case 0:
                        break
                    default:
                        break
                    }
                    do{

                    } catch (let error){

                    } catch{

                    }
                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.spaces.before.leftBrace.typeDeclaration = false
        configuration.spaces.before.leftBrace.function = false
        configuration.spaces.before.leftBrace.if = false
        configuration.spaces.before.leftBrace.else = false
        configuration.spaces.before.leftBrace.for = false
        configuration.spaces.before.leftBrace.while = false
        configuration.spaces.before.leftBrace.do = false
        configuration.spaces.before.leftBrace.switch = false
        configuration.spaces.before.leftBrace.catch = false

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesBeforeKeywords1() {
        let source = """
            public struct Foo {
                public func foo(a: Int) {
                    if value != nil {
                        print(value)
                    }else if value == nil {

                    }else {

                    }
                    repeat {

                    }while value != nil
                    do {

                    }catch (let error) {

                    }catch {

                    }
                }
            }
            """

        let expected = """
            public struct Foo {
                public func foo(a: Int) {
                    if value != nil {
                        print(value)
                    } else if value == nil {

                    } else {

                    }
                    repeat {

                    } while value != nil
                    do {

                    } catch (let error) {

                    } catch {

                    }
                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.spaces.before.keywords.else = true
        configuration.spaces.before.keywords.while = true
        configuration.spaces.before.keywords.catch = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testSpacesBeforeKeywords2() {
        let source = """
            public struct Foo {
                public func foo(a: Int) {
                    if value != nil {
                        print(value)
                    } else if value == nil {

                    } else {

                    }
                    repeat {

                    } while value != nil
                    do {

                    } catch (let error) {

                    } catch {

                    }
                }
            }
            """

        let expected = """
            public struct Foo {
                public func foo(a: Int) {
                    if value != nil {
                        print(value)
                    }else if value == nil {

                    }else {

                    }
                    repeat {

                    }while value != nil
                    do {

                    }catch (let error) {

                    }catch {

                    }
                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.spaces.before.keywords.else = false
        configuration.spaces.before.keywords.while = false
        configuration.spaces.before.keywords.catch = false

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
}
