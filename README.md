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
    API_URL = "http://localhost:<PORT_NUMBER>/api"

    # ------- For production -------
    # where APP_NAME is your Azure Function App name 
    # API_URL="https://<APP_NAME>.azurewebsites.net/api"
    ```
5. 


4. Publish the Azure Functions and test with Postman.
    ```
    az webapp up \
        --resource-group group20210411 \
        --name neighborlyapp \
        --sku F1 \
        --verbose
    ```



