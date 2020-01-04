#!/usr/bin/env python3
import sys
import os
import os.path as path


FFMPEG = '/usr/bin/ffmpeg'
QUALITY_CONFIG_FILE = '.compactizer_quality'
CONS_QUALITY_CONFIG_FILE = '.compactizer_cons_quality'


def cleanup_name(fname):
    fname, ext = path.splitext(fname)
    return '{}{}'.format(''.join(fname.split('-')[:-1]), ext)


def switch_extension(fname, target_ext):
    fname, _ = path.splitext(fname)
    return '{}.{}'.format(fname, target_ext)


def f_input(fname):
    return ['-i', fname]


def pass_1(fmt):
    return ['-pass', '1', '-f', fmt, '-y', '/dev/null']


def pass_2(fname):
    return ['-pass', '2', '-y', fname]


def read_quality():
    if path.exists(QUALITY_CONFIG_FILE):
        with open(QUALITY_CONFIG_FILE, 'r') as f:
            try:
                return f.readline()[:-1]
            except IndexError:
                print('Could not read the configuration.'
                      '\nWill try read user input')
    quality = input('Enter desired quality (e.g. 1M, .5M, etc): ')
    if not quality:
        print('No quality passed: exiting')
        sys.exit(1)
    with open(QUALITY_CONFIG_FILE, 'w') as f:
        f.write(quality)
    return quality


def read_cons_quality():
    if path.exists(CONS_QUALITY_CONFIG_FILE):
        with open(CONS_QUALITY_CONFIG_FILE, 'r') as f:
            try:
                return f.readline()[:-1]
            except IndexError:
                print('Could not read the configuration.'
                      '\nWill try read user input')
    quality = input(
        'Enter desired constraint quality '
        '(e.g. 15-30 for HD Ready, 31+ for FullHD): ')
    if not quality:
        print('No quality passed: exiting')
        sys.exit(1)
    with open(CONS_QUALITY_CONFIG_FILE, 'w') as f:
        f.write(quality)
    return quality


def process_single(fname):
    # fname = f'"{fname}"'
    src = fname
    fmt = 'webm'
    fname = switch_extension(src, fmt)
    os.spawnlp(os.P_WAIT, FFMPEG, FFMPEG, *f_input(src))
    params = [
        *f_input(src),
        *[
            '-threads', '3',
            '-b:v', read_quality(),
            '-maxrate', read_quality(),
            '-crf', read_cons_quality(),
            '-vcodec', 'libvpx-vp9',
            '-acodec', 'libopus',
            '-row-mt', '1',
        ]
    ]
    os.spawnvp(
        os.P_WAIT,
        FFMPEG,
        [FFMPEG, *params, *pass_1(fmt)]
    )
    print(f'Writing {fname}')
    os.spawnvp(
        os.P_WAIT,
        FFMPEG,
        [FFMPEG, *params, *pass_2(fname)]
    )


if __name__ == '__main__':
    for fname in sys.argv[1:]:
        process_single(fname)
