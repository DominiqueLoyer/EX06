// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library unittest.pretty_print;

import 'utils.dart';

/**
 * Returns a pretty-printed representation of [object].
 *
 * If [maxLineLength] is passed, this will attempt to ensure that each line is
 * no longer than [maxLineLength] characters long. This isn't guaranteed, since
 * individual objects may have string representations that are too long, but
 * most lines will be less than [maxLineLength] long.
 *
 * If [maxItems] is passed, [Iterable]s and [Map]s will only print their first
 * [maxItems] members or key/value pairs, respectively.
 */
String prettyPrint(object, {int maxLineLength, int maxItems}) {
  String _prettyPrint(object, int indent, Set seen, bool top) {
    // Avoid looping infinitely on recursively-nested data structures.
    if (seen.contains(object)) return "(recursive)";
    seen = seen.union(new Set.from([object]));
    String pp(child) => _prettyPrint(child, indent + 2, seen, false);

    if (object is Iterable) {
      // Print the type name for non-List iterables.
      var type = object is List ? "" : typeName(object) + ":";

      // Truncate the list of strings if it's longer than [maxItems].
      var strings = object.map(pp).toList();
      if (maxItems != null && strings.length > maxItems) {
        strings.replaceRange(maxItems - 1, strings.length, ['...']);
      }

      // If the printed string is short and doesn't contain a newline, print it
      // as a single line.
      var singleLine = "$type[${strings.join(', ')}]";
      if ((maxLineLength == null ||
              singleLine.length + indent <= maxLineLength) &&
          !singleLine.contains("\n")) {
        return singleLine;
      }

      // Otherwise, print each member on its own line.
      return "$type[\n" + strings.map((string) {
        return _indent(indent + 2) + string;
      }).join(",\n") + "\n" + _indent(indent) + "]";
    } else if (object is Map) {
      // Convert the contents of the map to string representations.
      var strings = object.keys.map((key) {
        return '${pp(key)}: ${pp(object[key])}';
      }).toList();

      // Truncate the list of strings if it's longer than [maxItems].
      if (maxItems != null && strings.length > maxItems) {
        strings.replaceRange(maxItems - 1, strings.length, ['...']);
      }

      // If the printed string is short and doesn't contain a newline, print it
      // as a single line.
      var singleLine = "{${strings.join(", ")}}";
      if ((maxLineLength == null ||
              singleLine.length + indent <= maxLineLength) &&
          !singleLine.contains("\n")) {
        return singleLine;
      }

      // Otherwise, print each key/value pair on its own line.
      return "{\n" + strings.map((string) {
        return _indent(indent + 2) + string;
      }).join(",\n") + "\n" + _indent(indent) + "}";
    } else if (object is String) {
      // Escape strings and print each line on its own line.
      var lines = object.split("\n");
      return "'" + lines.map(escapeString)
          .join("\\n'\n${_indent(indent + 2)}'") + "'";
    } else {
      var value = object.toString().replaceAll("\n", _indent(indent) + "\n");
      var defaultToString = value.startsWith("Instance of ");

      // If this is the top-level call to [prettyPrint], wrap the value on angle
      // brackets to set it apart visually.
      if (top) value = "<$value>";

      // Print the type of objects with custom [toString] methods. Primitive
      // objects and objects that don't implement a custom [toString] don't need
      // to have their types printed.
      if (object is num || object is bool || object is Function ||
          object == null || defaultToString) {
        return value;
      } else {
        return "${typeName(object)}:$value";
      }
    }
  }

  return _prettyPrint(object, 0, new Set(), true);
}

String _indent(int length) => new List.filled(length, ' ').join('');
