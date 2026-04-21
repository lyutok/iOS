import csv

out = "let timeZoneToCountryCode: [String: String] = [\n"

with open("/usr/share/zoneinfo/zone.tab", "r") as f:
    for line in f:
        if line.startswith("#"):
            continue
        parts = line.strip().split("\t")
        if len(parts) >= 3:
            cc = parts[0]
            tz = parts[2]
            out += f'    "{tz}": "{cc}",\n'

out += "]\n"

with open("TimeZoneCountryCode.swift", "w") as f:
    f.write(out)
