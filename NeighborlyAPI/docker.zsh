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
appRegistry="appregistry$uniqueId"
kuberCluster="kubercluster$uniqueId"
docker="docker$uniqueId"

# https://medium.com/@gcufaro/using-docker-with-azure-functions-9e975fd58c1c
# Part 1: Create a Container Registry
# Create ACR
az acr create \
    --resource-group $resourceGroup \
    --name $appRegistry \
    --sku Basic

az acr login --name $appRegistry

az acr show \
    --name $appRegistry \
    --query loginServer \
    --output table

TOKEN=$(az acr login --name $appRegistry --expose-token --output tsv --query accessToken)

# Login to the registry
docker login $appRegistry.azurecr.io \
    --username 00000000-0000-0000-0000-000000000000 \
    --password $TOKEN

# Part 2: Containerize the App
# Create a Dockerfile
func init --docker-only --python

# Build the docker image
docker build -t $docker .

# Test the image locally
docker run -p 8080:80 -it $docker

# Tag your docker image for Azure Container Registry
docker tag $docker $appRegistry.azurecr.io/$docker:v1
docker images

# Push the image to Azure Container Registry
docker push $appRegistry.azurecr.io/$docker:v1

# check if the docker image is up in the cloud.
az acr repository list \
--name $appRegistry.azurecr.io \
--output table

# Part 3: Create a Kubernetes Cluster
# Make sure the Kubernetes command line tool kubectl is installed by "kubectl version --client"
# Create a Kubernetes cluster on Azure
az aks create \
    --resource-group $resourceGroup \
    --name $kuberCluster \
    --node-count 2 \
    --generate-ssh-keys

# Pull the credentials for the Kubernetes cluster
az aks get-credentials \
    --name $kuberCluster \
    --resource-group $resourceGroup

# Verify the connection to the cluster
kubectl get nodes

# KEDA is Google's opensource tool for Kubernetes event-driven Autoscaling
# set up the KEDA namespace for our Kubernetes cluster
func kubernetes install \
    --namespace keda  

func kubernetes deploy \
--name $kuberCluster \
--image-name $appRegistry.azurecr.io/$docker:v1 \
--dry-run \
> deploy.yml

func kubernetes deploy \
--name $kuberCluster \
--image-name $appRegistry.azurecr.io/$docker:v1 \
—polling-interval 3 \
—cooldown-period 5

kubectl apply -f deploy.yml

# Check the deployment
kubectl config get-contexts

kubectl get service --watch

# # func deploy \
# #     --platform kubernetes \
# #     --name $funcApp \
# #     --registry $appRegistry

