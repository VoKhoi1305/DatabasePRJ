import random
import os.path
from faker import Faker

# Initialize Faker
fake = Faker('vi_VN')

# Function to generate unique Student ID
def generate_unique_student_id(existing_ids):
    while True:
        random_year = random.randint(4, 24)
        student_id = f"20{random_year:02d}{random.randint(1000, 9999)}"
        if student_id not in existing_ids:
            existing_ids.add(student_id)
            return student_id

# Function to generate unique phone number
def generate_unique_phone_number(existing_phone_numbers):
    while True:
        phone_number = f"09{random.randint(0, 9)}-{random.randint(100, 999)}-{random.randint(1000, 9999)}"
        if phone_number not in existing_phone_numbers:
            existing_phone_numbers.add(phone_number)
            return phone_number

# Function to generate Student data
def generate_student_data(num_records):
    student_data = []
    existing_ids = set()  # To store unique student IDs
    existing_phone_numbers = set()  # To store unique phone numbers
    
    for _ in range(num_records):
        student_id = generate_unique_student_id(existing_ids)
        first_name = fake.first_name()
        last_name = fake.last_name()
        birthday = fake.date_of_birth(minimum_age=18, maximum_age=30).strftime('%Y-%m-%d')
        gender = random.choice(['M', 'F'])
        email = fake.email()
        phone_number = generate_unique_phone_number(existing_phone_numbers)
        address = fake.address()
        city = fake.city()
        major = fake.job()
        
        student_data.append((student_id, first_name, last_name, birthday, gender, email, phone_number, address, city, major))
    
    return student_data

# Generate student data
num_records = 100000  # Number of student records to generate
student_data = generate_student_data(num_records)

# Write data to a file
filename = "student_data1.sql"
with open(filename, 'w') as file:
    file.write("INSERT INTO Student (Student_ID, Student_First_Name, Student_Last_Name, Student_Birthday, Student_Gender, Student_Email, Student_Phone_Number, Student_Address, Student_City, Major) VALUES\n")
    for record in student_data:
        file.write(f"('{record[0]}', '{record[1]}', '{record[2]}', '{record[3]}', '{record[4]}', '{record[5]}', '{record[6]}', '{record[7]}', '{record[8]}', '{record[9]}'),\n")

# Append semicolon to the last line
with open(filename, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()

print(f"Student data written to {filename}")
