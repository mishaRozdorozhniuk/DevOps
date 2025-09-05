from flask import Flask, request, jsonify
import csv
import os

app = Flask(__name__)

CSV_FILE = 'students.csv'


def init_csv():
    if not os.path.exists(CSV_FILE):
        with open(CSV_FILE, 'w', newline='') as f:
            csv.writer(f).writerow(['id', 'first_name', 'last_name', 'age'])

def read_students():
    students = []
    if os.path.exists(CSV_FILE):
        with open(CSV_FILE, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                if row['id']:
                    row['id'] = int(row['id'])
                    row['age'] = int(row['age'])
                    students.append(row)
    return students

def write_students(students):
    with open(CSV_FILE, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['id', 'first_name', 'last_name', 'age'])
        writer.writeheader()
        writer.writerows(students)

@app.route('/students', methods=['GET'])
def get_all_students():
    return jsonify(read_students())

@app.route('/students/<int:id>', methods=['GET'])
def get_student(id):
    students = read_students()
    student = next((s for s in students if s['id'] == id), None)
    if not student:
        return jsonify({'error': 'Student not found'}), 404
    return jsonify(student)

@app.route('/students/lastname/<name>', methods=['GET'])
def get_by_lastname(name):
    students = read_students()
    found = [s for s in students if s['last_name'].lower() == name.lower()]
    if not found:
        return jsonify({'error': 'No students found'}), 404
    return jsonify(found)

@app.route('/students', methods=['POST'])
def create_student():
    data = request.get_json()
    if not data or not all(k in data for k in ['first_name', 'last_name', 'age']):
        return jsonify({'error': 'Missing fields'}), 400

    students = read_students()
    new_id = max([s['id'] for s in students], default=0) + 1

    new_student = {
        'id': new_id,
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'age': int(data['age'])
    }

    students.append(new_student)
    write_students(students)
    return jsonify(new_student), 201

@app.route('/students/<int:id>', methods=['PUT'])
def update_student(id):
    data = request.get_json()
    if not data or not all(k in data for k in ['first_name', 'last_name', 'age']):
        return jsonify({'error': 'Missing fields'}), 400

    students = read_students()
    for s in students:
        if s['id'] == id:
            s['first_name'] = data['first_name']
            s['last_name'] = data['last_name']
            s['age'] = int(data['age'])
            write_students(students)
            return jsonify(s)

    return jsonify({'error': 'Student not found'}), 404

@app.route('/students/<int:id>', methods=['PATCH'])
def update_age(id):
    data = request.get_json()
    if not data or 'age' not in data:
        return jsonify({'error': 'Missing age field'}), 400

    students = read_students()
    for s in students:
        if s['id'] == id:
            s['age'] = int(data['age'])
            write_students(students)
            return jsonify(s)

    return jsonify({'error': 'Student not found'}), 404

@app.route('/students/<int:id>', methods=['DELETE'])
def delete_student(id):
    students = read_students()
    original_count = len(students)
    students = [s for s in students if s['id'] != id]

    if len(students) == original_count:
        return jsonify({'error': 'Student not found'}), 404

    write_students(students)
    return jsonify({'message': f'Student {id} deleted'})

if __name__ == '__main__':
    init_csv()
    app.run(host='127.0.0.1', port=8000, debug=True)
