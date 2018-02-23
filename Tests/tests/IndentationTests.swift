//
//  IndentationTests.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import XCTest
@testable import swiftfmt_core

class IndentationTests : XCTestCase {
    func testFormatIndentation() {
        let source = """
            import Foundation
            import SwiftSyntax

            public class Foo : NSObject {
            public let x = [1, 3, 5, 7, 9, 11]

            /// Description
            ///
            /// - Parameters:
            ///   - a: param a
            ///   - b: param b
            /// - Returns: String value
            func foo(a: Bool, x: Int, y: Int, z: Int) -> String {
            do
            {
            let contents = try String(contentsOfFile: "/usr/bin/swift")
            if contents.isEmpty { print(contents) } else if contents.count > 10 {
            /*
             Block
             Comment
             */
            for char in contents {
            // Line Comment
            print(
            char
            )
            _ = contents.map({ (c) -> String in
            _ =
            String(c).map({ (c) -> String in
            return String(c)
            })
            return ""
            }).map {
            return $0
            }
            }
            } else {
            switch x {
            case 0:
            break
            case 1:
            print(y)
            print(z)
            default:
            break
            }
            }
            } catch {
            print(error)
            }

            return "bar"
            }

            private class Inner {
            let x = 0
            }
            }

            enum Fruit {
            case banana
            }
            """

        let expected = """
            import Foundation
            import SwiftSyntax

            public class Foo : NSObject {
                public let x = [1, 3, 5, 7, 9, 11]

                /// Description
                ///
                /// - Parameters:
                ///   - a: param a
                ///   - b: param b
                /// - Returns: String value
                func foo(a: Bool, x: Int, y: Int, z: Int) -> String {
                    do {
                        let contents = try String(contentsOfFile: "/usr/bin/swift")
                        if contents.isEmpty { print(contents) } else if contents.count > 10 {
                            /*
                             Block
                             Comment
                             */
                            for char in contents {
                                // Line Comment
                                print(
                                    char
                                )
                                _ = contents.map({ (c) -> String in
                                    _ =
                                    String(c).map({ (c) -> String in
                                        return String(c)
                                    })
                                    return ""
                                }).map {
                                    return $0
                                }
                            }
                        } else {
                            switch x {
                            case 0:
                                break
                            case 1:
                                print(y)
                                print(z)
                            default:
                                break
                            }
                        }
                    } catch {
                        print(error)
                    }

                    return "bar"
                }

                private class Inner {
                    let x = 0
                }
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

    func testIndentSwitchStatementCaseBranches() {
        let source = """
            public class Foo {
            func foo(x: Int, y: Int, z: Int) {
            switch x {
            case 0:
            break
            case 1:
            print(y)
            print(z)
            default:
            print(y)
            print(z)
            }
            }
            }
            """

        let expected = """
            public class Foo {
                func foo(x: Int, y: Int, z: Int) {
                    switch x {
                        case 0:
                            break
                        case 1:
                            print(y)
                            print(z)
                        default:
                            print(y)
                            print(z)
                    }
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.indentation.indentCaseBranches = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testIndentClosureExpressions1() {
        let source = """
            public class Foo {
                func foo(x: Int, y: Int, z: Int) {
                    var tokens = ["a", "b"]
                    tokens.map {
                        print($0)
                    }.map {
                        "c"
                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo(x: Int, y: Int, z: Int) {
                    var tokens = ["a", "b"]
                    tokens.map {
                        print($0)
                    }.map {
                        "c"
                    }
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testIndentClosureExpressions2() {
        let source = """
            public class ViewController : UIViewController {
                override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
                    coordinator.animate(alongsideTransition: { (context) in
                        self.adjustThumbnailViewHeight()
                    }, completion: nil)
                }
            }
            """

        let expected = """
            public class ViewController : UIViewController {
                override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
                    coordinator.animate(alongsideTransition: { (context) in
                        self.adjustThumbnailViewHeight()
                    }, completion: nil)
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testContinuousStatement() {
        let source = """
            func actionMenuViewControllerShareDocument(_ actionMenuViewController: ActionMenuViewController) {
                let mailComposeViewController = MFMailComposeViewController()
                if let lastPathComponent = pdfDocument?.documentURL?.lastPathComponent,
                    let documentAttributes = pdfDocument?.documentAttributes,
                    let attachmentData = pdfDocument?.dataRepresentation() {
                    if let title = documentAttributes["Title"] as? String {
                        mailComposeViewController.setSubject(title)
                    }
                    mailComposeViewController.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: lastPathComponent)
                }
            }

            @objc func showSearchView(_ sender: UIBarButtonItem) {
                if let searchNavigationController = self.searchNavigationController {
                    present(searchNavigationController, animated: true, completion: nil)
                } else if let navigationController = storyboard?.instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as? UINavigationController,
                    let searchViewController = navigationController.topViewController as? SearchViewController {
                    searchViewController.pdfDocument = pdfDocument
                    searchViewController.delegate = self
                    present(navigationController, animated: true, completion: nil)

                    searchNavigationController = navigationController
                }
            }
            """
        let expected = """
            func actionMenuViewControllerShareDocument(_ actionMenuViewController: ActionMenuViewController) {
                let mailComposeViewController = MFMailComposeViewController()
                if let lastPathComponent = pdfDocument?.documentURL?.lastPathComponent,
                   let documentAttributes = pdfDocument?.documentAttributes,
                   let attachmentData = pdfDocument?.dataRepresentation() {
                    if let title = documentAttributes["Title"] as? String {
                        mailComposeViewController.setSubject(title)
                    }
                    mailComposeViewController.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: lastPathComponent)
                }
            }

            @objc func showSearchView(_ sender: UIBarButtonItem) {
                if let searchNavigationController = self.searchNavigationController {
                    present(searchNavigationController, animated: true, completion: nil)
                } else if let navigationController = storyboard?.instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as? UINavigationController,
                          let searchViewController = navigationController.topViewController as? SearchViewController {
                    searchViewController.pdfDocument = pdfDocument
                    searchViewController.delegate = self
                    present(navigationController, animated: true, completion: nil)

                    searchNavigationController = navigationController
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testStringInterpolation() {
        let source = """
            open class AcknowListViewController: UITableViewController {
                // MARK: - Paths

                class func acknowledgementsPlistPath(name:String) -> String? {
                    return Bundle.main.path(forResource: name, ofType: "plist")
                }

                class func defaultAcknowledgementsPlistPath() -> String? {
                    guard let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
                        return nil
                    }

                    let defaultAcknowledgementsPlistName = "Pods-\\(bundleName)-acknowledgements"
                    let defaultAcknowledgementsPlistPath = self.acknowledgementsPlistPath(name: defaultAcknowledgementsPlistName)

                    if let defaultAcknowledgementsPlistPath = defaultAcknowledgementsPlistPath,
                        FileManager.default.fileExists(atPath: defaultAcknowledgementsPlistPath) == true {
                        return defaultAcknowledgementsPlistPath
                    }
                    else {
                        // Legacy value
                        return self.acknowledgementsPlistPath(name: "Pods-acknowledgements")
                    }
                }
            }
            """
        let expected = """
            open class AcknowListViewController : UITableViewController {
                // MARK: - Paths

                class func acknowledgementsPlistPath(name: String) -> String? {
                    return Bundle.main.path(forResource: name, ofType: "plist")
                }

                class func defaultAcknowledgementsPlistPath() -> String? {
                    guard let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
                        return nil
                    }

                    let defaultAcknowledgementsPlistName = "Pods-\\(bundleName)-acknowledgements"
                    let defaultAcknowledgementsPlistPath = self.acknowledgementsPlistPath(name: defaultAcknowledgementsPlistName)

                    if let defaultAcknowledgementsPlistPath = defaultAcknowledgementsPlistPath,
                       FileManager.default.fileExists(atPath: defaultAcknowledgementsPlistPath) == true {
                        return defaultAcknowledgementsPlistPath
                    } else {
                        // Legacy value
                        return self.acknowledgementsPlistPath(name: "Pods-acknowledgements")
                    }
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testAligmentClosureArguments1() {
        let source = """
            open class AcknowListViewController : UITableViewController {
                @discardableResult
                public func setImage(with resource: Resource?,
                                     placeholder: Placeholder? = nil,
                                     options: KingfisherOptionsInfo? = nil,
                                     progressBlock: DownloadProgressBlock? = nil,
                                     completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
                    UIView.transition(with: strongBase, duration: 0.0, options: [], animations: { maybeIndicator?.stopAnimatingView() }, completion: { _ in
                        self.placeholder = nil
                        UIView.transition(with: strongBase, duration: transition.duration, options: [transition.animationOptions, .allowUserInteraction], animations: {
                            // Set image property in the animation.
                            transition.animations?(strongBase, image)
                        }, completion: { finished in
                            transition.completion?(finished)
                            completionHandler?(image, error, cacheType, imageURL)
                        })
                    })
                }
            }
            """
        let expected = """
            open class AcknowListViewController : UITableViewController {
                @discardableResult
                public func setImage(with resource: Resource?,
                                     placeholder: Placeholder? = nil,
                                     options: KingfisherOptionsInfo? = nil,
                                     progressBlock: DownloadProgressBlock? = nil,
                                     completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
                    UIView.transition(with: strongBase, duration: 0.0, options: [], animations: { maybeIndicator?.stopAnimatingView() }, completion: { _ in
                        self.placeholder = nil
                        UIView.transition(with: strongBase, duration: transition.duration, options: [transition.animationOptions, .allowUserInteraction], animations: {
                            // Set image property in the animation.
                            transition.animations?(strongBase, image)
                        }, completion: { finished in
                            transition.completion?(finished)
                            completionHandler?(image, error, cacheType, imageURL)
                        })
                    })
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testAligmentClosureArguments2() {
        let source = """
            open class AcknowListViewController : UITableViewController {
                @discardableResult
                public func setImage(with resource: Resource?,
                                     placeholder: Placeholder? = nil,
                                     options: KingfisherOptionsInfo? = nil,
                                     progressBlock: DownloadProgressBlock? = nil,
                                     completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
                    UIView.transition(with: strongBase, duration: 0.0, options: [],
                                      animations: { maybeIndicator?.stopAnimatingView() },
                                      completion: { _ in
                                          self.placeholder = nil
                                          UIView.transition(with: strongBase, duration: transition.duration,
                                                            options: [transition.animationOptions, .allowUserInteraction],
                                                            animations: {
                                              // Set image property in the animation.
                                              transition.animations?(strongBase, image)
                                          },
                                          completion: { finished in
                                              transition.completion?(finished)
                                              completionHandler?(image, error, cacheType, imageURL)
                                          })
                                      })
                }
            }
            """
        let expected = """
            open class AcknowListViewController : UITableViewController {
                @discardableResult
                public func setImage(with resource: Resource?,
                                     placeholder: Placeholder? = nil,
                                     options: KingfisherOptionsInfo? = nil,
                                     progressBlock: DownloadProgressBlock? = nil,
                                     completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
                    UIView.transition(with: strongBase, duration: 0.0, options: [],
                                      animations: { maybeIndicator?.stopAnimatingView() },
                                      completion: { _ in
                                          self.placeholder = nil
                                          UIView.transition(with: strongBase, duration: transition.duration,
                                                            options: [transition.animationOptions, .allowUserInteraction],
                                                            animations: {
                                                                // Set image property in the animation.
                                                                transition.animations?(strongBase, image)
                                                            },
                                                            completion: { finished in
                                                                transition.completion?(finished)
                                                                completionHandler?(image, error, cacheType, imageURL)
                                                            })
                                      })
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testAlignment() {
        let source = """
            public func object<Element: Object, KeyType>(ofType type: Element.Type, forPrimaryKey key: KeyType) -> Element? {
                return unsafeBitCast(RLMGetObject(rlmRealm, (type as Object.Type).className(),
                                                  dynamicBridgeCast(fromSwift: key)) as! RLMObjectBase?,
                                     to: Optional<Element>.self)
            }
            """
        let expected = """
            public func object<Element: Object, KeyType>(ofType type: Element.Type, forPrimaryKey key: KeyType) -> Element? {
                return unsafeBitCast(RLMGetObject(rlmRealm, (type as Object.Type).className(),
                                                  dynamicBridgeCast(fromSwift: key)) as! RLMObjectBase?,
                                     to: Optional<Element>.self)
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
}
