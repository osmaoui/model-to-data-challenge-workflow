FROM python:3.11.9-slim-bullseye

WORKDIR /usr/local/bin

RUN pip install pandas scikit-learn scipy pickle

COPY validate.py .
COPY score.py .

ENTRYPOINT [ "python" ]
CMD [ "score.py" ]
