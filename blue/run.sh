#!/bin/bash

export FLASK_ENV=production

if [ "$1" == "blue" ]; then
    gunicorn -w 4 -b 127.0.0.1:8000 app:app
elif [ "$1" == "green" ]; thrn
    gunicorn -w 4 -b 127.0.0.1:8001 app:app
else
    echo "Usage: ./run.sh [blue/green]"
fi