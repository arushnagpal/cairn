#!/usr/bin/env python3
"""Cairn validator — thin Python wrapper around validate.sh.

Delegates all logic to validate.sh. Use `sh cairn/tools/validate.sh` directly
for zero-dependency validation. This wrapper exists for Python-native workflows.

Exit codes: 0=healthy 1=size 2=structure 3=staleness 4=config
"""
import subprocess
import sys
from pathlib import Path


def main():
    sh = Path(__file__).parent / "validate.sh"
    result = subprocess.run(["sh", str(sh)] + sys.argv[1:])
    sys.exit(result.returncode)


if __name__ == "__main__":
    main()
