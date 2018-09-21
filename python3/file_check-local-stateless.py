#!/usr/bin/env python3

import sys


def main():
    # Setting return value to default to OK
    ret_val = 0

    with open('sample_file') as file_source:
        data = file_source.read().rstrip()

    data = int(data)

    if data > 20:
        # Setting return value to Critical
        ret_val = 2
    elif data > 10:
        # Setting return value to Warning
        ret_val = 1

    return ret_val


if __name__ == "__main__":
    sys.exit(main())
