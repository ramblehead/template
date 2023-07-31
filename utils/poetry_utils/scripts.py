# Hey Emacs, this is -*- coding: utf-8; mode: python -*-

import subprocess


def lint() -> None:
    print("Running pyright...")
    subprocess.run("pyright", shell=True)

    print()
    print("Running ruff...")
    subprocess.run("poetry run ruff check .", shell=True)
    # subprocess.run("poetry run ruff check --verbose .", shell=True)
    # subprocess.run("ls -la --color=auto", shell=True, check=True)
    # subprocess.run("ls -la", shell=True, executable="bash", check=True)
    # subprocess.run(["bash", "-i", "-l", "-c", "ls -la"], check=True)


if __name__ == "__main__":
    lint()
