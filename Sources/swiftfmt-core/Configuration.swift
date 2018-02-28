//
//  Configuration.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation

public struct Configuration : Codable {
    public init() {}

    public static func load(file: URL) -> Configuration? {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: file), let configuration = try? decoder.decode(Configuration.self, from: data) {
            return configuration
        }
        return nil
    }

    // FIXME: Not implemented
    public var hardWrapAt = 120

    public var indentation = Indentation()

    public var spaces = Spaces()
    public var braces = Braces()
    public var wrapping = Wrapping()
    public var blankLines = BlankLines()

    public var shouldRemoveSemicons = true

    public struct Indentation : Codable {
        public var useTabCharacter = false
        public var tabSize = 4
        public var indent = 4
        public var continuationIndent = 8
        public var keepIndentsOnEmptyLines = false
        public var indentCaseBranches = false
    }

    public struct Spaces : Codable {
        var before = Before()
        var around = Around()
        var within = Within()
        var inTernaryOperator = InTernaryOperator()
        var comma = Comma()
        var semicolon = Semicolon()

        public struct Before : Codable {
            var parentheses = Parentheses()
            var leftBrace = LeftBrace()
            var keywords = Keywords()

            public struct Parentheses : Codable {
                var functionDeclaration = false
                var functionCall = false
                var `if` = true
                var `while` = true
                var `switch` = true
                var `catch` = true
                var attribute = false
            }

            public struct LeftBrace : Codable {
                var typeDeclaration = true
                var function = true
                var `if` = true
                var `else` = true
                var `for` = true
                var `while` = true
                var `do` = true
                var `switch` = true
                var `catch` = true
            }

            public struct Keywords : Codable {
                var `else` = true
                var `while` = true
                var `catch` = true
            }
        }

        public struct Around : Codable {
            var operators = Operators()
            var colons = Colons()

            public struct Operators : Codable {
                var assignmentOperators = true // =, +=, -=, *=, /=, %=, &=, |=, ^=
                var logicalOperators = true // &&, ||
                var equalityOperators = true // ==, ===, !=, !==
                var relationalOperators = true // <, >, <=, >=
                var bitwiseOperators = true // &, |, ^
                var additiveOperators = true // +, -
                var multiplicativeOperators = true // *, /, %
                var shiftOperators = true // <<, >>
                var rangeOperators = false // ..., ..<
                var closureArrow = true // ->
            }

            public struct Colons : Codable {
                var beforeTypeAnnotations = false
                var afterTypeAnnotations = true
                var beforeTypeInheritanceClauses = true
                var afterTypeInheritanceClauses = true
                var beforeTypeInheritanceClausesInTypeArguments = false
                var afterTypeInheritanceClausesInTypeArguments = true
                var beforeDictionaryTypes = false
                var afterDictionaryTypes = true
                var beforeDictionaryLiteralKeyValuePair = false
                var afterDictionaryLiteralKeyValuePair = true
                var beforeAttributeArguments = false
                var afterAttributeArguments = true
            }
        }

        struct Within : Codable {
            var codeBraces = true
            var brackets = false
            var arrayAndDictionaryLiteralBrackets = false
            var groupingParentheses = false
            var functionDeclarationParentheses = false
            var emptyFunctionDeclarationParentheses = false
            var functionCallParentheses = false
            var emptyFunctionCallParentheses = false
            var ifParentheses = false
            var whileParentheses = false
            var switchParentheses = false
            var catchParentheses = false
            var attributeParentheses = false
        }

        struct InTernaryOperator : Codable {
            var afterQuestionMark = true
            var afterColon = true
            var beforeColon = true
        }

        struct Comma : Codable {
            var before = false
            var after = true
            var afterWithinTypeArguments = true
        }

        struct Semicolon : Codable {
            var before = false
            var after = true
        }
    }

    public struct Braces : Codable {
        public var placement = Placement()

        public struct Placement : Codable {
            var inTypeDeclarations = BracesPlacementOptions.endOfLine
            var inFunctions = BracesPlacementOptions.endOfLine
            var inOther = BracesPlacementOptions.endOfLine
        }
    }

    public struct Wrapping : Codable {
        public var keepWhenReformatting = KeepWhenReformatting()

        public var ifStatement = IfStatement()
        public var guardStatement = GuardStatement()
        public var repeatWhileStatement = RepeatWhileStatement()
        public var doStatement = DoStatement()
        public var modifierList = ModifierList()

        public var alignment = Alignment()

        public struct IfStatement : Codable {
            var elseOnNewLine = false
        }
        public struct GuardStatement : Codable {
            var elseOnNewLine = false
        }
        public struct RepeatWhileStatement : Codable {
            var whileOnNewLine = false
        }
        public struct DoStatement : Codable {
            var catchOnNewLine = false
        }
        // FIXME: Not implemented yet
        public struct ModifierList : Codable {
            var wrapAfterModifierList = false
        }

        // FIXME: Not implemented yet
        public struct KeepWhenReformatting : Codable {
            public var lineBreakes = true
            public var commentAtFirstColumn = true
            public var simpleBlocksAndTrailingClosuresInOneLine = true
            public var simpleFunctionsInOneLine = true
            public var simpleClosureArgumentsInOneLine = true
        }

        // FIXME: Not implemented yet
        public struct Alignment : Codable {
            public var baseClassAndAdoptedProtocolList = BaseClassAndAdoptedProtocolList()
            public var functionDeclarationParameters = FunctionDeclarationParameters()
            public var functionCallArguments = FunctionCallArguments()
            public var chainedMethodCalls = ChainedMethodCalls()
            public var closures = Closures()

            public struct BaseClassAndAdoptedProtocolList : Codable {
                public var wrapping = WrappingOptions.doNotWrap
                public var alignWhenMultiline = false
            }

            public struct FunctionDeclarationParameters : Codable {
                public var wrapping = WrappingOptions.doNotWrap // FIXME: Not implemented
                public var alignWhenMultiline = true
                public var newLineAfterLeftParenthesis = false // FIXME: Not implemented
                public var placeRightParenthesisOnNewLine = false // FIXME: Not implemented
            }

            public struct FunctionCallArguments : Codable {
                public var wrapping = WrappingOptions.doNotWrap // FIXME: Not implemented
                public var alignWhenMultiline = true
                public var newLineAfterLeftParenthesis = false // FIXME: Not implemented
                public var placeRightParenthesisOnNewLine = false // FIXME: Not implemented
            }

            public struct ChainedMethodCalls : Codable {
                public var wrapping = WrappingOptions.doNotWrap // FIXME: Not implemented
                public var alignWhenMultiline = false
            }

            public struct Closures : Codable {
                public var parametersOnNewLineWhenMultiline = false
            }

            public struct ConditionClauses : Codable {
                public var wrapping = WrappingOptions.doNotWrap // FIXME: Not implemented
                public var alignWhenMultiline = false
            }
        }
    }

    public struct BlankLines : Codable {
        public var keepMaximumBlankLines = KeepMaximumBlankLines()
        public var minimumBlankLines = MinimumBlankLines()

        public struct KeepMaximumBlankLines : Codable {
            public var inDeclarations = 2
            public var inCode = 2
            public var beforeClosingBrace = 2
        }

        public struct MinimumBlankLines : Codable {
            public var beforeImports = 1
            public var afterImports = 1
            public var aroundTypeDeclarations = 1
            public var aroundPropertyInProtocol = 0
            public var aroundProperty = 0
            public var aroundFunctionInProtocol = 0
            public var aroundFunction = 1
            // FIXME: Not implemented yet
            public var beforeFunctionBody = 0
        }
    }

    public enum WrappingOptions : Int, Codable {
        case doNotWrap
        case wrapIfLong
        case chopDownIfLong
        case wrapAlways
    }

    public enum BracesPlacementOptions : Int, Codable {
        case endOfLine
        case nextLine
    }

    public enum AlignmentOptions : Int, Codable {
        case alignWhenMultiline
        case alignParenthesisedWhenMultiline
        case alignInColumns
        case elseOnNewLine
        case specialElseIfTreatment
        case indentCaseBranches
    }
}
