import random
import string
from faker import Faker
import os

# Initialize Faker
fake = Faker()

# Define the list of positions with more variety
positions = [
    "Dorm Manager", "Maintenance Worker", "Security Guard", "Housekeeper",
    "Administrator", "Cook", "Receptionist", "Resident Advisor",
    "Laundry Staff", "Groundskeeper", "Custodian", "IT Support",
    "Event Coordinator", "Front Desk Clerk", "Health and Safety Officer",
    "Kitchen Staff", "Janitorial Supervisor", "Facilities Coordinator"
]

def generate_unique_phone_number(existing_phone_numbers):
    while True:
        phone_number = f"09{random.randint(0, 9)}-{random.randint(100, 999)}-{random.randint(1000, 9999)}"
        if phone_number not in existing_phone_numbers:
            existing_phone_numbers.add(phone_number)
            return phone_number

# Function to generate a unique staff ID
def generate_unique_staff_id(existing_ids):
    while True:
        staff_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        if staff_id not in existing_ids:
            existing_ids.add(staff_id)
            return staff_id

# Function to generate random staff data
def generate_staff_data(num_records):
    staff_data = []
    existing_ids = set()
    existing_phone_numbers = set() 
    for _ in range(num_records):
        staff_id = generate_unique_staff_id(existing_ids)
        first_name = fake.first_name()
        last_name = fake.last_name()
        gender = random.choice(["M", "F"])
        position = random.choice(positions)
        phone_number = generate_unique_phone_number(existing_phone_numbers)
        address = fake.address().replace("\n", ", ")
        salary = round(random.uniform(500, 2000), 2)
        staff_data.append((staff_id, first_name, last_name, gender, position, phone_number, address, salary))
    return staff_data

# Generate 1000 staff records
staff_records = generate_staff_data(1000)

# Define the output filename
filename = os.path.join("sql", "data", "insert_staff_data.sql")

# Write the SQL insert statements to the file
with open(filename, 'w') as file:
    file.write("INSERT INTO Staff (Staff_ID, Staff_First_Name, Staff_Last_Name, Staff_Gender, Staff_Position, Staff_Phone_Number, Staff_Address, Salary) VALUES\n")
    for record in staff_records[:-1]:
        file.write(f"('{record[0]}', '{record[1]}', '{record[2]}', '{record[3]}', '{record[4]}', '{record[5]}', '{record[6]}', {record[7]}),\n")
    # Write the last record without a comma at the end
    last_record = staff_records[-1]
    file.write(f"('{last_record[0]}', '{last_record[1]}', '{last_record[2]}', '{last_record[3]}', '{last_record[4]}', '{last_record[5]}', '{last_record[6]}', {last_record[7]});\n")

print(f"Staff data written to {filename}")
