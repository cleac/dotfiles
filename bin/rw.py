#!/usr/bin/env python
import fileinput
import re
import sys
import os
import importlib
import importlib.util

CALL_REGEX = re.compile(r'^(?P<offset>\s+)?(.+)?@call (?P<fname>[\w\d]+\.py)(.+)?$')


def load_module(fname):
    spec = importlib.util.spec_from_file_location('external_script', fname)
    external_script = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(external_script)
    return external_script


def process_single_file(fname):
    with open(fname, 'r+') as file:
        contents = file.readlines()

        append_line = -1
        source_file = None
        indentation = ''
        for i, line in enumerate(contents):
            if (match := CALL_REGEX.match(line)) is not None:
                source_file = match.group('fname')
                indentation = match.group('offset') or ''
                append_line = i
                break
        else:
            print('No src file found: exiting')
            sys.exit(1)

    i += 1
    script = load_module(source_file)
    to_insert = [indentation + x for x in script.program()]

    with open(fname, 'w') as file:
        file.write(''.join([
            *contents[:i],
            *to_insert,
            *contents[i:],
        ]))


if __name__ == '__main__':
    for fname in sys.argv[1:]:
        process_single_file(fname)
