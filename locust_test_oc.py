import time
from locust import HttpLocust, TaskSet, task, between

class UserTasks(TaskSet):
    wait_time = between(1, 2)

    @task
    def index(self):
        self.client.get("/api/course-topics")

class WebsiteUser(HttpLocust):
    task_set = UserTasks
