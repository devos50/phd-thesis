import sqlite3
import os.path

index = 16

db = sqlite3.connect('sqlite' + str(index) + '/trustchain.db')

cursor = db.cursor()
cursor.execute('''SELECT type, COUNT(block_hash) as count FROM blocks GROUP BY type''')
rows = cursor.fetchall()

db.commit()

filename = './experiment.csv'

if not os.path.isfile(filename):
	with open(filename, 'a+') as csvfile:
		csvfile.write("index,block_type,count\n")

with open(filename, 'a+') as csvfile:
	for row in rows:
		csvfile.write(str(index) + "," + row[0] + "," + str(row[1]) + "\n")

db.close()
