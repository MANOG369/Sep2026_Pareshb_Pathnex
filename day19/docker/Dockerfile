FROM python:3.11

WORKDIR /opt/pathnex/flask-app

COPY app.py /opt/pathnex/flask-app/

RUN pip install --no-cache-dir flask

EXPOSE 5000

CMD ["python", "/opt/pathnex/flask-app/app.py"]
