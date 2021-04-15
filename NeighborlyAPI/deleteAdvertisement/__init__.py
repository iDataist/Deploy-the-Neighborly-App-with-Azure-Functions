import azure.functions as func
import logging
import json
import os
import pymongo
from bson.json_util import dumps
from bson.objectid import ObjectId


def main(req: func.HttpRequest) -> func.HttpResponse:

    id = req.params.get('id')

    if id:
        try:
            url = os.environ['ConnectionStrings']
            client = pymongo.MongoClient(url)
            database = client['mongodb20210411']
            collection = database['adcollection20210411']
            query = {'_id': ObjectId(id)}
            result = collection.delete_one(query)
            return func.HttpResponse("")
        except Exception as e:
            logging.error(e)   
            return func.HttpResponse("Database connection error.", status_code=500)
    else:
        return func.HttpResponse("Please pass an id in the query string",
                                 status_code=400)
