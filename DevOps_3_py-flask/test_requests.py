import requests
import json

URL = 'http://127.0.0.1:8000'

def test_api():
    with open('results.txt', 'w') as f:
        results = []

        print("1. GET all students")
        r = requests.get(f'{URL}/students')
        result = f"1. GET all: {r.status_code} - {r.json()}"
        print(result)
        results.append(result)

        students = [
            {"first_name": "John", "last_name": "Doe", "age": 20},
            {"first_name": "Jane", "last_name": "Smith", "age": 22},
            {"first_name": "Bob", "last_name": "Johnson", "age": 19}
        ]

        created_ids = []
        for i, student in enumerate(students, 1):
            print(f"2.{i} POST create student")
            r = requests.post(f'{URL}/students', json=student)
            if r.status_code == 201:
                created_ids.append(r.json()['id'])
            result = f"2.{i} POST: {r.status_code} - {r.json()}"
            print(result)
            results.append(result)

        print("3. GET all students")
        r = requests.get(f'{URL}/students')
        result = f"3. GET all: {r.status_code} - {r.json()}"
        print(result)
        results.append(result)

        if len(created_ids) >= 2:
            print("4. PATCH second student age")
            r = requests.patch(f'{URL}/students/{created_ids[1]}', json={"age": 25})
            result = f"4. PATCH: {r.status_code} - {r.json()}"
            print(result)
            results.append(result)

            print("5. GET second student")
            r = requests.get(f'{URL}/students/{created_ids[1]}')
            result = f"5. GET: {r.status_code} - {r.json()}"
            print(result)
            results.append(result)

        if len(created_ids) >= 3:
            print("6. PUT third student")
            r = requests.put(f'{URL}/students/{created_ids[2]}',
                           json={"first_name": "Robert", "last_name": "Williams", "age": 21})
            result = f"6. PUT: {r.status_code} - {r.json()}"
            print(result)
            results.append(result)

            print("7. GET third student")
            r = requests.get(f'{URL}/students/{created_ids[2]}')
            result = f"7. GET: {r.status_code} - {r.json()}"
            print(result)
            results.append(result)

        print("8. GET all students")
        r = requests.get(f'{URL}/students')
        result = f"8. GET all: {r.status_code} - {r.json()}"
        print(result)
        results.append(result)

        if created_ids:
            print("9. DELETE first student")
            r = requests.delete(f'{URL}/students/{created_ids[0]}')
            result = f"9. DELETE: {r.status_code} - {r.json()}"
            print(result)
            results.append(result)

        print("10. GET all students")
        r = requests.get(f'{URL}/students')
        result = f"10. GET all: {r.status_code} - {r.json()}"
        print(result)
        results.append(result)

        for result in results:
            f.write(result + '\n')

if __name__ == '__main__':
    test_api()
