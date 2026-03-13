#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2026-Mar-13 09:30
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import json
import time

RAPL_DOMAINS = {
    'psys': '/sys/class/powercap/intel-rapl:1/energy_uj',
    'package': '/sys/class/powercap/intel-rapl:0/energy_uj',
    'core': '/sys/class/powercap/intel-rapl:0:0/energy_uj',
    'uncore': '/sys/class/powercap/intel-rapl:0:1/energy_uj',
}

SAMPLE_INTERVAL = 1  # seconds


def read_energy_uj(path: str) -> int | None:
    try:
        with open(path, 'r') as f:
            return int(f.read().strip())
    except (PermissionError, FileNotFoundError, ValueError):
        return None


def compute_watts(before: dict, after: dict, elapsed: float) -> dict:
    watts = {}
    for name in before:
        if before[name] is not None and after[name] is not None:
            delta = after[name] - before[name]
            if delta < 0:
                # Counter wrapped around
                max_range_path = RAPL_DOMAINS[name].replace('energy_uj', 'max_energy_range_uj')
                max_range = read_energy_uj(max_range_path)
                if max_range is not None:
                    delta += max_range
            watts[name] = delta / 1_000_000 / elapsed
    return watts


def get_power_consumption():
    before = {name: read_energy_uj(path) for name, path in RAPL_DOMAINS.items()}
    time.sleep(SAMPLE_INTERVAL)
    after = {name: read_energy_uj(path) for name, path in RAPL_DOMAINS.items()}

    elapsed = SAMPLE_INTERVAL
    watts = compute_watts(before, after, elapsed)

    if not watts:
        res = {'text': 'N/A', 'tooltip': 'Power: no RAPL data available', 'class': 'custom-power'}
        print(json.dumps(res))
        return

    total = watts.get('package', watts.get('psys', 0))
    text = f'{total:.0f}W'

    lines = ['Power Consumption:']
    for name, w in sorted(watts.items()):
        lines.append(f'  {name}: {w:.1f}W')

    res = {'text': text, 'tooltip': '\n'.join(lines), 'class': 'custom-power'}
    print(json.dumps(res))


def main():
    get_power_consumption()


if __name__ == '__main__':
    main()
