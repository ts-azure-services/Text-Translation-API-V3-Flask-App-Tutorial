# Tutorial: Build a Flask app with Azure Cognitive Services

With this sample, you'll build a Flask web app that uses Azure Cognitive Services to translate text, analyze sentiment, and synthesize translated text into speech. If you run into any issues, let us know by submitting and issue.

## What is Flask?

Flask is a microframework for creating web applications. This means Flask provides you with tools, libraries, and technologies that allow you to build a web application. This web application can be some web pages, a blog, a wiki or go as substantive as a web-based calendar application or a commercial website.

For those of you who want to deep dive after this tutorial here are a few helpful links:

* [Flask documentation](http://flask.pocoo.org/)
* [Flask for Dummies - A Beginner's Guide to Flask](https://codeburst.io/flask-for-dummies-a-beginners-guide-to-flask-part-uno-53aec6afc5b1)
## Steps
1. Create a virtual environment called `flaskapp`, by running `conda create -n flaskapp python=3.9`.
2. Activat the virtual environment, by running `conda activate flaskapp`.
3. Run `make infra` at the root directory, using the Makefile.
> This will create the translator resource, the speech resource and the text analytics resource, and save the
relevant keys to the `variables.env` file.
4. Run `make setup` to install the relevant third-party libraries.
> This will install the `requests` library, the `python-dotenv` library for handling environment variables and the `flask` library.
5. To validate the flask install, run `flask --version`.
6. Run the flask app by executing the following at the command line:
	1. `export FLASK_APP=app.py`
	2. `export FLASK_DEBUG=1`
7. To run the flask app, execute `flask run`.
8. Navigate to the URL provided and test your app.
