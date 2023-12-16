from random import randint, choice
from string import ascii_letters

def generate_insert(tab_name, fp):
    for c in range(0, int(lengths[tab_name])):
        id_tab = c
        if int(tab_name[-1]) %2 != 0:
            value = f"'{choice(ascii_letters)}'"
        else:
            value = randint(1970, 2020)
        fp.write(f"INSERT INTO {tab_name}({schema[tab_name]}) VALUES({id_tab}, {value});\n")
    fp.write("\n")

lengths = {
    "TAB1": 5e5,
    "TAB2": 5e4,
    "TAB3": 1e5,
    "TAB4": 5
}
schema = {
    "TAB1": "id1, nome",
    "TAB2": "id2, annoNascita",
    "TAB3": "id3, nome",
    "TAB4": "id4, annoNascita"
}
fp = open("insert_into_prova.sql", mode="w")

for tab in lengths:
    generate_insert(tab, fp)

fp.close()
