"""Tests for cairn/tools/validate.sh."""

import os
import sys
import unittest
import tempfile
import subprocess
from pathlib import Path

VALIDATE_SH = Path(__file__).parent.parent / "cairn" / "tools" / "validate.sh"


def run_validator(cairn_root):
    result = subprocess.run(
        ["sh", str(VALIDATE_SH), str(cairn_root)],
        capture_output=True,
        text=True,
    )
    return result.returncode, result.stdout + result.stderr


def make_cairn(tmp, files):
    """Create a minimal cairn root with given file path→content dict."""
    root = Path(tmp) / "cairn"
    root.mkdir()
    (root / "START-HERE.md").write_text("# Start Here\n")
    for path, content in files.items():
        full = root / path
        full.parent.mkdir(parents=True, exist_ok=True)
        full.write_text(content)
    return root


class TestHealthy(unittest.TestCase):
    def test_empty_cairn_is_healthy(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = make_cairn(tmp, {})
            code, out = run_validator(root)
            self.assertEqual(code, 0)
            self.assertIn("OK", out)


class TestSizeViolation(unittest.TestCase):
    def test_file_over_200_lines_exits_1(self):
        big = "\n".join(f"line {i}" for i in range(201))
        with tempfile.TemporaryDirectory() as tmp:
            root = make_cairn(tmp, {"memory/big.md": big})
            code, out = run_validator(root)
            self.assertEqual(code, 1)
            self.assertIn("SIZE VIOLATION", out)
            self.assertIn("Distill", out)

    def test_memory_budget_exceeded_exits_1(self):
        content = "\n".join(f"line {i}" for i in range(180))
        files = {f"memory/f{i}.md": content for i in range(6)}
        with tempfile.TemporaryDirectory() as tmp:
            root = make_cairn(tmp, files)
            code, out = run_validator(root)
            self.assertEqual(code, 1)
            self.assertIn("SIZE VIOLATION", out)


class TestStructureError(unittest.TestCase):
    def test_handoff_missing_required_heading_exits_2(self):
        content = (
            "## What I Did\nstuff\n"
            "## Key Decisions\nnone\n"
            "## Do Not Re-Read\nnone\n"
        )
        with tempfile.TemporaryDirectory() as tmp:
            root = make_cairn(tmp, {"handoffs/h1.md": content})
            code, out = run_validator(root)
            self.assertEqual(code, 2)
            self.assertIn("STRUCTURE ERROR", out)
            self.assertIn("What's Next", out)


class TestStaleness(unittest.TestCase):
    def test_memory_older_than_handoff_exits_3(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = make_cairn(tmp, {
                "memory/notes.md": "# Notes\nsome notes\n",
                "handoffs/h1.md": (
                    "## What I Did\nx\n"
                    "## Key Decisions\ny\n"
                    "## What's Next\nz\n"
                    "## Do Not Re-Read\nnone\n"
                ),
            })
            mem = root / "memory" / "notes.md"
            hand = root / "handoffs" / "h1.md"
            old = hand.stat().st_mtime - 100
            os.utime(mem, (old, old))
            code, out = run_validator(root)
            self.assertEqual(code, 3)
            self.assertIn("STALENESS", out)


class TestConfigError(unittest.TestCase):
    def test_malformed_config_exits_4(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = make_cairn(tmp, {})
            (root / ".cairn.toml").write_text("max_file_lines = not_a_number\n")
            code, out = run_validator(root)
            self.assertEqual(code, 4)

    def test_bad_git_behavior_exits_4(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = make_cairn(tmp, {})
            (root / ".cairn.toml").write_text('git_behavior = invalid\n')
            code, out = run_validator(root)
            self.assertEqual(code, 4)


class TestConfigOverrides(unittest.TestCase):
    def test_custom_max_file_lines_respected(self):
        # File with 15 lines; default max=200 passes; custom max=10 should fail
        content = "\n".join(f"line {i}" for i in range(15))
        with tempfile.TemporaryDirectory() as tmp:
            root = make_cairn(tmp, {"memory/small.md": content})
            (root / ".cairn.toml").write_text("max_file_lines = 10\n")
            code, out = run_validator(root)
            self.assertEqual(code, 1)
            self.assertIn("SIZE VIOLATION", out)


if __name__ == "__main__":
    unittest.main()
