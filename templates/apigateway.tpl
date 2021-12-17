[
  {
    "name": "apigateway",
    "image": "${docker_image_url}:${tag}",
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
    "command": ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"],
    "environment": [
      {
        "name": "SECRET_KEY",
        "value": "${apigateway_secret}"
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