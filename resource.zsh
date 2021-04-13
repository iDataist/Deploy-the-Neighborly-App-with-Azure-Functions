# Variables for MongoDB API resources
uniqueId=20210411
resourceGroup="group$uniqueId"
location='westus2'
account="cosmos$uniqueId" #needs to be lower case
serverVersion='3.6' #3.2 or 3.6
database="mongodb$uniqueId"
adCollection="adcollection$uniqueId"
postCollection="postcollection$uniqueId"
storageAccount="blob$uniqueId" 
funcApp="funcapp$uniqueId"

# Create a resource group
az group create -n $resourceGroup -l $location

# Create a Cosmos account for MongoDB API
az cosmosdb create \
    -n $account \
    -g $resourceGroup \
    --kind MongoDB \
    --server-version $serverVersion \
    --default-consistency-level Eventual \
    --locations regionName='West US 2' failoverPriority=0 isZoneRedundant=False 
    # --locations regionName='East US 2' failoverPriority=1 isZoneRedundant=False

# Create a MongoDB API database
az cosmosdb mongodb database create \
    -a $account \
    -g $resourceGroup \
    -n $database

# Create a MongoDB API collection
az cosmosdb mongodb collection create \
    -a $account \
    -g $resourceGroup \
    -d $database \
    -n $adCollection \
    --throughput 400 

az cosmosdb mongodb collection create \
    -a $account \
    -g $resourceGroup \
    -d $database \
    -n $postCollection \
    --throughput 400 

# Import data from json files to the MongoDB API collections
MONGOGB_HOST="$account.mongo.cosmos.azure.com"
MONGODB_PORT="10255"
PRIMARY_PW=$(az cosmosdb keys list -g $resourceGroup -n $account --query primaryMasterKey --output tsv) 
COSMOS_DB_CONNECTION_STRING=$(az cosmosdb keys list -g $resourceGroup -n $account --type connection-strings --query 'connectionStrings[0].connectionString' --output tsv) 
mongoimport -h $MONGOGB_HOST:$MONGODB_PORT -d $database -c $adCollection -u $account -p  $PRIMARY_PW --ssl --jsonArray --file ads.json --writeConcern="{w:0}"
mongoimport -h $MONGOGB_HOST:$MONGODB_PORT -d $database -c $postCollection -u $account -p  $PRIMARY_PW --ssl --jsonArray --file posts.json --writeConcern="{w:0}"

# Create a storage account
az storage account create \
    --name $storageAccount \
    --resource-group $resourceGroup \
    --location $location

# Creat a function app
az functionapp create \
    --resource-group $resourceGroup \
    --name $funcApp \
    --storage-account $storageAccount \
    --os-type Linux \
    --consumption-plan-location $location \
    --runtime python

