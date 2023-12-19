from random import randint
regioni = ['Liguria', 'Piemonte', 'Lombardia', 'Valle Aosta', 'Trentino', 'Veneto', 'Emilia-Romagna', 'Friuli-Venezia Giulia']

ip_list = []
for i in range(1,int(1e4)+1):
    if i % 10 == 0:
        ip_list.append(f"INSERT INTO IP(Pid, Regione) VALUES ({i}, '{regioni[randint(0,1)]}');")
    else:
        ip_list.append(f"INSERT INTO IP(Pid, Regione) VALUES ({i}, '{regioni[randint(2, len(regioni)-1)]}');")

insert_ip = "\n".join(ip_list)

so_list = []
for i in range(0, int(2e5)):
    so_list.append(f"INSERT INTO SO(Pid, Sid) VALUES ({randint(1,int(1e4))}, {randint(1,100)});")

insert_so = "\n".join(so_list[0:int(1e4)])

fp = open("insert_ip.sql", "w")
fp.write(insert_ip)
fp.close()

fp = open("insert_so.sql", "w")
fp.write(insert_so)
fp.close()


