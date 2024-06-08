import random
import os
import string
from faker import Faker
from datetime import datetime, timedelta

# Initialize Faker
fake = Faker()

# Function to parse Room IDs from a file
def parse_room_ids(file_path):
    room_ids = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith("('"):
                room_id = line.split(',')[0].strip("('")
                room_ids.append(room_id)
    return room_ids

# Function to parse Student IDs from a file
def parse_student_ids(file_path):
    student_ids = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith("('"):
                student_id = line.split(',')[0].strip("('")
                student_ids.append(student_id)
    return student_ids

# Function to generate unique Renting Contract ID
def generate_unique_renting_contract_id(existing_ids):
    while True:
        renting_contract_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        if renting_contract_id not in existing_ids:
            existing_ids.add(renting_contract_id)
            return renting_contract_id

# Function to generate Renting data
def generate_renting_data(num_records, room_ids, student_ids):
    renting_data = []
    existing_ids = set()  # To store unique renting contract IDs

    for _ in range(num_records):
        renting_contract_id = generate_unique_renting_contract_id(existing_ids)
        room_id = random.choice(room_ids)
        student_id = random.choice(student_ids)
        payment_date = fake.date_between_dates(date_start=datetime(2015, 1, 1), date_end=datetime(2024, 12, 31)).strftime('%Y-%m-%d')
        start_date = (datetime.strptime(payment_date, '%Y-%m-%d') + timedelta(days=random.randint(-30, 30))).strftime('%Y-%m-%d')
        end_date = (datetime.strptime(  start_date, '%Y-%m-%d') + timedelta(days=180)).strftime('%Y-%m-%d')
        status = 'paid'
        
        renting_data.append((renting_contract_id, room_id, student_id, payment_date, start_date, end_date, status))
    
    return renting_data

# Paths to the Room and Student data files
room_file_path = os.path.join("sql", "data", "room_data.sql")
student_file_path = os.path.join("sql", "data", "student_data.sql")

# Parse Room and Student IDs
room_ids = parse_room_ids(room_file_path)
student_ids = parse_student_ids(student_file_path)

# Generate renting data
num_records = 20000  # Number of renting records to generate
renting_data = generate_renting_data(num_records, room_ids, student_ids)

# Write data to a file
filename = os.path.join("sql", "data", "renting_data.sql")
with open(filename, 'w') as file:
    
    for record in renting_data:
        file.write("INSERT INTO Renting (Renting_Contract_ID, Room_ID, Student_ID, Renting_Payment_Date, Renting_Start_Date, Renting_End_Date, Renting_Status) VALUES\n")
        file.write(f"('{record[0]}', '{record[1]}', '{record[2]}', '{record[3]}', '{record[4]}', '{record[5]}', '{record[6]}');\n")

# Append semicolon to the last line
with open(filename, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()
    file.write(b";")

print(f"Renting data written to {filename}")
