import random
import os.path
from faker import Faker
from datetime import datetime, timedelta
fake = Faker()

def parse_room_ids(file_path):
    room_ids = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith("('"):
                room_id = line.split(',')[0].strip("('")
                room_ids.append(room_id)
    return room_ids

def parse_equipment_ids(file_path):
    equipment_ids = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith("('"):
                equipment_id = line.split(',')[0].strip("('")
                equipment_ids.append(equipment_id)
    return equipment_ids

def generate_usage_data(num_records,equipment_ids,room_ids):
    usage_data = []

    for _ in range(num_records):
        equipment_id = random.choice(equipment_ids)
        room_id = random.choice(room_ids)
        start_date = fake.date_between_dates(date_start=datetime(2024, 1, 1), date_end=datetime(2024, 12, 31)).strftime('%Y-%m-%d')
        end_date = (datetime.strptime(  start_date, '%Y-%m-%d') + timedelta(days=500)).strftime('%Y-%m-%d')
        Using_Quantity = random.randint(2,3)
        usage_data.append((equipment_id, room_id, start_date, end_date,Using_Quantity))
    
    return usage_data

room_file_path = os.path.join("sql", "data", "room_data.sql")
equipment_file_path = os.path.join("sql", "data", "equipment_data.sql")

room_ids = parse_room_ids(room_file_path)
equipment_ids = parse_equipment_ids(equipment_file_path)
num_records = 1000  # Number of renting records to generate
renting_data = generate_usage_data(num_records, room_ids, equipment_ids)

filename = os.path.join("sql", "data", "usage_data.sql")
with open(filename, 'w') as file:
    
    for record in renting_data:
        file.write("INSERT INTO Equipment_Usage (room_id, equipment_id, Equipment_Start_Date, Equipment_End_Date, Using_Quantity) VALUES\n")
        file.write(f"('{record[0]}', '{record[1]}', '{record[2]}', '{record[3]}', '{record[4]}');\n")

# Append semicolon to the last line
with open(filename, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()
    file.write(b";")

print(f"Renting data written to {filename}")