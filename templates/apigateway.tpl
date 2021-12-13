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
    "environment": [],
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