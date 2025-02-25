#!/usr/bin/env python3

import argparse
import shutil
import subprocess
import tomllib
from pathlib import Path

arg_parser = argparse.ArgumentParser(
    description=(
        "Downloads all binaries from an eget configuration file, without overwriting"
        " existing ones"
    )
)
arg_parser.add_argument("config", help="Path to eget configuration file")
args = arg_parser.parse_args()

eget = shutil.which("eget")
if eget is None:
    raise FileNotFoundError("Could not find eget")

config_path = args.config
with open(config_path, "rb") as file:
    config = tomllib.load(file)
    globe = config.get("global", {})
    for section, table in config.items():
        parts = section.split("/")
        if len(parts) != 2:
            continue

        opts = globe | table
        target = opts.get("target")
        target_path = Path.cwd() if target is None else Path(target).expanduser()

        repo = parts[1]
        cmd = (
            target_path / opts.get("_cmd", repo)
            if target_path.is_dir()
            else target_path
        )
        if cmd.exists():
            print(f"{section} already installed")
        else:
            subprocess.check_call([eget, section], env={"EGET_CONFIG": config_path})
