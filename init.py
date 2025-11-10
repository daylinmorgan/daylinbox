#!/usr/bin/env python3

import argparse
import subprocess
from pathlib import Path
from typing import List


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--name", default="daylinbox")
    parser.add_argument("--image")
    parser.add_argument("--tag", default="main")
    parser.add_argument("--local", action="store_true", default=False)
    parser.add_argument(
        "--home", type=str, default=Path.home() / "daylinbox" / "daylin"
    )
    parser.add_argument(
        "rest", help="arguments/flags forwarded to distrobox create", nargs="*"
    )  # 0 or more args
    return parser.parse_args()


def create_box(name: str, image: str, home: Path, args: List[str] = []) -> None:
    cmd = ["distrobox", "create", "--name", name, "--image", image, "--home", home]
    cmd += args
    print("running cmd:", cmd)
    subprocess.run(cmd, check=True)


def get_image_name(local: bool, image: str, tag: str) -> str:
    if local:
        return "daylinbox"
    image = image if image else "ghcr.io/daylinmorgan/daylinmorgan"
    return f"{image}:{tag}"


def prepare_home(home: Path):
    if home.is_dir():
        return
    print("preparing home directory of distrobox")
    home.mkdir(parents=True)
    (home / ".config").symlink_to(Path.home() / ".config")


def main():
    args = parse_args()
    print(args)
    prepare_home(args.home)
    create_box(
        args.name,
        get_image_name(args.local, args.image, args.tag),
        args.home,
        args.rest,
    )


if __name__ == "__main__":
    main()
