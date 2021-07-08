import time
from locust import HttpUser, TaskSet, task, between

# host=https://botpress-chitchat-project-interakt-staging.apps.prod.lxp.academy.who.int

class UserTasks(TaskSet):
    wait_time = between(1, 2)

    @task
    def index(self):
        self.client.get("/api/course-topics")

class WebsiteUser(HttpUser):
    task_set = UserTasks
