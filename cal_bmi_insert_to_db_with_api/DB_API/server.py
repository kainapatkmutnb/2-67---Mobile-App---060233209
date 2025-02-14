import pymysql
from werkzeug.wrappers import Request, Response
from flask import flash, render_template, request, jsonify, Flask
from flaskext.mysql import MySQL

app = Flask(__name__)
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'root'
#app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'emp'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)

@app.route("/")
def hello():
    return """
    Flask API !<br>
    <a href='/new_user'>add</a> insert new<br>
    <a href='/emp'>emp</a> Show all<br>
    <b>/create</b> Insert new Record<br>
    <b>/emp/<id></b> get by ID<br>
    <b>/update/<id></b> Edit info<br>
    <b>/delete/<id></b> Delete by  ID<br>
    """

@app.route('/new_user')
def add_user_view():
    return render_template('add.html')

@app.route('/create', methods=['POST'])
def create_emp():
    try:
        _json = request.json
        _name = _json['name']
        _email = _json['email']
        _phone = _json['phone']
        _address = _json['address']
        _height = _json['height']
        _weight = _json['weight']
        _bmi = _json['bmi']
        _bmiType = _json['bmiType']
        if _name and _email and _phone and _address and _height and _weight and _bmi and _bmiType and request.method == 'POST':
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            sqlQuery = """INSERT INTO emp(name, email, phone, address, height, weight, bmi, bmiType) 
                          VALUES(%s, %s, %s, %s, %s, %s, %s, %s)"""
            bindData = (_name, _email, _phone, _address, _height, _weight, _bmi, _bmiType)
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Employee added successfully!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@app.route('/emp')
def emp():
    try:
        conn = mysql.connect()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.execute("SELECT id, name, email, phone, address, height, weight, bmi, bmiType FROM emp")
        empRows = cursor.fetchall()
        response = jsonify(empRows)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@app.route('/emp/<int:emp_id>')
def emp_details(emp_id):
    try:
        conn = mysql.connect()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.execute("SELECT id, name, email, phone, address, height, weight, bmi, bmiType FROM emp WHERE id =%s", emp_id)
        empRow = cursor.fetchone()
        response = jsonify(empRow)
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@app.route('/update/<int:emp_id>', methods=['PUT'])
def update_emp(emp_id):
    try:
        _json = request.json
        _name = _json['name']
        _email = _json['email']
        _phone = _json['phone']
        _address = _json['address']
        _height = _json['height']
        _weight = _json['weight']
        _bmi = _json['bmi']
        _bmiType = _json['bmiType']
        if _name and _email and _phone and _address and _height and _weight and _bmi and _bmiType and emp_id and request.method == 'PUT':
            sqlQuery = """UPDATE emp SET name=%s, email=%s, phone=%s, address=%s, height=%s, weight=%s, bmi=%s, bmiType=%s WHERE id=%s"""
            bindData = (_name, _email, _phone, _address, _height, _weight, _bmi, _bmiType, emp_id)
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.execute(sqlQuery, bindData)
            conn.commit()
            response = jsonify('Employee updated successfully!')
            response.status_code = 200
            return response
        else:
            return showMessage()
    except Exception as e:
        print(e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@app.route('/delete/<int:emp_id>', methods=['DELETE'])
def delete_emp(emp_id):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM emp WHERE id =%s", (emp_id,))
        conn.commit()
        response = jsonify('Employee deleted successfully!')
        response.status_code = 200
        return response
    except Exception as e:
        print(e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

if __name__ == '__main__':
    from werkzeug.serving import run_simple
    app.debug = True
    run_simple('localhost', 8080, app)