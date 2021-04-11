import azure.functions as func
import logging
import json
import os
import pymongo
from bson.json_util import dumps
from bson.objectid import ObjectId

def main(req: func.HttpRequest) -> func.HttpResponse:

    id = req.params.get('id')
    request = req.get_json()

    if request:
        try:
            url = os.environ['ConnectionStrings']
            client = pymongo.MongoClient(url)
            database = client['mongodb20210411']
            collection = database['adcollection20210411'] 
            filter_query = {'_id': id}
            update_query = {"$set": request}
            rec_id1 = collection.update_one(filter_query, update_query)
            return func.HttpResponse(status_code=200)
        except Exception as e:
            logging.error(e)   
            return func.HttpResponse("Database connection error.", status_code=500)
    else:
        return func.HttpResponse('Please pass name in the body', status_code=400)

