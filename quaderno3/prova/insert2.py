names = ['Michele', 'Giuseppe', 'Paolo', 'Marco', 'Luciana', 'Alessandra', 'Giorgia', 'Francesca', 'Claudia']
result = []
fp = open("insertlines.sql", "w")
for i in range(0, int(1e5)):
    empno = i
    empname = names[i % len(names)]
	#result.append(f"VALUES ({empno}, 'empname')")
    fp.write(f"INSERT INTO EMP(Empno, Ename) VALUES ({empno}, '{empname}');\n")
fp.close()


