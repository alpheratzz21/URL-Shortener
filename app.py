from flask import Flask, request, render_template, redirect
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

        short_url = request.host_url + code

        #return result page later ->> just display row
        return render_template("result.html", code=code, short_url=short_url)

    return render_template("home.html")

#function to redirect route
@app.route("/<code>")
def redirect_to_url(code):
    data = load_data()
    url = data.get(code)

    if url:
        return redirect(url)
    else:
        return "Short URL not found", 404

if __name__ == "__main__":
    app.run(debug=True)