# Deploying the Neighborly App with Azure Functions

## Project Overview

I built a web application called "Neighborly" that allows neighbors to post advertisements for services and products they can offer. The front-end application is built with the Python Flask micro framework. The application makes direct requests to the back-end API endpoints, which allow users to view, create, edit, and delete the community advertisements.


## Dependencies

You will need to install the following locally:

- [Pipenv](https://pypi.org/project/pipenv/)
- [Visual Studio Code](https://code.visualstudio.com/download)
- [Azure Function tools V3](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#install-the-azure-functions-core-tools)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Azure Tools for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack)
- [MongoDB Database Tools](https://www.mongodb.com/try/download/database-tools)

On Mac, you can do this with:

```bash
# install pipenv
brew install pipenv

# install azure-cli
brew update && brew install azure-cli

# install azure function core tools 
brew tap azure/functions
brew install azure-functions-core-tools@3

# get the mongodb library
brew install mongodb-community@4.2

# check if mongoimport lib exists
mongoimport --version
```

## Steps to deploy the webapp

1. Create the resources in Azure by running the command below. The output should look like [resource_output.txt](https://github.com/iDataist/Deploying-the-Neighborly-App-with-Azure-Functions/blob/main/Output/resource_output.txt). 
    ```
    zsh resource.zsh
    ```
    ![](output/resource-group.png)

2. Save the connection string of cosmos account in [local.settings.json](https://github.com/iDataist/Deploying-the-Neighborly-App-with-Azure-Functions/blob/main/NeighborlyAPI/local.settings.json) and the function app configuration.

    ![](output/funcapp-configuration.png)

3. Deploy the Azure Functions locally and test with Postman. 

    ```bash
    # cd into NeighborlyAPI
    cd NeighborlyAPI

    # install dependencies
    pipenv install

    # go into the shell
    pipenv shell

    # test func locally
    func start
    ```

    ![](output/funcapp-local-test.png)

4. Update the Client-side [settings.py](https://github.com/iDataist/Deploying-the-Neighborly-App-with-Azure-Functions/blob/main/NeighborlyFrontEnd/settings.py) with published API endpoints. 
    ```bash
    # Inside file settings.py

    # ------- For Local Testing -------
    #API_URL = "http://localhost:<PORT_NUMBER>/api"

    # ------- For production -------
    # where APP_NAME is your Azure Function App name 
    API_URL="https://<APP_NAME>.azurewebsites.net/api"
    ```
4. Publish the Azure Functions and test with Postman.
    ```
    az webapp up \
        --resource-group group20210411 \
        --name neighborlyapp \
        --sku F1 \
        --verbose
    ```





    


### II. Deploying the client-side Flask web application

We are going to update the Client-side `settings.py` with published API endpoints. First navigate to the `settings.py` file in the NeighborlyFrontEnd/ directory.

Use a text editor to update the API_URL to your published url from the last step.
```bash
# Inside file settings.py

# ------- For Local Testing -------
#API_URL = "http://localhost:7071/api"

# ------- For production -------
# where APP_NAME is your Azure Function App name 
API_URL="https://<APP_NAME>.azurewebsites.net/api"
```

### III. CI/CD Deployment

1. Deploy your client app. **Note:** Use a **different** app name here to deploy the front-end, or else you will erase your API. From within the `NeighborlyFrontEnd` directory:
    - Install dependencies with `pipenv install`
    - Go into the pip env shell with `pipenv shell`
    - Deploy your application to the app service. **Note:** It may take a minute or two for the front-end to get up and running if you visit the related URL.

    Make sure to also provide any necessary information in `settings.py` to move from localhost to your deployment.

2. Create an Azure Registry and dockerize your Azure Functions. Then, push the container to the Azure Container Registry.
3. Create a Kubernetes cluster, and verify your connection to it with `kubectl get nodes`.
4. Deploy app to Kubernetes, and check your deployment with `kubectl config get-contexts`.

### IV. Event Hubs and Logic App

1. Create a Logic App that watches for an HTTP trigger. When the HTTP request is triggered, send yourself an email notification.
2. Create a namespace for event hub in the portal. You should be able to obtain the namespace URL.
3. Add the connection string of the event hub to the Azure Function.

### V.  Cleaning Up Your Services

Before completing this step, make sure to have taken all necessary screenshots for the project! Check the rubric in the classroom to confirm.

Clean up and remove all services, or else you will incur charges.

```bash
# replace with your resource group
RESOURCE_GROUP="<YOUR-RESOURCE-GROUP>"
# run this command
az group delete --name $RESOURCE_GROUP
```
