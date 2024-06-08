import random
import os
import string
from faker import Faker
from datetime import datetime, timedelta

# Initialize Faker
fake = Faker()

# Function to parse IDs from a file
def parse_ids(file_path):
    ids = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith("('"):
                id_value = line.split(',')[0].strip("('")
                ids.append(id_value)
    return ids

# Function to generate unique Service Registration ID
def generate_unique_service_registration_id(existing_ids):
    while True:
        service_registration_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        if service_registration_id not in existing_ids:
            existing_ids.add(service_registration_id)
            return service_registration_id

# Function to generate Service Registration data
def generate_service_registration_data(num_records, service_ids, student_ids):
    service_registration_data = []
    existing_ids = set()  # To store unique service registration IDs

    for _ in range(num_records):
        service_registration_id = generate_unique_service_registration_id(existing_ids)
        service_id = random.choice(service_ids)
        student_id = random.choice(student_ids)
        service_start_date = fake.date_between_dates(date_start=datetime(2015, 1, 1), date_end=datetime(2024, 12, 31)).strftime('%Y-%m-%d')
        service_end_date = (datetime.strptime(service_start_date, '%Y-%m-%d') + timedelta(days=random.randint(30, 365))).strftime('%Y-%m-%d')
        service_payment_date = (datetime.strptime(service_start_date, '%Y-%m-%d') + timedelta(days=random.randint(-30,30))).strftime('%Y-%m-%d')
        service_status = random.choice(['active', 'inactive'])

        service_registration_data.append((
            service_registration_id, service_id, student_id, service_start_date, service_end_date,
            service_payment_date, service_status
        ))
    
    return service_registration_data

# Paths to the Service and Student data files
service_file_path = os.path.join("sql", "data", "service_data.sql")
student_file_path = os.path.join("sql", "data", "student_data.sql")

# Parse Service and Student IDs
service_ids = parse_ids(service_file_path)
student_ids = parse_ids(student_file_path)

# Generate service registration data
num_records = 1000  # Number of service registration records to generate
service_registration_data = generate_service_registration_data(num_records, service_ids, student_ids)

# Write data to a file
filename = os.path.join("sql", "data", "service_registration_data.sql")
with open(filename, 'w') as file:
    file.write("INSERT INTO Service_Registration (Service_ID, Student_ID, Service_Start_Date, Service_End_Date, Service_Payment_Date, Service_Status) VALUES\n")
    for record in service_registration_data:
        file.write(f"('{record[0]}', '{record[1]}', '{record[2]}', '{record[3]}', '{record[4]}', '{record[5]}','{record[6]}'),\n")

# Append semicolon to the last line
with open(filename, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()
    file.write(b";")

print(f"Service registration data written to {filename}")