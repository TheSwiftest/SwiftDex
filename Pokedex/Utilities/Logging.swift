//
//  Logging.swift
//  Pokedex
//
//  Created by Brian Corbin on 3/15/21.
//

import Foundation
import Logging

internal let logger = Logger(label: "com.bestcoast.swiftdex", factory: ContextPrefixLogHandler.init)

private struct ContextPrefixLogHandler: LogHandler {
    private var logger: Logger

    subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get { logger[metadataKey: metadataKey] }
        set { logger[metadataKey: metadataKey] = newValue }
    }

    init(label: String) {
        self.logger = Logger(label: label)
        logger.logLevel = .trace
    }

    // `metadata` isn't currently accessible via `logger`, so there's not much we can do.
    // Fortunately, it's not accessed by `Logger` either, so we're just going to ignore it.
    var metadata: Logger.Metadata {
        get { [:] }
        set { _ = newValue }
    }

    var logLevel: Logger.Level {
        get { logger.logLevel }
        set { logger.logLevel = newValue }
    }

    // swiftlint:disable:next function_parameter_count
    func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let filename = URL(fileURLWithPath: file, isDirectory: false).lastPathComponent
        logger.log(
            level: level,
            "\(filename):\(line):\(function)\(message.description.isEmpty ? "" : " - \(message)")",
            metadata: metadata,
            source: source,
            file: file,
            function: function,
            line: line)
    }
}
