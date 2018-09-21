#!/usr/bin/env python3

import argparse


def main():
    ret_val = 0

    with open('sample_file') as file_source:
        data = file_source.read().rstrip()

    data = int(data)

    if data > 20:
        ret_val = 2
    elif data > 10:
        ret_val = 1

    return ret_val


if __name__ == "__main__":
    main()
