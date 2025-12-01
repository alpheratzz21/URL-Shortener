from flask import Flask, request, render_template
import json
import os
import string
import random

app=Flask(__name__)

# function -> to generate random short code
def generate_code(length=6):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

#function -> load and save data

def load_data():
    if not os.path.exists("storage.json"):
        return{}
    with open("storage.json", "r") as f:
        return json.load(f)

def save_data(data):
    with open("storage.json", "w") as f:
        json.dump(data, f, indent=4)

@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        original_url = request.form.get("url")

        # generate short code
        code = generate_code()

        #save to storage.json

        data = load_data()
        data[code] = original_url
        save_data(data)

        #return result page later ->> just display row
        return f"Short URL created: <b>{code}</b>"

    return render_template("home.html")

if __name__ == "__main__":
    app.run(debug=True)