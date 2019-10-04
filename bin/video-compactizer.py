#!/usr/bin/env python3
import sys
import os
import os.path as path


def cleanup_name(fname):
    fname, ext = path.splitext(fname)
    return '{}{}'.format(''.join(fname.split('-')[:-1]), ext)


def switch_extension(fname, target_ext):
    fname, _ = path.splitext(fname)
    return '{}.{}'.format(fname, target_ext)


def process_single(fname):
    src = fname
    fname = cleanup_name(switch_extension(fname, 'avi'))
    os.spawnlp(
        os.P_WAIT,
        'ffmpeg', '-loglevel quiet',
        '-i', f'{src}',
        # '-s', '720x1280',
        '-s', '1080x1920',
        f'{fname}'
    )


if __name__ == '__main__':
    for fname in sys.argv[1:]:
        process_single(fname)
