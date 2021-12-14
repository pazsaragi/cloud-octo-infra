[
  {
    "name": "apigateway",
    "image": "${docker_image_url_django}:${tag}",
    "essential": true,
    "cpu": 256,
    "memory": 512,
    "mountPoints": [],
    "links": [],
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "command": ["gunicorn", "-w", "3", "-b", ":80", "apig.wsgi:application"],
    "environment": [
      {
        "name": "SECRET_KEY",
        "value": "${apigateway_secret}"
      },
      {
        "name": "DB_NAME",
        "value": "${db_name}"
      },
      {
        "name": "DB_USER",
        "value": "${db_username}"
      },
      {
        "name": "DB_PASSWORD",
        "value": "${db_password}"
      },
      {
        "name": "DB_HOST",
        "value": "${db_host}"
      },
      {
        "name": "DB_PORT",
        "value": "${db_port}"
      },
      {
        "name": "PROTECTED_ROUTES",
        "value": '["order"]'
      },
      {
        "name": "ORDER_QUEUE_URL",
        "value": "${order_queue_url}"
      },
      {
        "name": "DEBUG",
        "value": "${debug}"
      },
      {
        "name": "ALLOWED_HOSTS",
        "value": "${allowed_hosts}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group_name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${log_stream_name}"
      }
    },
    "volumesFrom": []
  }
]