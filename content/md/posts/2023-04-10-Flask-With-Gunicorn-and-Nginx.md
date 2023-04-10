{
  :title "Flask API served using Gunicorn and Nginx"
  :layout :post
  :tags ["python", "nginx"]
  :toc true}
 
 ---
## Notes

Configurations for using a Flask application using Gunicorn and Nginx. The application will respond to http and https requests
over port 5000.


## Install dependencies


```
> sudo apt install python3-pip python3-dev python3-venv nginx

```

## Python environment

```
> python3 -m venv env
> source env/bin/activate
> pip3 install flask gunicorn

```

## Python Application

```
>vim ~/project/app.py
```

```python

from flask import Flask
app = Flask(__name__)
@app.route("/")
def hello():
    return "Welcome to Flask Application!"
if __name__ == "__main__":
    app.run(host='0.0.0.0')

```

## Create WSGI entrypoint

```
> vim ~/project/wsgi.py
```

```python
from app import app
if __name__ == "__main__":
    app.run()
```

```
> deactivate
```

## Create Systemd service file for Flask Application

```
> vi /etc/systemd/system/flask.service
```

```
[Unit]
Description=Gunicorn instance to serve Flask
After=network.target
[Service]
User=root
Group=www-data
WorkingDirectory=/home/<user>/project
Environment="PATH=/home/<user>/project/env/bin"
ExecStart=/home/<user>/project/env/bin/gunicorn --bind unix:/home/<user>/project/request.sock wsgi:app
[Install]
WantedBy=multi-user.target

```

```
> chown -R root:www-data /home/<user>/project
> chmod -R 775 /home/<user>/project
> systemctl daemon-reload
> systemctl start flask
> systemctl enable flask
> systemctl status flask
```

## Configure Nginx as reverse proxy

```
> vim /etc/nginx/sites-available/flask.conf
```

```
server {
  listen <server_ip>:5002 ssl http2;
  listen <server_ip>:5001;

  ssl_certificate /home/<user>/project/cert.pem;
  ssl_certificate_key /home/<user>/project/key.pem;

  access_log /home/<user>/project/rest_api.access.log;
  error_log /home/<user>/project/rest_api.error.log;



  location / {
    include proxy_params;
    proxy_pass http://unix:/home/<user>/project/request.sock;
   }

}

```

```
> vim /etc/nginx/nginx.conf
```

At the end of file add:

```
stream {
    upstream http {
        server <server_ip>:5001;
    }

    upstream https {
        server <server_ip>:5002;
    }

    map $ssl_preread_protocol $upstream {
        default https;
        "" http;
    }

    # SSH and SSL on the same port
    server {
        listen 5000;

        proxy_pass $upstream;
        ssl_preread on;
    }
}


```

```
> sudo ln -s /etc/nginx/sites-available/flask.conf /etc/nginx/sites-enabled
```

```
> nginx -t
> systemctl restart nginx
```


## Support Materials

[Rosehosting](https://www.rosehosting.com/blog/how-to-deploy-flask-application-with-nginx-and-gunicorn-on-ubuntu-20-04/)
[Keval Nagda](https://kevalnagda.github.io/flask-app-with-wsgi-and-nginx)
[miguelgrinberg.com](https://blog.miguelgrinberg.com/post/running-your-flask-application-over-https)
