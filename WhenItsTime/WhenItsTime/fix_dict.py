import json

lines = []
with open("TimeZoneCountryCode.swift", "r") as f:
    lines = f.readlines()

missing = {
    "America/Godthab": "GL",
    "America/Montreal": "CA",
    "America/Nipigon": "CA",
    "America/Pangnirtung": "CA",
    "America/Rainy_River": "CA",
    "America/Santa_Isabel": "MX",
    "America/Shiprock": "US",
    "America/Thunder_Bay": "CA",
    "America/Yellowknife": "CA",
    "Antarctica/South_Pole": "AQ",
    "Asia/Calcutta": "IN",
    "Asia/Choibalsan": "MN",
    "Asia/Chongqing": "CN",
    "Asia/Harbin": "CN",
    "Asia/Kashgar": "CN",
    "Asia/Katmandu": "NP",
    "Asia/Rangoon": "MM",
    "Australia/Currie": "AU",
    "Europe/Kiev": "UA",
    "Europe/Uzhgorod": "UA",
    "Europe/Zaporozhye": "UA",
    "Pacific/Enderbury": "KI",
    "Pacific/Johnston": "UM",
    "Pacific/Ponape": "FM",
    "Pacific/Truk": "FM"
}

# insert before the last "]"
out = "".join(lines[:-1])
for k, v in missing.items():
    out += f'    "{k}": "{v}",\n'
out += "]\n"

with open("Models/TimeZoneCountryCode.swift", "w") as f:
    f.write(out)
