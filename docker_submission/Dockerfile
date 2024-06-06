FROM python:3.11.9-slim-bullseye

WORKDIR /usr/local/bin

RUN pip install pandas scikit-learn scipy

COPY pred.py .

ENTRYPOINT [ "python" ]
CMD [ "pred.py" ]
