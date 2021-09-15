import tornado.ioloop
import tornado.web
from pymongo import MongoClient
import random
import json

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        id = random.randint(0, 1)
        result = collection.find_one({"_id": id})
        welcome = "Hello World, " + str(result["name"]) + " " + str(result["surname"]) + "!"
        self.write(welcome)

def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ], debug=True)

def addData(collection):
    data1 = {"_id":0, "name":"Miguel", "surname":"Carvalho"}
    data2 = {"_id":1, "name":"Joao", "surname":"Ricardo"}
    collection.insert_many([data1, data2])

if __name__ == "__main__":
    
    # Connect to Mongo
    server = MongoClient("mongodb://mongodb:27017/")
    db = server["test"]
    collection = db["test"]

    if not collection.find_one({"_id": 0}):
        addData(collection)

    app = make_app()
    app.listen(8080)
    tornado.ioloop.IOLoop.current().start()