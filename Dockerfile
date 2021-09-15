FROM python:3.5

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN pip install setuptools

RUN pip install --no-cache-dir -r /usr/src/app/test-app/requirements.txt

CMD ["python", "start.py"]