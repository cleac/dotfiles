#!/usr/bin/env python3

import os
import re
import sys


mp3_match_regex = re.compile(r'(?P<name>[\W\w]*).mp3')

def self(itm):
    return itm

def main():
    target_dir = sys.argv[1]
    for (dirname, _, filenames) in os.walk(target_dir):
        for fname in filter(
            self, map(mp3_match_regex.match, filenames)
        ):
            fpath = f'{dirname}/{fname.group("name")}'
            os.spawnlp(
                os.P_WAIT,
                'ffmpeg', '-loglevel quiet', '-i',
                f'{fpath}.mp3', f'{fpath}.ogg'
            )


if __name__ == '__main__':
    main()
