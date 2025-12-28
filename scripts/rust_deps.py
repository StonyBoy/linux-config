#!/usr/local/pyvenv/steen/bin/python3

import toml
import requests
import argparse

# --- Argument parser ---
parser = argparse.ArgumentParser(description="Check and optionally update direct dependencies in Cargo.toml")
parser.add_argument(
    "-u", "--update",
    action="store_true",
    help="Update the versions in Cargo.toml to the latest crates.io versions"
)
parser.add_argument(
    "-l", "--list-versions",
    metavar="CRATE",
    help="List all published versions of the specified crate and highlight the latest stable version"
)
args = parser.parse_args()

# --- Function to list all versions of a crate ---
def list_versions(crate_name):
    try:
        response = requests.get(f"https://crates.io/api/v1/crates/{crate_name}/versions")
        response.raise_for_status()
        versions_info = response.json()["versions"]
        versions = [v["num"] for v in versions_info]

        # Determine latest stable version (ignore pre-release versions with '-')
        stable_versions = [v for v in versions if "-" not in v]
        latest_stable = stable_versions[0] if stable_versions else versions[0]

        print(f"All versions of {crate_name}:")
        for v in sorted(versions, key=lambda s: list(map(int, s.split('+')[0].split('.')[:3]))):
            marker = " <- latest stable" if v == latest_stable else ""
            print(f"{v}{marker}")
    except Exception as e:
        print(f"Error fetching versions for {crate_name}: {e}")

# --- If --list-versions is used, do only that ---
if args.list_versions:
    list_versions(args.list_versions)
    exit(0)

# --- Load Cargo.toml ---
cargo_file = "Cargo.toml"
with open(cargo_file) as f:
    cargo_toml = toml.load(f)

# --- Extract direct dependencies ---
def get_direct_dependencies(cargo_toml):
    deps = {}
    for name, info in cargo_toml.get("dependencies", {}).items():
        if isinstance(info, dict):
            version = info.get("version")
        else:
            version = info
        if version:
            deps[name] = info
    return deps

direct_deps = get_direct_dependencies(cargo_toml)

# --- Compare each dependency to the latest on crates.io ---
outdated = []

for name, info in direct_deps.items():
    if isinstance(info, dict):
        current_version = info.get("version")
    else:
        current_version = info
    try:
        response = requests.get(f"https://crates.io/api/v1/crates/{name}")
        response.raise_for_status()
        latest_version = response.json()["crate"]["max_stable_version"]
        if current_version != latest_version:
            outdated.append((name, current_version, latest_version))
            if args.update:
                # Update the version in the cargo_toml structure
                if isinstance(info, dict):
                    info["version"] = latest_version
                else:
                    cargo_toml["dependencies"][name] = latest_version
    except Exception:
        continue

# --- Print outdated dependencies ---
if outdated:
    print("Outdated direct dependencies detected:")
    for name, current_version, latest_version in outdated:
        print(f"{name}: Cargo.toml={current_version}, latest={latest_version}")
else:
    print("All direct dependencies are up to date.")

# --- Write updated Cargo.toml if --update is passed ---
if args.update and outdated:
    with open(cargo_file, "w") as f:
        toml.dump(cargo_toml, f)
    print("\nCargo.toml has been updated with latest versions.")

